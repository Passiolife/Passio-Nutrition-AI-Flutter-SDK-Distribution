import 'dart:async';
import 'dart:developer';
import 'package:flutter_driver/flutter_driver.dart';

Future<void> main() async {
  // Connect to the Flutter driver
  final FlutterDriver driver = await FlutterDriver.connect();

  // Wait for app to initialize
  await Future.delayed(const Duration(seconds: 2));

  // Attempt to handle the permission dialog
  try {
    // Try for standard Android 10+ resource ID
    final standardAllowButtonFinder = find.byValueKey(
        'com.android.permissioncontroller:id/permission_allow_button');

    // Try to tap the Allow button, waiting for it to appear with a timeout
    await driver.waitFor(standardAllowButtonFinder,
        timeout: const Duration(seconds: 5));
    await driver.tap(standardAllowButtonFinder);
  } catch (e) {
    // Try alternative resource IDs for different Android versions
    try {
      // Android 9 and below might use a different resource ID
      final alternativeAllowButtonFinder = find.byValueKey(
          'com.android.packageinstaller:id/permission_allow_button');
      await driver.waitFor(alternativeAllowButtonFinder,
          timeout: const Duration(seconds: 5));
      await driver.tap(alternativeAllowButtonFinder);
    } catch (e) {
      // Try locating by text as a last resort
      try {
        final textAllowButtonFinder = find.text('Allow');
        await driver.waitFor(textAllowButtonFinder,
            timeout: const Duration(seconds: 5));
        await driver.tap(textAllowButtonFinder);
      } catch (e) {
        log(e.toString());
      }
    }
  }

  // Close the driver when done
  await driver.close();
}
