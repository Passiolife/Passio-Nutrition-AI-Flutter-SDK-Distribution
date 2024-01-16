import 'dart:developer';
import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// The main entry point for the integration test.
///
/// Executes the integration test using the [integrationDriver] function.
///
/// Parameters:
/// - [onScreenshot]: A callback function invoked when a screenshot is captured during the test.
///   - [file]: The file path where the screenshot is saved.
///   - [screenshotBytes]: The raw bytes of the captured screenshot.
///   - [args]: Optional arguments passed to the callback (not used in this example).
///
/// Returns a [Future] with no result.
Future<void> main() async {
  try {
    // FlutterDriver driver = await FlutterDriver.connect();
    // driver.waitFor(timeout: Duration(seconds: 60));
    await integrationDriver(
      // driver: driver,
      onScreenshot: (String file, List<int> screenshotBytes,
          [Map<String, Object?>? args]) async {
        // Create or overwrite the file with the screenshot bytes.
        final File image = await File(file).create(recursive: true);
        image.writeAsBytesSync(screenshotBytes);
        // Indicate a successful screenshot capture.
        return true;
      },
    );
  } catch (e) {
    // Handle any errors that occur during the integration test.
    log('Error occurred: $e');
  }
}
