import 'package:flutter/material.dart';

import '../providers/books_provider.dart';

/// The trailing action button shown on each book row.
///
/// Its appearance is driven entirely by the book's [BookDownloadState]:
/// * [DownloadStatus.notDownloaded] → a "GET" button,
/// * [DownloadStatus.downloading]   → a circular progress indicator,
/// * [DownloadStatus.downloaded]    → an "OPEN" button.
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.state,
    required this.onGet,
    required this.onOpen,
  });

  final BookDownloadState state;
  final VoidCallback onGet;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case DownloadStatus.downloading:
        return SizedBox(
          width: 44,
          height: 44,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            // Show determinate progress when available, otherwise spin.
            value: state.progress > 0 ? state.progress : null,
          ),
        );

      case DownloadStatus.downloaded:
        return FilledButton.icon(
          onPressed: onOpen,
          icon: const Icon(Icons.open_in_new_rounded, size: 18),
          label: const Text('OPEN'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.green.shade600,
          ),
        );

      case DownloadStatus.notDownloaded:
        return OutlinedButton.icon(
          onPressed: onGet,
          icon: const Icon(Icons.download_rounded, size: 18),
          label: const Text('GET'),
        );
    }
  }
}
