import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../core/theme.dart';
import '../widgets/category_card.dart';
import 'category_screen.dart';

/// The landing screen: "Choose your child's age".
///
/// Presents the six categories as a 2-column grid — the left column for Word
/// documents, the right column for PDFs — with a clear icon header above each
/// column.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openCategory(
    BuildContext context,
    AgeGroup ageGroup,
    FileType fileType,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryScreen(ageGroup: ageGroup, fileType: fileType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build the cards age-by-age, Word first then PDF, so that in the
    // 2-column grid the left column is always Word and the right is PDF.
    final cards = <Widget>[];
    var colorIndex = 0;
    for (final age in AgeGroup.values) {
      for (final type in FileType.values) {
        cards.add(
          CategoryCard(
            ageGroup: age,
            fileType: type,
            color: AppTheme.cardColors[colorIndex % AppTheme.cardColors.length],
            onTap: () => _openCategory(context, age, type),
          ),
        );
        colorIndex++;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Choose your child's age:")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _ColumnHeaders(),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: cards,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The two icon headers ("Word" / "PDF") that sit above the grid columns.
class _ColumnHeaders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final type in FileType.values)
          Expanded(
            child: Column(
              children: [
                Icon(type.icon, color: type.color, size: 30),
                const SizedBox(height: 4),
                Text(
                  '${type.label} files',
                  style: TextStyle(
                    color: type.color,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
