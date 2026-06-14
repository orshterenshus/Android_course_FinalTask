import '../core/enums.dart';

/// Immutable representation of a single children's book stored in the app.
///
/// A [Book] is purely *metadata*: the actual document lives in Supabase Storage
/// and is referenced by [downloadUrl] / [storagePath]. The metadata itself is
/// persisted as one row in the Supabase `books` table.
class Book {
  const Book({
    required this.id,
    required this.title,
    required this.downloadUrl,
    required this.storagePath,
    required this.fileName,
    required this.ageGroup,
    required this.fileType,
    this.createdAt,
  });

  /// Database row id (empty for a book that has not been saved yet).
  final String id;

  /// Display title, e.g. "Book 1".
  final String title;

  /// Public URL used to download the file from Supabase Storage.
  final String downloadUrl;

  /// Path of the object inside the Storage bucket (used for downloads/deletes).
  final String storagePath;

  /// Original file name including its extension, e.g. "my_story.pdf".
  final String fileName;

  /// Age bracket this book belongs to.
  final AgeGroup ageGroup;

  /// Document format of this book.
  final FileType fileType;

  /// Timestamp of when the book was uploaded (used for ordering).
  final DateTime? createdAt;

  /// Creates a [Book] from a Supabase/Postgres row (JSON map).
  ///
  /// Columns are snake_case, following Postgres convention.
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id']?.toString() ?? '',
      title: map['title'] as String? ?? 'Untitled',
      downloadUrl: map['download_url'] as String? ?? '',
      storagePath: map['storage_path'] as String? ?? '',
      fileName: map['file_name'] as String? ?? '',
      ageGroup: AgeGroup.fromValue(map['age_group'] as String? ?? '0-4'),
      fileType: FileType.fromValue(map['file_type'] as String? ?? 'pdf'),
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? ''),
    );
  }

  /// Serializes this book into a map ready to be inserted into the table.
  ///
  /// `id` and `created_at` are intentionally omitted — the database fills them
  /// in via its default values (`gen_random_uuid()` and `now()`).
  Map<String, dynamic> toInsert() => <String, dynamic>{
        'title': title,
        'download_url': downloadUrl,
        'storage_path': storagePath,
        'file_name': fileName,
        'age_group': ageGroup.value,
        'file_type': fileType.value,
      };
}
