/// A class representing the nutritional facts of a food item.
class PassioNutritionFacts {
  /// The amount of added sugar.
  final double? addedSugar;

  /// The amount of calcium.
  final double? calcium;

  /// The number of calories.
  final double? calories;

  /// The amount of carbohydrates.
  final double? carbs;

  /// The amount of cholesterol.
  final double? cholesterol;

  /// The amount of dietary fiber.
  final double? dietaryFiber;

  /// The amount of fat.
  final double? fat;

  /// The ingredients list as a string.
  final String? ingredients;

  /// The amount of iron.
  final double? iron;

  /// The amount of potassium.
  final double? potassium;

  /// The amount of protein.
  final double? protein;

  /// The amount of saturated fat.
  final double? saturatedFat;

  /// The serving size as a string.
  final String? servingSize;

  /// The quantity of the serving size.
  final double? servingSizeQuantity;

  /// The unit name of the serving size.
  final String? servingSizeUnitName;

  /// The amount of sodium.
  final double? sodium;

  /// The amount of sugar alcohol.
  final double? sugarAlcohol;

  /// The total amount of sugars.
  final double? sugars;

  /// The amount of trans fat.
  final double? transFat;

  /// The amount of vitamin D.
  final double? vitaminD;

  /// Creates a new instance of `PassioNutritionFacts`.
  const PassioNutritionFacts({
    this.addedSugar,
    this.calcium,
    this.calories,
    this.carbs,
    this.cholesterol,
    this.dietaryFiber,
    this.fat,
    this.ingredients,
    this.iron,
    this.potassium,
    this.protein,
    this.saturatedFat,
    this.servingSize,
    this.servingSizeQuantity,
    this.servingSizeUnitName,
    this.sodium,
    this.sugarAlcohol,
    this.sugars,
    this.transFat,
    this.vitaminD,
  });

  /// Creates a `PassioNutritionFacts` instance from a JSON map.
  factory PassioNutritionFacts.fromJson(Map<String, dynamic> json) =>
      PassioNutritionFacts(
        addedSugar: json['addedSugar'] as double?,
        calcium: json['calcium'] as double?,
        calories: json['calories'] as double?,
        carbs: json['carbs'] as double?,
        cholesterol: json['cholesterol'] as double?,
        dietaryFiber: json['dietaryFiber'] as double?,
        fat: json['fat'] as double?,
        ingredients: json['ingredients'] as String?,
        iron: json['iron'] as double?,
        potassium: json['potassium'] as double?,
        protein: json['protein'] as double?,
        saturatedFat: json['saturatedFat'] as double?,
        servingSize: json['servingSize'] as String?,
        servingSizeQuantity: json['servingSizeQuantity'] as double?,
        servingSizeUnitName: json['servingSizeUnitName'] as String?,
        sodium: json['sodium'] as double?,
        sugarAlcohol: json['sugarAlcohol'] as double?,
        sugars: json['sugars'] as double?,
        transFat: json['transFat'] as double?,
        vitaminD: json['vitaminD'] as double?,
      );

  /// Converts the `PassioNutritionFacts` instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'addedSugar': addedSugar,
        'calcium': calcium,
        'calories': calories,
        'carbs': carbs,
        'cholesterol': cholesterol,
        'dietaryFiber': dietaryFiber,
        'fat': fat,
        'ingredients': ingredients,
        'iron': iron,
        'potassium': potassium,
        'protein': protein,
        'saturatedFat': saturatedFat,
        'servingSize': servingSize,
        'servingSizeQuantity': servingSizeQuantity,
        'servingSizeUnitName': servingSizeUnitName,
        'sodium': sodium,
        'sugarAlcohol': sugarAlcohol,
        'sugars': sugars,
        'transFat': transFat,
        'vitaminD': vitaminD,
      };

  /// Compares two `PassioNutritionFacts` objects for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PassioNutritionFacts) return false;

    return addedSugar == other.addedSugar &&
        calcium == other.calcium &&
        calories == other.calories &&
        carbs == other.carbs &&
        cholesterol == other.cholesterol &&
        dietaryFiber == other.dietaryFiber &&
        fat == other.fat &&
        ingredients == other.ingredients &&
        iron == other.iron &&
        potassium == other.potassium &&
        protein == other.protein &&
        saturatedFat == other.saturatedFat &&
        servingSize == other.servingSize &&
        servingSizeQuantity == other.servingSizeQuantity &&
        servingSizeUnitName == other.servingSizeUnitName &&
        sodium == other.sodium &&
        sugarAlcohol == other.sugarAlcohol &&
        sugars == other.sugars &&
        transFat == other.transFat &&
        vitaminD == other.vitaminD;
  }

  /// Calculates the hash code for this `PassioNutritionFacts` object.
  @override
  int get hashCode {
    return Object.hash(
      addedSugar,
      calcium,
      calories,
      carbs,
      cholesterol,
      dietaryFiber,
      fat,
      ingredients,
      iron,
      potassium,
      protein,
      saturatedFat,
      servingSize,
      servingSizeQuantity,
      servingSizeUnitName,
      sodium,
      sugarAlcohol,
      sugars,
      transFat,
      vitaminD,
    );
  }
}
