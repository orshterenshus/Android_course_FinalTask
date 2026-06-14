import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/enums.dart';
import '../models/book.dart';
import '../providers/books_provider.dart';
import '../providers/upload_provider.dart';
import '../widgets/book_list_tile.dart';

/// Inner screen listing all books for a single (age group + file type).
///
/// Responsibilities:
/// * show the books fetched live from Firestore,
/// * let the user GET / OPEN each book, and
/// * upload a new book (restricted to the category's allowed file types).
///
/// It owns a [BooksProvider] and an [UploadProvider], both scoped to this
/// screen's age group and file type.
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    super.key,
    required this.ageGroup,
    required this.fileType,
  });

  final AgeGroup ageGroup;
  final FileType fileType;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BooksProvider(ageGroup: ageGroup, fileType: fileType),
        ),
        ChangeNotifierProvider(
          create: (_) => UploadProvider(ageGroup: ageGroup, fileType: fileType),
        ),
      ],
      child: _CategoryView(ageGroup: ageGroup, fileType: fileType),
    );
  }
}

class _CategoryView extends StatelessWidget {
  const _CategoryView({required this.ageGroup, required this.fileType});

  final AgeGroup ageGroup;
  final FileType fileType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ageGroup.label),
        actions: [
          // File-type icon pinned to the trailing edge of the app bar.
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(fileType.icon, size: 28),
          ),
        ],
      ),
      body: const _BookList(),
      bottomNavigationBar: const _UploadBar(),
    );
  }
}

/// Live list of books, with loading / error / empty states handled.
class _BookList extends StatelessWidget {
  const _BookList();

  @override
  Widget build(BuildContext context) {
    return Consumer<BooksProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return _Message(
            icon: Icons.error_outline_rounded,
            text: 'Could not load books.\nPlease try again later.',
          );
        }
        if (provider.books.isEmpty) {
          return const _Message(
            icon: Icons.menu_book_rounded,
            text: 'No books here yet.\nBe the first to upload one!',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: provider.books.length,
          itemBuilder: (context, index) {
            final book = provider.books[index];
            return BookListTile(
              book: book,
              state: provider.stateFor(book),
              onGet: () => _handleGet(context, provider, book),
              onOpen: () => _handleOpen(context, provider, book),
              onDelete: () => _handleDelete(context, provider, book),
            );
          },
        );
      },
    );
  }

  Future<void> _handleGet(
    BuildContext context,
    BooksProvider provider,
    Book book,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await provider.download(book);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Download failed. Please try again.')),
      );
    }
  }

  Future<void> _handleOpen(
    BuildContext context,
    BooksProvider provider,
    Book book,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await provider.open(book);
    // open_filex returns a non-"done" type when no viewer app is available.
    if (result.type.name != 'done') {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not open file: ${result.message}')),
      );
    }
  }

  Future<void> _handleDelete(
    BuildContext context,
    BooksProvider provider,
    Book book,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    // Confirm before permanently deleting.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete book?'),
        content: Text(
          'Permanently delete "${book.title}"? This removes it for everyone '
          'and cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await provider.deleteBook(book);
      messenger.showSnackBar(
        const SnackBar(content: Text('Book deleted.')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Delete failed. Please try again.')),
      );
    }
  }
}

/// The bottom "Upload Book" bar, which also reflects upload progress.
class _UploadBar extends StatelessWidget {
  const _UploadBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadProvider>(
      builder: (context, upload, _) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 56,
              width: double.infinity,
              child: upload.isUploading
                  ? const _UploadingIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.cloud_upload_rounded),
                      label: const Text('Upload Book'),
                      onPressed: () => _startUpload(context, upload),
                    ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _startUpload(BuildContext context, UploadProvider upload) async {
    // Capture everything that needs `context` up front, before any await, so we
    // never touch `context` across an async gap.
    final messenger = ScaffoldMessenger.of(context);
    final books = context.read<BooksProvider>();

    // Ask for the book title before opening the file picker.
    final title = await _askForTitle(context);
    if (title == null) return; // User cancelled the dialog.

    final outcome = await upload.pickAndUpload(title: title);
    switch (outcome) {
      case UploadOutcome.success:
        messenger.showSnackBar(
          const SnackBar(content: Text('Book uploaded successfully!')),
        );
        // Reload the list so the freshly uploaded book appears.
        await books.refresh();
      case UploadOutcome.failure:
        messenger.showSnackBar(
          const SnackBar(content: Text('Upload failed. Please try again.')),
        );
      case UploadOutcome.cancelled:
        break; // Nothing to report — the user backed out of the picker.
    }
  }

  /// Shows a dialog asking the user to name the book. Returns `null` if the
  /// user cancels.
  Future<String?> _askForTitle(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Name this book'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'e.g. Book 1',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Choose file'),
            ),
          ],
        );
      },
    );
  }
}

/// Progress bar shown in place of the upload button while a file is uploading.
class _UploadingIndicator extends StatelessWidget {
  const _UploadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Uploading…',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: const LinearProgressIndicator(minHeight: 8),
        ),
      ],
    );
  }
}

/// Simple centered icon + message used for empty / error states.
class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
