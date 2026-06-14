import 'package:flutter/material.dart';

const Color _pink = Color(0xFFE91E63);

/// Exercise 6b — an items screen modeled on the slide screenshot:
/// a "Resume" header with a Save action, a list of file items, and two
/// upload buttons pinned to the bottom.
class Ex6bResumeScreen extends StatelessWidget {
  const Ex6bResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      'CV_R Rifa Fauzi Komara.pdf',
      'CV_R Rifa Fauzi Komara.pdf',
      'CV_R Rifa Fauzi Komara.pdf',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Save',
                style: TextStyle(
                    color: _pink, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: items.length,
          itemBuilder: (context, i) => const _FileTile(),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _UploadButton(
                  label: 'Upload from Link',
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _UploadButton(
                  label: 'Upload from Device',
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FileTile extends StatelessWidget {
  const _FileTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Icon(Icons.insert_drive_file_outlined,
              size: 40, color: Colors.blue.shade200),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
            decoration: BoxDecoration(
              color: _pink,
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text('PDF',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      title: const Text('CV_R Rifa Fauzi Komara.pdf',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(
        '/Users/rrifafauzikomara/Library/Developer/…',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _pink,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
