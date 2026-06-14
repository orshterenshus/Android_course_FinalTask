import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../models/book.dart';

/// Handles downloading book files to the device, checking whether they are
/// already present locally, and opening them in the system viewer.
///
/// Downloaded files are stored under the app's private documents directory in
/// a `books/` sub-folder, so they are sandboxed to the app and removed on
/// uninstall.
class DownloadService {
  DownloadService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  /// Returns the absolute local path where [book] is (or would be) stored.
  ///
  /// The book's Firestore id is prefixed to the file name so two different
  /// books that happen to share a file name never collide on disk.
  Future<String> localPathFor(Book book) async {
    final dir = await getApplicationDocumentsDirectory();
    final booksDir = Directory('${dir.path}/books');
    if (!await booksDir.exists()) {
      await booksDir.create(recursive: true);
    }
    return '${booksDir.path}/${book.id}_${book.fileName}';
  }

  /// Whether [book] has already been downloaded to this device.
  Future<bool> isDownloaded(Book book) async {
    final path = await localPathFor(book);
    return File(path).exists();
  }

  /// Downloads [book] to local storage and returns the saved file path.
  ///
  /// [onProgress] (0.0–1.0) is called as bytes arrive so the caller can drive
  /// a progress indicator.
  Future<String> download(
    Book book, {
    void Function(double progress)? onProgress,
  }) async {
    final path = await localPathFor(book);
    await _dio.download(
      book.downloadUrl,
      path,
      onReceiveProgress: (received, total) {
        if (total > 0 && onProgress != null) {
          onProgress(received / total);
        }
      },
    );
    return path;
  }

  /// Opens an already-downloaded [book] using the device's default viewer.
  ///
  /// Returns the [OpenResult] so the caller can react if, for example, no app
  /// is installed that can open `.docx` files.
  Future<OpenResult> open(Book book) async {
    final path = await localPathFor(book);
    return OpenFilex.open(path);
  }

  /// Removes the locally-downloaded copy of [book], if one exists.
  Future<void> deleteLocal(Book book) async {
    final file = File(await localPathFor(book));
    if (await file.exists()) {
      await file.delete();
    }
  }
}
