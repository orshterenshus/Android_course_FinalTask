import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/enums.dart';
import '../core/supabase_config.dart';
import '../models/book.dart';

/// Thin wrapper around the Supabase Postgres database that handles all book
/// *metadata* reads and writes.
///
/// Keeping database access isolated here (instead of scattering queries across
/// widgets) makes the data layer easy to test, swap or mock.
class DatabaseService {
  DatabaseService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// Fetches the books for a given [ageGroup] and [fileType], newest first.
  Future<List<Book>> fetchBooks({
    required AgeGroup ageGroup,
    required FileType fileType,
  }) async {
    final rows = await _client
        .from(SupabaseConfig.booksTable)
        .select()
        .eq('age_group', ageGroup.value)
        .eq('file_type', fileType.value)
        .order('created_at', ascending: false);

    return rows.map(Book.fromMap).toList(growable: false);
  }

  /// Inserts a new book row and returns it with its generated id.
  Future<Book> addBook(Book book) async {
    final row = await _client
        .from(SupabaseConfig.booksTable)
        .insert(book.toInsert())
        .select()
        .single();

    return Book.fromMap(row);
  }

  /// Deletes the metadata row for the book with the given [id].
  Future<void> deleteBook(String id) async {
    await _client.from(SupabaseConfig.booksTable).delete().eq('id', id);
  }
}
