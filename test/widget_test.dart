import 'package:face_detection/app/screens/camera_screen.dart';
import 'package:face_detection/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyApp widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp([]));

    // Verify that the MyApp widget contains a MaterialApp.
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify that the MaterialApp contains a CameraScreen.
    expect(find.byType(CameraScreen), findsOneWidget);
  });
}
