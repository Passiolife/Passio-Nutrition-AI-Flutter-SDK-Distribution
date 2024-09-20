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
enum PassioMealTime {
  /// Represents breakfast time.
  breakfast,

  /// Represents lunch time.
  lunch,

  /// Represents dinner time.
  dinner,

  /// Represents snack time.
  snack,
}

/// Defines different log actions that can be performed.
enum PassioLogAction {
  /// Represents adding an item to the log.
  add,

  /// Represents removing an item from the log.
  remove,

  /// Represents no action.
  none,
}

/// Represents different image resolution options.
enum PassioImageResolution {
  /// 512x512 resolution.
  res_512,

  /// 1080x1080 resolution.
  res_1080,

  /// Full resolution, using the original image size.
  full,
}

/// Represents different types of results that can be returned from food recognition.
enum PassioFoodResultType {
  /// Represents a result where a food item is detected.
  foodItem,

  /// Represents a result where a barcode is detected.
  barcode,

  /// Represents a result containing nutrition facts.
  nutritionFacts,
}
