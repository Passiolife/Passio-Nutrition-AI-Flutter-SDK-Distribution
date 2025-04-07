import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  group('PassioIcon Tests', () {
    testWidgets('displays CircularProgressIndicator when no image is provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: PassioIcon(),
        ),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(CircleAvatar), findsNothing);
    });

    testWidgets('displays CircleAvatar with image when image is provided',
        (WidgetTester tester) async {
      final String jsonString = fixture('platform_image.json');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final PlatformImage image = PlatformImage.fromJson(jsonData);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: PassioIcon(image: image),
        ),
      ));

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      final CircleAvatar avatar =
          tester.firstWidget(find.byType(CircleAvatar)) as CircleAvatar;
      expect(avatar.radius, 30);
      expect(avatar.backgroundImage, isNotNull);
    });
  });
}
