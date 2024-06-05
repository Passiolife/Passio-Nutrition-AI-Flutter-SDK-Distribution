import 'enums.dart';
import 'passio_food_data_info.dart';

/// Class representing a meal plan item.
class PassioMealPlanItem {
  final int dayNumber;
  final String dayTitle;
  final PassioFoodDataInfo meal;
  final PassioMealTime mealTime;

  /// Creates a new instance of `PassioMealPlanItem`.
  const PassioMealPlanItem({
    required this.dayNumber,
    required this.dayTitle,
    required this.meal,
    required this.mealTime,
  });

  /// Creates a `PassioMealPlanItem` instance from a JSON map.
  factory PassioMealPlanItem.fromJson(Map<String, dynamic> json) =>
      PassioMealPlanItem(
        dayNumber: json['dayNumber'] as int,
        dayTitle: json['dayTitle'] as String,
        meal: PassioFoodDataInfo.fromJson(
            (json['meal'] as Map<Object?, Object?>).cast<String, dynamic>()),
        mealTime: PassioMealTime.values.byName(json['mealTime']),
      );

  /// Converts the `PassioMealPlanItem` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'dayNumber': dayNumber,
        'dayTitle': dayTitle,
        'meal': meal.toJson(),
        'mealTime': mealTime.name,
      };

  /// Compares two `PassioMealPlanItem` objects for equality.
  @override
  bool operator ==(Object other) {
    if (other is! PassioMealPlanItem) return false;
    if (identical(this, other)) return true;

    return dayNumber == other.dayNumber &&
        dayTitle == other.dayTitle &&
        meal == other.meal &&
        mealTime == other.mealTime;
  }

  /// Calculates the hash code for this `PassioMealPlanItem` object.
  @override
  int get hashCode => Object.hash(
        dayNumber,
        dayTitle,
        meal,
        mealTime,
      );
}
