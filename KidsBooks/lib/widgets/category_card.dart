import 'package:flutter/material.dart';

import '../core/enums.dart';

/// A colorful, kid-friendly card representing one (age group + file type)
/// category on the home screen.
///
/// Tapping the card navigates into the matching [CategoryScreen].
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.ageGroup,
    required this.fileType,
    required this.color,
    required this.onTap,
  });

  final AgeGroup ageGroup;
  final FileType fileType;

  /// Background color for this card (assigned from the playful palette).
  final Color color;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // White circular badge holding the file-type icon.
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(fileType.icon, size: 34, color: fileType.color),
              ),
              const SizedBox(height: 14),
              Text(
                ageGroup.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                fileType.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
