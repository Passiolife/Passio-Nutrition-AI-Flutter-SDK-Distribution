import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Group of tests for the 'configureSDK' method.
  group('configureSDK tests', () {
    // Test the configuration with a correct key.
    test('with correct key', () async {
      /// Act
      ///
      // Set up the PassioConfiguration.
      const configuration =
          PassioConfiguration(AppSecret.passioKey, debugMode: 1);

      /// Arrange
      ///
      // Call configureSDK and capture the PassioStatus result.
      final PassioStatus status =
          await NutritionAI.instance.configureSDK(configuration);

      /// Assert
      ///
      // Assertions for the expected behavior.
      expect(status.mode, PassioMode.isReadyForDetection);
      expect(status.missingFiles, null);
      expect(status.debugMessage, null);
      expect(status.error, null);
      expect(status.activeModels, isNotNull);
    });

    // Test the configuration with a wrong key.
    test('with wrong key', () async {
      /// Act
      ///
      // Set up the PassioConfiguration.
      const configuration = PassioConfiguration("1234567890", debugMode: 1);

      /// Arrange
      ///
      // Call configureSDK and capture the PassioStatus result.
      final PassioStatus status =
          await NutritionAI.instance.configureSDK(configuration);

      /// Assert
      ///
      // Assertions for the expected behavior.
      expect(status.mode, PassioMode.failedToConfigure);
      expect(status.missingFiles, null);
      expect(status.debugMessage,
          'Your key is not valid. Please contact support@passiolife.com to renew your key');
      expect(status.error, PassioSDKError.keyNotValid);
      expect(status.activeModels, isNull);
    });

    // Test the configuration with an expired key.
    test('with expired key', () async {
      /// Act
      ///
      // Set up the PassioConfiguration.
      const configuration = PassioConfiguration(
          "8hoiPdOZCTBz3ln7hYLZCEVhfNivQWM7fdSpOFz049xN",
          debugMode: 1);

      /// Arrange
      ///
      // Call configureSDK and capture the PassioStatus result.
      final PassioStatus status =
          await NutritionAI.instance.configureSDK(configuration);

      /// Assert
      ///
      // Assertions for the expected behavior.
      expect(status.mode, PassioMode.failedToConfigure);
      expect(status.missingFiles, null);
      expect(status.debugMessage, 'Your Key has expired on: 2021-06-21');
      expect(status.error, PassioSDKError.licensedKeyHasExpired);
      expect(status.activeModels, isNull);
    });

    // Test the configuration with an No Internet Connection.
    test('with no internet connection', () async {
      /// Act
      ///
      // Set up the PassioConfiguration.
      const configuration =
          PassioConfiguration(AppSecret.passioKey, debugMode: 1);

      /// Arrange
      ///
      // Call configureSDK and capture the PassioStatus result.
      final PassioStatus status =
          await NutritionAI.instance.configureSDK(configuration);

      /// Assert
      ///
      // Assertions for the expected behavior.
      expect(status.mode, PassioMode.failedToConfigure);
      expect(status.missingFiles, null);
      expect(status.debugMessage, isNotEmpty);
      expect(status.error, PassioSDKError.noInternetConnection);
      expect(status.activeModels, isNull);
    });
  });
}
