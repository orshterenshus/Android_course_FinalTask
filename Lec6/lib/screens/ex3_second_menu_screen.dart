import 'package:flutter/material.dart';

/// Exercise 3 — the "second menu" reached from the right-arrow button.
/// Has a back button (provided automatically by the AppBar) to return.
class Ex3SecondMenuScreen extends StatelessWidget {
  const Ex3SecondMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = <(IconData, String, String)>[
      (Icons.schedule, 'Book later', 'Schedule a service for another day'),
      (Icons.flash_on, 'Express', 'Get someone within the hour'),
      (Icons.star_outline, 'Top rated', 'Only 4.8★ and above professionals'),
      (Icons.local_offer_outlined, 'Offers', 'See this week\'s discounts'),
    ];

    return Scaffold(
      // The leading back button is added automatically because this route
      // was pushed onto the navigator.
      appBar: AppBar(title: const Text('More options')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: options.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final (icon, title, subtitle) = options[i];
            return Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                  child: Icon(icon,
                      color: Theme.of(context).colorScheme.primary),
                ),
                title: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Text(subtitle),
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          },
        ),
      ),
    );
  }
}
