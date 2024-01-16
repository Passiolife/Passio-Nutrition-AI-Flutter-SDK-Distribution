import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test/src/channel.dart';

/// Captures a screenshot during an integration test.
///
/// Takes a screenshot using the provided [tester], [binding], and optional parameters
/// such as [path], [fileName], and [data]. The screenshot is saved with a default file
/// name if [fileName] is not provided.
///
/// Parameters:
/// - [tester]: The [WidgetTester] for interacting with widgets during the test.
/// - [binding]: The [IntegrationTestWidgetsFlutterBinding] for handling integration test-specific functionality.
/// - [path]: The path where the screenshot will be saved (default is 'build/').
/// - [fileName]: The name of the screenshot file (default is the current timestamp).
/// - [data]: A list of integers representing raw image data (optional).
///
/// Returns a [Future] with no result.
Future<List<int>> takeScreenshot(
    {required WidgetTester tester,
    required IntegrationTestWidgetsFlutterBinding binding,
    String path = 'build/',
    String? fileName,
    List<int>? data}) async {
  if (!kIsWeb) {
    await binding.convertFlutterSurfaceToImage();
  }
  // Set a default fileName if not provided.
  fileName ??= '${DateTime.now().millisecondsSinceEpoch}.png';
  // Invoke method to convert Flutter surface to image.
  await integrationTestChannel
      .invokeMethod<void>('convertFlutterSurfaceToImage');
  // Ensure reportData is initialized.
  binding.reportData ??= <String, dynamic>{};
  binding.reportData!['screenshots'] ??= <dynamic>[];
  // Set method call handler to schedule a frame.
  integrationTestChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'scheduleFrame':
        PlatformDispatcher.instance.scheduleFrame();
        break;
    }
    return null;
  });
  // Prepare mapData with the screenshot name.
  Map<String, dynamic> mapData = {'screenshotName': path + fileName};
  mapData['bytes'] = data ??
      await integrationTestChannel.invokeMethod<List<int>>(
        'captureScreenshot',
        <String, dynamic>{'name': fileName},
      );
  // Ensure 'bytes' key is present in mapData.
  assert(mapData.containsKey('bytes'), 'Missing bytes key');
  // Add data to the screenshots list in reportData.
  (binding.reportData!['screenshots'] as List<dynamic>).add(mapData);
  // Revert Flutter image if running on Android.
  if (Platform.isAndroid) {
    await integrationTestChannel.invokeMethod<void>('revertFlutterImage');
  }
  return mapData['bytes']! as List<int>;
}
