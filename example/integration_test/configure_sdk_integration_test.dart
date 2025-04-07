import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';

import 'utils/sdk_utils.dart';

void main() {
  runTests();
}

void runTests() {
  group('configureSDK tests', () {
    test('with correct key', () async {
      testWithConfigureSDK(() async {
        const configuration =
            PassioConfiguration(AppSecret.passioKey, debugMode: 1);

        final PassioStatus status =
            await NutritionAI.instance.configureSDK(configuration);

        expect(status.mode, PassioMode.isReadyForDetection);
        expect(status.missingFiles, null);
        expect(status.debugMessage, null);
        expect(status.error, null);
        expect(status.activeModels, isNotNull);
      });
    });

    /// TODO: Uncomment once fix is available
    /*
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
    */

    /// TODO: Uncomment once fix is available
    /*
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
*/
    // Test the configuration with an No Internet Connection.
    // test('with no internet connection', () async {
    //   /// Act
    //   ///
    //   // Set up the PassioConfiguration.
    //   const configuration =
    //       PassioConfiguration(AppSecret.passioKey, debugMode: 1);
    //
    //   /// Arrange
    //   ///
    //   // Call configureSDK and capture the PassioStatus result.
    //   final PassioStatus status =
    //       await NutritionAI.instance.configureSDK(configuration);
    //
    //   /// Assert
    //   ///
    //   // Assertions for the expected behavior.
    //   expect(status.mode, PassioMode.failedToConfigure);
    //   expect(status.missingFiles, null);
    //   expect(status.debugMessage, isNotEmpty);
    //   expect(status.error, PassioSDKError.noInternetConnection);
    //   expect(status.activeModels, isNull);
    // });

    /// TODO: Uncomment once fix is available
    /*
    // Expected output: The SDK should configure correctly.
    test('Configure SDK with an empty key but providing the proxyUrl.',
        () async {
      /// Act
      ///
      // Set up the PassioConfiguration.
      const configuration = PassioConfiguration(
        '',
        debugMode: 1,
        proxyUrl: 'https://myurl.com/',
      );

      /// Arrange
      ///
      // Call configureSDK and capture the PassioStatus result.
      final PassioStatus status =
          await NutritionAI.instance.configureSDK(configuration);

      /// Assert
      ///
      // Assertions for the expected behavior.
      expect(status.mode, PassioMode.isReadyForDetection);
      expect(status.missingFiles, isNull);
      expect(status.debugMessage,
          'The SDK is ready. Since Proxy URL is used, `remoteOnly` configuration is enabled. There\'s no need to download models.');
      expect(status.error, isNull);
      expect(status.activeModels, isNull);
    });
    */

    // Input: Provide invalid proxyUrl string like https://myurl.com/
    // Expected output: None of the API calls should work, because it's not a valid endpoint.
    /*test('Provide invalid proxyUrl string', () async {
      const configuration = PassioConfiguration(
        '',
        debugMode: 1,
        proxyUrl: 'http://sahilsahil.com/',
      );


      final PassioStatus status =
          await NutritionAI.instance.configureSDK(configuration);


      expect(status.mode, PassioMode.isReadyForDetection);

      final response = await NutritionAI.instance.searchForFood('apple');
      expect(response.results, isEmpty);
      expect(response.alternateNames, isEmpty);
    });*/

    /// TODO: Uncomment once fix is available
    /*
    // Input: Provide valid proxyUrl https://api.passiolife.com/v2/.
    // Expected output: None of the API calls should work, because we don't have a valid token fetching.
    test('Provide valid proxyUrl', () async {
      /// Act
      ///
      // Set up the PassioConfiguration.
      const configuration = PassioConfiguration(
        '',
        debugMode: 1,
        proxyUrl: 'https://marinmmarin.com/',
      );

      /// Arrange
      ///
      // Call configureSDK and capture the PassioStatus result.
      final PassioStatus status =
          await NutritionAI.instance.configureSDK(configuration);

      /// Assert
      ///
      // Assertions for the expected behavior.
      expect(status.mode, PassioMode.isReadyForDetection);

      final response = await NutritionAI.instance.searchForFood('apple');
      expect(response.results, isEmpty);
      expect(response.alternateNames, isEmpty);
    });
*/

    /// TODO: Uncomment once fix is available
    /*
    // Input: Provide valid proxyUrl https://api.passiolife.com/v2/, as well as a valid token in the proxyHeader map.
    // Expected output: The API calls should work.
    test(
        'Provide valid proxyUrl, as well as a valid token in the proxyHeader map',
        () async {
      /// Act
      ///
      // Set up the PassioConfiguration.
      const configuration = PassioConfiguration(
        '',
        debugMode: 1,
        proxyUrl: 'https://api.passiolife.com/v2/',
        proxyHeaders: {
          'Authorization':
              'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ind0V0V4NmVjc0dGMzZ1N3dfcVlCbyJ9.eyJpc3MiOiJodHRwczovL3Bhc3Npby51cy5hdXRoMC5jb20vIiwic3ViIjoiZVI0bUxVbmNKTVRqbENiWkxZd3ZERlU1cE9SOHE0bldAY2xpZW50cyIsImF1ZCI6InVuaWZpZWQiLCJpYXQiOjE3MzcwMjA3MjYsImV4cCI6MTczNzEwNzEyNiwic2NvcGUiOiJyZWFkOmh1YiB3cml0ZTpodWIiLCJndHkiOiJjbGllbnQtY3JlZGVudGlhbHMiLCJhenAiOiJlUjRtTFVuY0pNVGpsQ2JaTFl3dkRGVTVwT1I4cTRuVyJ9.TEwImDelP9aEAfbWLmOubmJ9gK-XfvCr3TGToUqI3sgeqd3S0D8DJHJ8Y66n_MN6gev_pWC4ND2aY9lCDN2wSsZCCpVNEFFK90LUVhNuG0P3d9oQaK2d8KG16ovz9LFWKRXmGIWupe7qSpEqEvdg1rfX_QUQrGgkJmoKXxjCwVVPkhroAqwkMxB7N3ybBrkEVTMLZyldBoCxTDTKf16xn89KpkwXvW8nztKDJEKS25I5OdrriWX-yfbcf9lQuPknsOzSWr6ITaPIheXPOUDQSm25FtVrL4szn4yeJK70fcBV4ucnb10wK-nkPw-vZmACW8FrqpjHNUgNJ23Odf8rIw..eyJjdXN0b21lcklkIjoiM2RhZmUxNzUtNDQ0NS0xMWVmLTgwYjQtMGU3MzdkMGY5ODJlIiwibGljZW5zZUtleSI6ImpORjdzS091ZnIxSzB2WUJOZTdIU2hJZ212NGRrSkNZdXZ2cm83cFciLCJsaWNlbnNlUHJvZHVjdCI6InVuaWZpZWQifQ=='
        },
      );

      /// Arrange
      ///
      // Call configureSDK and capture the PassioStatus result.
      final PassioStatus status =
          await NutritionAI.instance.configureSDK(configuration);

      /// Assert
      ///
      // Assertions for the expected behavior.
      expect(status.mode, PassioMode.isReadyForDetection);

      final response = await NutritionAI.instance.searchForFood('apple');
      expect(response.results, isNotEmpty);
      expect(response.alternateNames, isNotEmpty);
    });

   */
  });
}
