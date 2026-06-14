import 'dart:async';

import 'package:flutter/material.dart';

const Color _blue = Color(0xFF2196F3);

enum _DownloadState { idle, downloading, done }

/// Exercise 2 — a dummy "Apps" list where each row downloads on demand:
/// GET → circular progress → OPEN. No real download happens.
class Ex2DownloadScreen extends StatefulWidget {
  const Ex2DownloadScreen({super.key});

  @override
  State<Ex2DownloadScreen> createState() => _Ex2DownloadScreenState();
}

class _Ex2DownloadScreenState extends State<Ex2DownloadScreen> {
  final List<_DownloadState> _states =
      List.filled(6, _DownloadState.idle, growable: false);

  Future<void> _onTap(int index) async {
    final state = _states[index];
    if (state == _DownloadState.downloading) return;

    if (state == _DownloadState.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening App ${index + 1}…')),
      );
      return;
    }

    setState(() => _states[index] = _DownloadState.downloading);
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() => _states[index] = _DownloadState.done);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _blue,
        foregroundColor: Colors.white,
        title: const Text('Apps'),
      ),
      body: ListView.separated(
        itemCount: 6,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) {
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: _AppIcon(index: i),
            title: Text('App ${i + 1}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            subtitle: Text('Lorem ipsum …',
                style: TextStyle(color: Colors.grey.shade500)),
            trailing: _ActionButton(
              state: _states[i],
              onPressed: () => _onTap(i),
            ),
          );
        },
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFF3949AB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.ac_unit, color: Colors.white, size: 26),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.state, required this.onPressed});

  final _DownloadState state;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _DownloadState.downloading:
        return const SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 3, color: _blue),
        );
      case _DownloadState.idle:
      case _DownloadState.done:
        final isDone = state == _DownloadState.done;
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFE9EAEC),
            foregroundColor: _blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          ),
          child: Text(
            isDone ? 'OPEN' : 'GET',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        );
    }
  }
}
