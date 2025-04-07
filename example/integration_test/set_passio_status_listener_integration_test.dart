import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/entity/app_secret/app_secret.dart';

List<Uri> _fileUris = [];
PassioStatus? _passioStatus;

/*void main() {
  runTests();
}*/

void runTests() {
  group('setPassioStatusListener tests', () {
    setUp(() {
      _fileUris.clear();
      _passioStatus = null;
    });

    // Expected output: Verify that the _fileUris is not empty, and the _passioStatus is not null.
    test('Set "PassioStatusListener" and call configureSDK', () async {
      const listener = MyPassioStatusListener();
      NutritionAI.instance.setPassioStatusListener(listener);

      // Configure the Passio SDK with a key for testing.
      const configuration = PassioConfiguration(AppSecret.passioKey);
      await NutritionAI.instance.configureSDK(configuration);

      // expect(_fileUris, isNotEmpty);
      expect(_passioStatus, isNotNull);
      expect(_fileUris, isNotEmpty);
    });

    // Expected output: Verify that the _fileUris is empty, and the _passioStatus is null.
    test('Remove "PassioStatusListener" and call configureSDK', () async {
      NutritionAI.instance.setPassioStatusListener(null);

      // Configure the Passio SDK with a key for testing.
      const configuration = PassioConfiguration(AppSecret.passioKey);
      await NutritionAI.instance.configureSDK(configuration);

      // expect(_fileUris, isNotEmpty);
      expect(_passioStatus?.mode, isNull);
      expect(_fileUris, isEmpty);
    });
  });
}

class MyPassioStatusListener implements PassioStatusListener {
  const MyPassioStatusListener();

  @override
  void onCompletedDownloadingAllFiles(List<Uri> fileUris) {
    _fileUris = fileUris;
  }

  @override
  void onCompletedDownloadingFile(Uri fileUri, int filesLeft) {}

  @override
  void onDownloadError(String message) {}

  @override
  void onPassioStatusChanged(PassioStatus status) {
    _passioStatus = status;
  }
}
