/// Defines different categories of food items provided by the SDK.
enum PassioIDEntityType {
  /// Represents a group of food items.
  group,

  /// Represents an individual food item.
  item,

  /// Represents a recipe.
  recipe,

  /// Represents a barcode associated with a food item.
  barcode,

  /// Represents a packaged food code.
  packagedFoodCode,

  /// Represents nutrition facts of a food item.
  nutritionFacts
}

/// Represents the different times of day for meals.
enum MealTime {
  /// Represents breakfast time.
  breakfast,

  /// Represents lunch time.
  lunch,

  /// Represents dinner time.
  dinner,

  /// Represents snack time.
  snack,
}
