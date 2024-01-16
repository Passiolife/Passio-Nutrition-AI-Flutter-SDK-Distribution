import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  // Constants for platform identifiers
  const androidPlatform = 'Android';
  const iOSPlatform = 'iOS';

  // Path to the output directory for test results
  String filePath = 'build/test_output/';

  /// Function to execute a test for PassioID attributes.
  ///
  /// Parameters:
  /// - [passioID]: The PassioID for the test.
  /// - [testName]: The name of the test.
  /// - [differencesList]: A list to store any identified differences.
  void executeTest(
      String passioID, String testName, List<String> differencesList) {
    // File paths for iOS and Android results
    final iOSFile = File('$filePath$passioID-$testName-$iOSPlatform.json');
    final androidFile =
        File('$filePath$passioID-$testName-$androidPlatform.json');

    // Assert that the result files exist
    final iOSFileExists = iOSFile.existsSync();
    final androidFileExists = androidFile.existsSync();
    expect(iOSFileExists && androidFileExists, isTrue,
        reason:
            '${!iOSFileExists ? iOSFile : ''} ${!androidFileExists ? 'and ${androidFile.path}' : ''} file(s) not found.');

    // Read content from result files
    final androidContent = androidFile.readAsStringSync();
    final iOSContent = iOSFile.readAsStringSync();

    // Convert JSON content to maps
    Map<String, dynamic>? androidJson =
        androidContent != 'null' ? json.decode(androidContent) : null;
    Map<String, dynamic>? iOSJson =
        iOSContent != 'null' ? json.decode(iOSContent) : null;

    // Compare JSON structures
    compareJson(androidJson, iOSJson, differencesList);
  }

  /// Function to delete result files for a given PassioID.
  ///
  /// Parameters:
  /// - [passioID]: The PassioID for which result files should be deleted.
  void deleteResultFile(String passioID, String testName) {
    File('$filePath$passioID-$testName-$iOSPlatform.json').delete();
    File('$filePath$passioID-$testName-$androidPlatform.json').delete();
  }

  // Test group for 'lookupPassioAttributesFor' tests
  group('lookupPassioAttributesFor tests', () {
    String testName = 'lookupPassioAttributesFor';

    test('VEG0018 test', () {
      // Arrange
      final differenceList = <String>[];
      // Act
      executeTest('VEG0018', testName, differenceList);
      // Assert
      expect(differenceList, isEmpty);
    });

    test('REC001120 test', () {
      // Arrange
      final differenceList = <String>[];
      // Act
      executeTest('REC001120', testName, differenceList);
      // Assert
      expect(differenceList, isEmpty);
    });

    test('AAAAAAA test', () {
      // Arrange
      final differenceList = <String>[];
      // Act
      executeTest('AAAAAAA', testName, differenceList);
      // Assert
      expect(differenceList, isEmpty);
    });

    // Cleanup after all tests in the group have run
    tearDownAll(() {
      deleteResultFile('VEG0018', testName);
      deleteResultFile('REC001120', testName);
      deleteResultFile('AAAAAAA', testName);
    });
  });

  // Test group for 'fetchAttributesForBarcode' tests
  group('fetchAttributesForBarcode tests', () {
    String testName = 'fetchAttributesForBarcode';

    test('681131018098 test', () async {
      // Arrange
      final differenceList = <String>[];
      // Act
      executeTest('681131018098', testName, differenceList);
      // Assert
      expect(differenceList, isEmpty);
    });

    test('AAAAAAA test', () async {
      // Arrange
      final differenceList = <String>[];
      // Act
      executeTest('AAAAAAA', testName, differenceList);
      // Assert
      expect(differenceList, isEmpty);
    });

    // Cleanup after all tests in the group have run
    tearDownAll(() {
      deleteResultFile('681131018098', testName);
      deleteResultFile('AAAAAAA', testName);
    });
  });
}

/// Compares two JSON maps and identifies the differences.
///
/// Recursively compares nested maps and lists, adding any differences to the [differences] list.
///
/// Parameters:
/// - [androidMap]: The Android JSON map.
/// - [iOSMap]: The iOS JSON map.
/// - [differences]: The list to store the identified differences.
/// - [path]: The current path in the JSON structure (used for tracking nested structures).
void compareJson(Map<String, dynamic>? androidMap, Map<String, dynamic>? iOSMap,
    List<String> differences,
    [String path = '']) {
  if ((androidMap == null || iOSMap == null) && androidMap != iOSMap) {
    differences.add('$path=> Android: $androidMap, iOS: $iOSMap');
  }
  // Iterate over keys in the Android map
  androidMap?.forEach((key, androidValue) {
    // Retrieve the corresponding value from the iOS map
    final iOSValue = iOSMap?[key];

    // If both values are maps, recursively compare them
    if (androidValue is Map && iOSValue is Map) {
      compareJson(
        androidValue.cast<String, dynamic>(),
        iOSValue.cast<String, dynamic>(),
        differences,
        '$path$key.',
      );
    }
    // If both values are lists, recursively compare them
    else if (androidValue is List && iOSValue is List) {
      compareLists(androidValue, iOSValue, differences, '$path$key');
    }
    // If values are not maps or lists, compare them directly
    else {
      // If values are not equal, add the difference to the list
      if (androidValue != iOSValue) {
        differences.add('$path$key=> Android: $androidValue, iOS: $iOSValue');
      }
    }
  });
}

/// Compares two lists and identifies the differences.
///
/// Recursively compares nested lists, adding any differences to the [differences] list.
///
/// Parameters:
/// - [androidList]: The Android list.
/// - [iOSList]: The iOS list.
/// - [differences]: The list to store the identified differences.
/// - [path]: The current path in the list (used for tracking nested structures).
void compareLists(List<dynamic>? androidList, List<dynamic>? iOSList,
    List<String> differences, String path) {
  // If the lengths of the lists are different, add the difference to the list
  if ((androidList?.length ?? 0) != (iOSList?.length ?? 0)) {
    differences.add('$path=> Android $androidList, iOS $iOSList');
    return;
  }

  // Iterate over elements in the Android list
  for (var i = 0; i < (androidList?.length ?? 0); i++) {
    // Retrieve the corresponding elements from the iOS list
    final androidElement = androidList?.elementAtOrNull(i);
    final iOSElement = iOSList?.elementAtOrNull(i);

    // If both elements are maps, recursively compare them
    if (androidElement is Map && iOSElement is Map) {
      compareJson(androidElement.cast<String, dynamic>(),
          iOSElement.cast<String, dynamic>(), differences, '$path[$i].');
    }
    // If both elements are lists, recursively compare them
    else if (androidElement is List && iOSElement is List) {
      compareLists(androidElement, iOSElement, differences, '$path[$i]');
    }
    // If elements are not maps or lists, compare them directly
    else {
      // If elements are not equal, add the difference to the list
      if (androidElement != iOSElement) {
        differences.add('$path[$i]=> Android $androidElement, iOS $iOSElement');
      }
    }
  }
}
