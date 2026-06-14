import 'package:flutter/material.dart';

/// The three supported age brackets for children's books.
///
/// Each value carries:
/// * a human readable [label] shown in the UI (e.g. "Ages 0-4"), and
/// * a stable [value] string that is persisted in Cloud Firestore.
///
/// The persisted [value] is intentionally decoupled from the enum name so the
/// database stays readable and is not affected by future refactors of the
/// Dart code.
enum AgeGroup {
  ages0to4('0-4', 'Ages 0-4'),
  ages4to8('4-8', 'Ages 4-8'),
  ages8to12('8-12', 'Ages 8-12');

  const AgeGroup(this.value, this.label);

  /// The value stored in Firestore (e.g. `"0-4"`).
  final String value;

  /// The user-facing label (e.g. `"Ages 0-4"`).
  final String label;

  /// Rebuilds an [AgeGroup] from its persisted [value].
  ///
  /// Throws a [StateError] if [raw] does not match any known group, which
  /// surfaces data-integrity problems early instead of silently swallowing
  /// them.
  static AgeGroup fromValue(String raw) =>
      AgeGroup.values.firstWhere((g) => g.value == raw);
}

/// The two supported document formats.
///
/// Each value knows how to describe itself for both the UI (icon, color,
/// label) and the file system / file-picker layer ([allowedExtensions]).
enum FileType {
  word(
    'word',
    'Word',
    Icons.description_rounded,
    Color(0xFF2B579A), // Microsoft Word blue.
    ['doc', 'docx'],
  ),
  pdf(
    'pdf',
    'PDF',
    Icons.picture_as_pdf_rounded,
    Color(0xFFD32F2F), // PDF red.
    ['pdf'],
  );

  const FileType(
    this.value,
    this.label,
    this.icon,
    this.color,
    this.allowedExtensions,
  );

  /// The value stored in Firestore (e.g. `"word"`).
  final String value;

  /// The user-facing label (e.g. `"Word"`).
  final String label;

  /// Icon representing this format throughout the app.
  final IconData icon;

  /// Brand color used to tint icons and accents for this format.
  final Color color;

  /// File extensions (without the leading dot) the file-picker is restricted
  /// to when uploading a document of this type.
  final List<String> allowedExtensions;

  /// Rebuilds a [FileType] from its persisted [value].
  static FileType fromValue(String raw) =>
      FileType.values.firstWhere((t) => t.value == raw);
}
