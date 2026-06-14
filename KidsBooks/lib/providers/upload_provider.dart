import 'dart:io';

// Aliased because `file_picker` also exports a `FileType` symbol which would
// otherwise clash with our own [FileType] enum from `core/enums.dart`.
import 'package:file_picker/file_picker.dart' as picker;
import 'package:flutter/foundation.dart';

import '../core/enums.dart';
import '../models/book.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';

/// Outcome of an upload attempt, so the UI can show the right feedback.
enum UploadOutcome { success, cancelled, failure }

/// Handles the full "Upload Book" flow for one category:
/// pick a file (restricted to the allowed extensions) → upload it to Supabase
/// Storage → save its metadata to the database.
///
/// Exposes [isUploading] so the UI can present a progress indicator while the
/// upload runs.
class UploadProvider extends ChangeNotifier {
  UploadProvider({
    required this.ageGroup,
    required this.fileType,
    StorageService? storageService,
    DatabaseService? databaseService,
  })  : _storage = storageService ?? StorageService(),
        _database = databaseService ?? DatabaseService();

  /// The age bracket new uploads are tagged with.
  final AgeGroup ageGroup;

  /// The format new uploads must match.
  final FileType fileType;

  final StorageService _storage;
  final DatabaseService _database;

  bool _isUploading = false;

  bool get isUploading => _isUploading;

  /// Runs the upload flow and returns its [UploadOutcome].
  ///
  /// The file-picker is restricted to [FileType.allowedExtensions] for the
  /// current category, enforcing the rule that Word screens only accept
  /// `.doc`/`.docx` and PDF screens only accept `.pdf`.
  ///
  /// [title] is the display name the user typed for the book.
  Future<UploadOutcome> pickAndUpload({required String title}) async {
    if (_isUploading) return UploadOutcome.failure;

    // 1. Let the user pick a file, restricted to the allowed extensions.
    final result = await picker.FilePicker.pickFiles(
      type: picker.FileType.custom,
      allowedExtensions: fileType.allowedExtensions,
      withData: false,
    );

    final pickedPath = result?.files.single.path;
    if (pickedPath == null) {
      return UploadOutcome.cancelled;
    }

    final file = File(pickedPath);
    final fileName = result!.files.single.name;

    _isUploading = true;
    notifyListeners();

    try {
      // 2. Upload the raw file to Supabase Storage.
      final uploaded = await _storage.uploadBook(
        file: file,
        fileName: fileName,
        ageGroup: ageGroup,
        fileType: fileType,
      );

      // 3. Save the metadata row to the database.
      await _database.addBook(
        Book(
          id: '',
          title: title.trim().isEmpty ? fileName : title.trim(),
          downloadUrl: uploaded.downloadUrl,
          storagePath: uploaded.storagePath,
          fileName: fileName,
          ageGroup: ageGroup,
          fileType: fileType,
        ),
      );
      return UploadOutcome.success;
    } catch (_) {
      return UploadOutcome.failure;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
