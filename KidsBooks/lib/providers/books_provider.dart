import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';

import '../core/enums.dart';
import '../models/book.dart';
import '../services/database_service.dart';
import '../services/download_service.dart';
import '../services/storage_service.dart';

/// The download lifecycle of a single book on this device.
enum DownloadStatus { notDownloaded, downloading, downloaded }

/// Per-book download state: its [status] and current [progress] (0.0–1.0).
class BookDownloadState {
  const BookDownloadState({
    this.status = DownloadStatus.notDownloaded,
    this.progress = 0.0,
  });

  final DownloadStatus status;
  final double progress;
}

/// Drives a single [CategoryScreen]: it loads the books for one
/// (age group, file type) pair and tracks the per-book download status.
///
/// One instance is created per category screen, so its lifecycle is tied to
/// that screen. Call [refresh] to reload (e.g. after a new upload).
class BooksProvider extends ChangeNotifier {
  BooksProvider({
    required this.ageGroup,
    required this.fileType,
    DatabaseService? databaseService,
    DownloadService? downloadService,
    StorageService? storageService,
  })  : _database = databaseService ?? DatabaseService(),
        _downloads = downloadService ?? DownloadService(),
        _storage = storageService ?? StorageService() {
    load();
  }

  /// The age bracket shown on this screen.
  final AgeGroup ageGroup;

  /// The document format shown on this screen.
  final FileType fileType;

  final DatabaseService _database;
  final DownloadService _downloads;
  final StorageService _storage;

  List<Book> _books = const [];
  bool _isLoading = true;
  Object? _error;

  /// Per-book download state, keyed by [Book.id].
  final Map<String, BookDownloadState> _states = {};

  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  Object? get error => _error;

  /// Returns the download state for [book], defaulting to "not downloaded".
  BookDownloadState stateFor(Book book) =>
      _states[book.id] ?? const BookDownloadState();

  /// Loads the books from the database and reconciles local download state.
  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _books = await _database.fetchBooks(
        ageGroup: ageGroup,
        fileType: fileType,
      );
      _error = null;
    } catch (e) {
      _error = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    await _refreshDownloadStates();
  }

  /// Re-loads the list — used after a successful upload so the new book shows.
  Future<void> refresh() => load();

  /// For every book, check whether its file already exists on disk and update
  /// its state accordingly (unless it is mid-download).
  Future<void> _refreshDownloadStates() async {
    for (final book in _books) {
      if (stateFor(book).status == DownloadStatus.downloading) continue;
      final downloaded = await _downloads.isDownloaded(book);
      _states[book.id] = BookDownloadState(
        status: downloaded
            ? DownloadStatus.downloaded
            : DownloadStatus.notDownloaded,
      );
    }
    notifyListeners();
  }

  /// Downloads [book], streaming progress into its [BookDownloadState] so the
  /// UI can show a spinner, then flips it to "downloaded".
  Future<void> download(Book book) async {
    _states[book.id] = const BookDownloadState(
      status: DownloadStatus.downloading,
    );
    notifyListeners();

    try {
      await _downloads.download(
        book,
        onProgress: (p) {
          _states[book.id] = BookDownloadState(
            status: DownloadStatus.downloading,
            progress: p,
          );
          notifyListeners();
        },
      );
      _states[book.id] =
          const BookDownloadState(status: DownloadStatus.downloaded);
    } catch (_) {
      // On failure, reset so the user can tap GET again.
      _states[book.id] =
          const BookDownloadState(status: DownloadStatus.notDownloaded);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  /// Opens an already-downloaded [book] in the system's default viewer.
  Future<OpenResult> open(Book book) => _downloads.open(book);

  /// Permanently deletes [book]: its file in Storage, its database row, and any
  /// locally-downloaded copy. Then removes it from the in-memory list.
  Future<void> deleteBook(Book book) async {
    await _storage.deleteFile(book.storagePath);
    await _database.deleteBook(book.id);
    await _downloads.deleteLocal(book);
    _books = _books.where((b) => b.id != book.id).toList(growable: false);
    _states.remove(book.id);
    notifyListeners();
  }
}
