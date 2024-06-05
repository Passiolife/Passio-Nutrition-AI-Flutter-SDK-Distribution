/// Class representing a meal plan.
class PassioMealPlan {
  /// Target amount of carbohydrates.
  final int carbTarget;

  /// Target amount of fat in grams.
  final int fatTarget;

  /// Label for the meal plan.
  final String mealPlanLabel;

  /// Title of the meal plan.
  final String mealPlanTitle;

  /// Target amount of protein.
  final int proteinTarget;

  /// Creates a new instance of `PassioMealPlan`.
  const PassioMealPlan({
    required this.carbTarget,
    required this.fatTarget,
    required this.mealPlanLabel,
    required this.mealPlanTitle,
    required this.proteinTarget,
  });

  /// Creates a `PassioMealPlan` instance from a JSON map.
  factory PassioMealPlan.fromJson(Map<String, dynamic> json) => PassioMealPlan(
        carbTarget: json['carbTarget'] as int,
        fatTarget: json['fatTarget'] as int,
        mealPlanLabel: json['mealPlanLabel'] as String,
        mealPlanTitle: json['mealPlanTitle'] as String,
        proteinTarget: json['proteinTarget'] as int,
      );

  /// Converts the `PassioMealPlan` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'carbTarget': carbTarget,
        'fatTarget': fatTarget,
        'mealPlanLabel': mealPlanLabel,
        'mealPlanTitle': mealPlanTitle,
        'proteinTarget': proteinTarget,
      };

  /// Compares two `PassioMealPlan` objects for equality.
  @override
  bool operator ==(Object other) {
    if (other is! PassioMealPlan) return false;
    if (identical(this, other)) return true;

    return carbTarget == other.carbTarget &&
        fatTarget == other.fatTarget &&
        mealPlanLabel == other.mealPlanLabel &&
        mealPlanTitle == other.mealPlanTitle &&
        proteinTarget == other.proteinTarget;
  }

  /// Calculates the hash code for this `PassioMealPlan` object.
  @override
  int get hashCode => Object.hash(
        carbTarget,
        fatTarget,
        mealPlanLabel,
        mealPlanTitle,
        proteinTarget,
      );
}
