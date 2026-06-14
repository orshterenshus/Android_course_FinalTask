// Basic widget test for the Kids' Books home screen.
//
// It renders [HomeScreen] in isolation (no Firebase needed, since the home
// screen does not touch Firestore until a category is opened) and verifies the
// title and the six category cards are shown.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kids_books/core/theme.dart';
import 'package:kids_books/screens/home_screen.dart';
import 'package:kids_books/widgets/category_card.dart';

void main() {
  testWidgets('Home screen shows title and six category cards',
      (WidgetTester tester) async {
    // Use a tall surface so the whole 2×3 grid is laid out (the grid builds
    // its children lazily, so the default 800×600 surface would only render
    // the first visible row).
    await tester.binding.setSurfaceSize(const Size(1080, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
    );

    // The prompt title is visible.
    expect(find.text("Choose your child's age:"), findsOneWidget);

    // Three age groups × two formats = six cards.
    expect(find.byType(CategoryCard), findsNWidgets(6));
  });
}
