import 'enums.dart';
import 'passio_advisor_food_info.dart';

/// Represents a speech recognition model.
///
/// This class contains details about the recognized speech action,
/// associated food information, date of recognition, and meal time.
class PassioSpeechRecognitionModel {
  /// The action associated with the speech recognition.
  final PassioLogAction? action;

  /// Detailed information about the recognized food item.
  final PassioAdvisorFoodInfo advisorInfo;

  /// The date associated with the recognized speech.
  final String date;

  /// The meal time associated with the recognized speech.
  final PassioMealTime? mealTime;

  /// Creates a new instance of `PassioSpeechRecognitionModel`.
  const PassioSpeechRecognitionModel({
    this.action,
    required this.advisorInfo,
    required this.date,
    this.mealTime,
  });

  /// Creates a `PassioSpeechRecognitionModel` instance from a JSON map.
  factory PassioSpeechRecognitionModel.fromJson(Map<String, dynamic> json) =>
      PassioSpeechRecognitionModel(
        action: json['action'] != null
            ? PassioLogAction.values.byName(json['action'])
            : null,
        advisorInfo: PassioAdvisorFoodInfo.fromJson(
            (json['advisorInfo'] as Map<Object?, Object?>)
                .cast<String, dynamic>()),
        date: json['date'] as String,
        mealTime: json['mealTime'] != null
            ? PassioMealTime.values.byName(json['mealTime'])
            : null,
      );

  /// Converts the `PassioSpeechRecognitionModel` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'action': action?.name,
        'advisorInfo': advisorInfo.toJson(),
        'date': date,
        'mealTime': mealTime?.name,
      };

  /// Compares two `PassioSpeechRecognitionModel` objects for equality.
  @override
  bool operator ==(Object other) {
    if (other is! PassioSpeechRecognitionModel) return false;
    if (identical(this, other)) return true;

    return action == other.action &&
        advisorInfo == other.advisorInfo &&
        date == other.date &&
        mealTime == other.mealTime;
  }

  /// Calculates the hash code for this `PassioSpeechRecognitionModel` object.
  @override
  int get hashCode => Object.hash(
        action,
        advisorInfo,
        date,
        mealTime,
      );
}
