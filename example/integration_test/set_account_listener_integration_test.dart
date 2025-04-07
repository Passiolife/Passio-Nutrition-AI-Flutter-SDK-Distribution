import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';

PassioTokenBudget? _tokenBudget;

void main() {
  // This function is called once before all tests are run.
  setUpAll(() async {
    // Configure the Passio SDK with a key for testing.
    const configuration = PassioConfiguration(AppSecret.passioKey);
    final status = await NutritionAI.instance.configureSDK(configuration);
    expect(status.mode, PassioMode.isReadyForDetection);
  });

  runTests();
}

void runTests() {
  group('setAccountListener tests', () {
    // Expected output: Verify that _tokenBudget is updated with a non-null, valid token budget object with a non-empty API name.
    test('Set "PassioAccountListener" and call searchForFood', () async {
      // Arrange
      const listener = MyPassioAccountListener();

      // Act
      NutritionAI.instance.setAccountListener(listener);
      await NutritionAI.instance.searchForFood('Apple');

      // Assert
      expect(_tokenBudget, isNotNull);
      expect(_tokenBudget?.apiName, isNotEmpty);
    });

    // Expected output: Verify that the _tokenBudget should be null.
    test('Remove "PassioAccountListener" and call searchForFood', () async {
      // Arrange
      _tokenBudget = null;
      NutritionAI.instance.setAccountListener(null);

      // Act
      await NutritionAI.instance.searchForFood('Apple');

      // Assert
      expect(_tokenBudget, isNull);
    });
  });
}

class MyPassioAccountListener implements PassioAccountListener {
  const MyPassioAccountListener();

  @override
  void onTokenBudgetUpdate(PassioTokenBudget tokenBudget) {
    _tokenBudget = tokenBudget;
  }
}
