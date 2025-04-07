import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final String fileName = 'passio_speech_recognition.json';

  late String jsonString;
  late Map<String, dynamic> jsonData;
  late PassioSpeechRecognitionModel passioSpeechRecognitionModel;

  setUpAll(() {
    jsonString = fixture(fileName);
    jsonData = jsonDecode(jsonString);
    passioSpeechRecognitionModel =
        PassioSpeechRecognitionModel.fromJson(jsonData);
  });

  group('PassioSpeechRecognition tests', () {
    test('toJson() test', () {
      expect(passioSpeechRecognitionModel.toJson(), equals(jsonData));
    });

    test('fromJson() test', () {
      final data = PassioSpeechRecognitionModel.fromJson(jsonData);
      expect(data, passioSpeechRecognitionModel);
    });

    test('Equality operator test', () async {
      final data = PassioSpeechRecognitionModel.fromJson(jsonData);
      expect(passioSpeechRecognitionModel, equals(data));
    });

    test('hashCode test', () async {
      final data = PassioSpeechRecognitionModel.fromJson(jsonData);
      expect(passioSpeechRecognitionModel.hashCode, equals(data.hashCode));
    });
  });
}
