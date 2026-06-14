import 'package:flutter/material.dart';

import '../models/book.dart';
import '../providers/books_provider.dart';
import 'action_button.dart';

/// A single row in the category book list.
///
/// Shows the book's format icon, its title, the [ActionButton] (GET / spinner /
/// OPEN), and a delete button that removes the book from the library.
class BookListTile extends StatelessWidget {
  const BookListTile({
    super.key,
    required this.book,
    required this.state,
    required this.onGet,
    required this.onOpen,
    required this.onDelete,
  });

  final Book book;
  final BookDownloadState state;
  final VoidCallback onGet;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isBusy = state.status == DownloadStatus.downloading;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        leading: CircleAvatar(
          backgroundColor: book.fileType.color.withValues(alpha: 0.12),
          child: Icon(book.fileType.icon, color: book.fileType.color),
        ),
        title: Text(
          book.title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        subtitle: Text(book.fileName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionButton(state: state, onGet: onGet, onOpen: onOpen),
            // Disabled while a download is in flight to avoid deleting a file
            // that is mid-transfer.
            IconButton(
              tooltip: 'Delete book',
              icon: Icon(Icons.delete_outline_rounded,
                  color: isBusy ? Colors.grey : Colors.red.shade400),
              onPressed: isBusy ? null : onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
