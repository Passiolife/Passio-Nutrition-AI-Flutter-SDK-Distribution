import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';

import 'take_screenshot.dart';

void main() {
  // Initialize the IntegrationTestWidgetsFlutterBinding for integration testing.
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Determine the current platform (android or ios) for file path purposes.
  late String currentPlatform = Platform.isAndroid ? 'Android' : 'iOS';

  // Set up tasks to be executed once before all tests in the suite.
  setUpAll(() async {
    // Configure the Passio SDK with a key for testing.
    final configuration = PassioConfiguration(AppSecret.passioKey);
    final status = await NutritionAI.instance.configureSDK(configuration);
    expect(status.mode, PassioMode.isReadyForDetection);
  });

  /// Helper function to execute a test case.
  Future<void> executeTest(
    String passioID,
    Future<PassioIDAttributes?> Function(String) fetchData,
    String testName,
    WidgetTester tester,
  ) async {
    // Arrange
    const filePath = 'build/test_output/';
    final fileName = '$passioID-$testName-$currentPlatform.json';

    // Act
    PassioIDAttributes? attributes = await fetchData(passioID);

    // Sorting various lists in attributes for consistent comparison
    attributes?.parents?.sortedWith([
      (it) => it.passioID,
      (it) => it.unitName ?? '',
      (it) => it.quantity ?? 0,
    ]);
    attributes?.siblings?.sortedWith([
      (it) => it.passioID,
      (it) => it.unitName ?? '',
      (it) => it.quantity ?? 0,
    ]);
    attributes?.children?.sortedWith([
      (it) => it.passioID,
      (it) => it.unitName ?? '',
      (it) => it.quantity ?? 0,
    ]);
    attributes?.foodItem?.tags?.sortedWith([(it) => it]);
    attributes?.foodItem?.servingUnits.sortedWith([(it) => it.unitName]);
    attributes?.foodItem?.servingSize.sortedWith([(it) => it.unitName]);
    attributes?.foodItem?.foodOrigins?.sortedWith([(it) => it.id]);
    attributes?.foodItem?.parents?.sortedWith([
      (it) => it.passioID,
      (it) => it.unitName ?? '',
      (it) => it.quantity ?? 0,
    ]);
    attributes?.foodItem?.siblings?.sortedWith([
      (it) => it.passioID,
      (it) => it.unitName ?? '',
      (it) => it.quantity ?? 0,
    ]);
    attributes?.foodItem?.children?.sortedWith([
      (it) => it.passioID,
      (it) => it.unitName ?? '',
      (it) => it.quantity ?? 0,
    ]);
    attributes?.recipe?.servingUnits.sortedWith([(it) => it.unitName]);
    attributes?.recipe?.servingSizes.sortedWith([(it) => it.unitName]);
    attributes?.recipe?.foodItems.forEach((foodItem) {
      foodItem.tags?.sortedWith([(it) => it]);
      foodItem.parents?.sortedWith([
        (it) => it.passioID,
        (it) => it.unitName ?? '',
        (it) => it.quantity ?? 0,
      ]);
      foodItem.siblings?.sortedWith([
        (it) => it.passioID,
        (it) => it.unitName ?? '',
        (it) => it.quantity ?? 0,
      ]);
      foodItem.children?.sortedWith([
        (it) => it.passioID,
        (it) => it.unitName ?? '',
        (it) => it.quantity ?? 0,
      ]);
      foodItem.servingUnits.sortedWith([(it) => it.unitName]);
      foodItem.servingSize.sortedWith([(it) => it.unitName]);
      foodItem.foodOrigins?.sortedWith([(it) => it.id]);
    });

    // Encoding attributes and taking a screenshot
    final encodedAttributes = utf8.encode(jsonEncode(attributes));
    final storedBytes = await takeScreenshot(
      tester: tester,
      binding: binding,
      path: filePath,
      fileName: fileName,
      data: encodedAttributes,
    );

    // Assert
    expect(storedBytes, equals(encodedAttributes));
  }

  // Test group for 'lookupPassioAttributesFor' tests.
  group('lookupPassioAttributesFor tests', () {
    // Test case for passioID 'VEG0018'.
    testWidgets('VEG0018', (tester) async {
      await executeTest(
          'VEG0018',
          NutritionAI.instance.lookupPassioAttributesFor,
          'lookupPassioAttributesFor',
          tester);
    });

    // Test case for passioID 'REC001120'.
    testWidgets('REC001120', (tester) async {
      await executeTest(
          'REC001120',
          NutritionAI.instance.lookupPassioAttributesFor,
          'lookupPassioAttributesFor',
          tester);
    });

    // Test case for passioID 'AAAAAAA'.
    testWidgets('AAAAAAA', (tester) async {
      await executeTest(
          'AAAAAAA',
          NutritionAI.instance.lookupPassioAttributesFor,
          'lookupPassioAttributesFor',
          tester);
    });
  });

  // Test group for 'fetchAttributesForBarcode' tests.
  group('fetchAttributesForBarcode tests', () {
    // Test case for barcode '681131018098'.
    testWidgets('681131018098', (tester) async {
      await executeTest(
          '681131018098',
          NutritionAI.instance.fetchAttributesForBarcode,
          'fetchAttributesForBarcode',
          tester);
    });

    // Test case for barcode 'AAAAAAA'.
    testWidgets('AAAAAAA', (tester) async {
      await executeTest(
          'AAAAAAA',
          NutritionAI.instance.fetchAttributesForBarcode,
          'fetchAttributesForBarcode',
          tester);
    });
  });
}

extension ListSortingExtension<T> on List<T>? {
  void sortedWith(List<Comparable Function(T)> comparators) {
    this?.sort((a, b) {
      for (final comparator in comparators) {
        final comparison = comparator(a).compareTo(comparator(b));
        if (comparison != 0) {
          return comparison;
        }
      }
      return 0;
    });
  }
}
