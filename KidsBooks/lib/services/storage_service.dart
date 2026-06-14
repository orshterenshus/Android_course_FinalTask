import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/enums.dart';
import '../core/supabase_config.dart';

/// Result of a successful upload: everything the caller needs to build a
/// [Book] metadata record.
class UploadResult {
  const UploadResult({required this.downloadUrl, required this.storagePath});

  /// Public URL used later to download the file.
  final String downloadUrl;

  /// Path of the object inside the Storage bucket.
  final String storagePath;
}

/// Handles uploading the actual document files to Supabase Storage.
class StorageService {
  StorageService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// Uploads [file] and returns its public download URL and storage path.
  ///
  /// Files are organized in the bucket by age group and file type, e.g.
  /// `0-4/word/1700000000000_my_story.docx`. A millisecond timestamp is
  /// prefixed to the file name to guarantee uniqueness even if two users
  /// upload files with the same name.
  Future<UploadResult> uploadBook({
    required File file,
    required String fileName,
    required AgeGroup ageGroup,
    required FileType fileType,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = '${ageGroup.value}/${fileType.value}/${timestamp}_$fileName';

    final bucket = _client.storage.from(SupabaseConfig.booksBucket);
    await bucket.upload(path, file);

    final url = bucket.getPublicUrl(path);
    return UploadResult(downloadUrl: url, storagePath: path);
  }

  /// Removes the file at [storagePath] from the bucket.
  Future<void> deleteFile(String storagePath) async {
    await _client.storage.from(SupabaseConfig.booksBucket).remove([storagePath]);
  }
}
