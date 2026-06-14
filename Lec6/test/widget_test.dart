import 'package:flutter_test/flutter_test.dart';

import 'package:android_course_6/main.dart';

void main() {
  testWidgets('Home menu lists the class exercises', (tester) async {
    await tester.pumpWidget(const AndroidCourse6App());

    expect(find.text('Lecture 6 – Class Exercises'), findsWidgets);
    expect(find.text('Phone Login'), findsOneWidget);
    expect(find.text('Download Apps'), findsOneWidget);
  });
}
