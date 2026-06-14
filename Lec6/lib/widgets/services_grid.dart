import 'package:flutter/material.dart';

/// A single selectable service tile.
class ServiceData {
  const ServiceData(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

const List<ServiceData> kServices = [
  ServiceData('Cleaning', Icons.cleaning_services, Color(0xFF42A5F5)),
  ServiceData('Plumber', Icons.plumbing, Color(0xFFEF5350)),
  ServiceData('Electrician', Icons.electrical_services, Color(0xFFFFB300)),
  ServiceData('Painter', Icons.format_paint, Color(0xFF26A69A)),
  ServiceData('Carpenter', Icons.handyman, Color(0xFF8D6E63)),
  ServiceData('Gardener', Icons.grass, Color(0xFF66BB6A)),
];

/// The "Which service do you need?" grid. Used by Exercise 3 and the
/// Home tab of Exercise 4.
class ServicesGrid extends StatefulWidget {
  const ServicesGrid({super.key, this.padding});

  final EdgeInsetsGeometry? padding;

  @override
  State<ServicesGrid> createState() => _ServicesGridState();
}

class _ServicesGridState extends State<ServicesGrid> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: widget.padding ?? const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 8),
        const Text(
          'Which service\ndo you need?',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: kServices.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, i) {
            final s = kServices[i];
            final selected = i == _selected;
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => setState(() => _selected = i),
              child: Container(
                decoration: BoxDecoration(
                  color: selected
                      ? s.color.withValues(alpha: 0.12)
                      : const Color(0xFFF1F2F4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? s.color : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(s.icon, size: 44, color: s.color),
                    const SizedBox(height: 14),
                    Text(
                      s.label,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
