## Camera recognition

* ```lookupPassioAttributesFor``` has been replaced with ```fetchFoodItemForPassioID``` and now returns a *PassioFoodItem* result
* ```fetchPassioIDAttributesForBarcode``` and ```fetchPassioIDAttributesForPackagedFood``` have been replaced with ```fetchFoodItemForProductCode``` which now returns a *PassioFoodItem* result
* Alternative results in the form of *parents*, *siblings* and *children* have been replaced with two types of alternatives:
  a) Every detected candidate will have a list of ```List<DetectedCandidate> alternatives```. These alternatives represent contextually similar foods. Example: If the DetectadeCandidate would be "milk", than the list of alternatives would include items like "soy milk", "almond milk", etc.
  b) Also, the interface ```FoodRecognitionListener``` might return multiple detected candidates, ordered by confidence. These multiple candidates represent the top result that our recognition system is predicting, but also other results that are visually similar to the top result. Example: If the first result in the list of ```detectedCandidates``` is "coffee", there might be more results in the list that are visually simillar to coffee like "coke", "black tea", "chocolate milk", etc.

## Search
* ```searchForFood``` now returns *PassioSearchResponse*. In *PassioSearchResponse* you will get list of PassioSearchResult and a list of search options. The PassioSearchResult represent a specific food item associated with the search term.

```dart
class PassioSearchResponse {
  final List<PassioSearchResult> results;
  final List<String> alternateNames;
}

class PassioSearchResult {
    final String brandName;
    final String foodName;
    final PassioID iconID;
    final String labelId;
    final PassioSearchNutritionPreview nutritionPreview;
    final String resultId;
    final double score;
    final String scoredName;
    final String type;
}

class PassioSearchNutritionPreview {
    final int calories;
    final String servingUnit;
    final double servingQuantity;
    final String servingWeight;
}
```
* To Fetch a food item for a specific search result use ```fetchSearchResult```

## Data models

**PassioIDAttributes** as a top level representation of a food item has been replaced with ```PassioFoodItem```. **PassioFoodItemData** and **PassioFoodRecipe** have also been deprecated.

```dart
class PassioFoodItem {
   final PassioFoodAmount amount;
   final String details;
   final String iconId;
   final String id;
   final List<PassioIngredient> ingredients;
   final String name;
   final PassioID? scannedId;
   
   PassioNutrients nutrients(UnitMass unitMass);
   PassioNutrients nutrientsSelectedSize();
   PassioNutrients nutrientsReference();
   UnitMass weight();
   String? isOpenFood();
}

class PassioIngredient {
   final PassioFoodAmount amount;
   final String iconId;
   final String id;
   final PassioFoodMetadata metadata;
   final String name;
   final PassioNutrients referenceNutrients;

   UnitMass weight();
}

class PassioFoodAmount {
    final double selectedQuantity;
    final String selectedUnit;
    final List<PassioServingSize> servingSizes;
    final List<PassioServingUnit> servingUnits;
    
    UnitMass weight();
}

class PassioNutrients {
    final UnitMass weight;
    
    PassioNutrients.fromWeight(UnitMass weight);
    
    PassioNutrients.fromReferenceNutrients(
            PassioNutrients referenceNutrients,
            {UnitMass? weight});
    
    PassioNutrients.fromIngredientsData(
            List<(PassioNutrients, double)> ingredientsData, UnitMass weight);
    
    PassioNutrients.fromNutrients({
      UnitMass? alcohol,
      UnitMass? calcium,
      UnitEnergy? calories,
      UnitMass? carbs,
      UnitMass? cholesterol,
      UnitMass? fibers,
      UnitMass? fat,
      UnitMass? iodine,
      UnitMass? iron,
      UnitMass? magnesium,
      UnitMass? monounsaturatedFat,
      UnitMass? phosphorus,
      UnitMass? polyunsaturatedFat,
      UnitMass? potassium,
      UnitMass? proteins,
      UnitMass? satFat,
      UnitMass? sodium,
      UnitMass? sugars,
      UnitMass? sugarsAdded,
      UnitMass? sugarAlcohol,
      UnitMass? transFat,
      UnitIU? vitaminA,
      UnitMass? vitaminB6,
      UnitMass? vitaminB12,
      UnitMass? vitaminB12Added,
      UnitMass? vitaminC,
      UnitMass? vitaminD,
      UnitMass? vitaminE,
      UnitMass? vitaminEAdded,
    });
    
    UnitMass get referenceWeight;
    UnitMass? get alcohol;
    UnitMass? get calcium;
    UnitEnergy? get calories;
    UnitMass? get carbs;
    UnitMass? get cholesterol;
    UnitMass? get fibers;
    UnitMass? get fat;
    UnitMass? get iodine;
    UnitMass? get iron;
    UnitMass? get magnesium;
    UnitMass? get monounsaturatedFat;
    UnitMass? get phosphorus;
    UnitMass? get polyunsaturatedFat;
    UnitMass? get potassium;
    UnitMass? get proteins;
    UnitMass? get satFat;
    UnitMass? get sodium;
    UnitMass? get sugars;
    UnitMass? get sugarsAdded;
    UnitMass? get sugarAlcohol;
    UnitMass? get transFat;
    UnitIU? get vitaminA;
    UnitMass? get vitaminB6;
    UnitMass? get vitaminB12;
    UnitMass? get vitaminB12Added;
    UnitMass? get vitaminC;
    UnitMass? get vitaminD;
    UnitMass? get vitaminE;
    UnitMass? get vitaminEAdded;
}
```

* To migrate from the old data structure to the new one this snipped of code will be

```dart
PassioFoodItem _attrsToFoodItem(PassioIDAttributes attrs) {
  List<PassioIngredient> ingredients = [];
  if (attrs.foodItem != null) {
    final ingredient = _foodDataToIngredient(attrs.foodItem!);
    ingredients.add(ingredient);
  } else {
    final recipeIngredients =
    attrs.recipe?.foodItems.map(_foodDataToIngredient);
    ingredients.addAll(recipeIngredients ?? []);
  }

  final amount = (attrs.foodItem != null)
      ? PassioFoodAmount(
    selectedQuantity: attrs.foodItem!.selectedQuantity,
    selectedUnit: attrs.foodItem!.selectedUnit,
    servingSizes: attrs.foodItem!.servingSize,
    servingUnits: attrs.foodItem!.servingUnits,
  )
      : PassioFoodAmount(
    selectedQuantity: attrs.recipe!.selectedQuantity,
    selectedUnit: attrs.recipe!.selectedUnit,
    servingSizes: attrs.recipe!.servingSizes,
    servingUnits: attrs.recipe!.servingUnits,
  );

  return PassioFoodItem(
    id: attrs.passioID,
    name: attrs.name,
    details: "",
    iconId: attrs.passioID,
    amount: amount,
    ingredients: ingredients,
  );
}

PassioIngredient _foodDataToIngredient(PassioFoodItemData data) {
  final amount = PassioFoodAmount(
    selectedQuantity: data.selectedQuantity,
    selectedUnit: data.selectedUnit,
    servingSizes: data.servingSize,
    servingUnits: data.servingUnits,
  );
  data.selectedUnit = 'gram';
  data.selectedQuantity = 100.0;
  final nutrients = PassioNutrients.fromNutrients(
    alcohol: data.totalAlcohol(),
    calcium: data.totalCalcium(),
    calories: data.totalCalories(),
    carbs: data.totalCarbs(),
    cholesterol: data.totalCholesterol(),
    fibers: data.totalFibers(),
    fat: data.totalFat(),
    iodine: data.totalIodine(),
    iron: data.totalIron(),
    magnesium: data.totalMagnesium(),
    monounsaturatedFat: data.totalMonounsaturatedFat(),
    phosphorus: data.totalPhosphorus(),
    polyunsaturatedFat: data.totalPolyunsaturatedFat(),
    potassium: data.totalPotassium(),
    proteins: data.totalProteins(),
    satFat: data.totalSaturatedFat(),
    sodium: data.totalSodium(),
    sugars: data.totalSugars(),
    sugarsAdded: data.totalSugarsAdded(),
    sugarAlcohol: data.totalSugarAlcohol(),
    transFat: data.totalTransFat(),
    vitaminA: data.totalVitaminA(),
    vitaminB6: data.totalVitaminB6(),
    vitaminB12: data.totalVitaminB12(),
    vitaminB12Added: data.totalVitaminB12Added(),
    vitaminC: data.totalVitaminC(),
    vitaminD: data.totalVitaminD(),
    vitaminE: data.totalVitaminE(),
    vitaminEAdded: data.totalVitaminEAdded(),
  );
  final metadata = PassioFoodMetadata(
    barcode: data.barcode,
    foodOrigins: data.foodOrigins,
    ingredientsDescription: data.ingredientsDescription,
    tags: data.tags,
  );
  return PassioIngredient(
    amount: amount,
    iconId: data.passioID,
    id: data.passioID,
    metadata: metadata,
    name: data.name,
    referenceNutrients: nutrients,
  );
}
```

<sup>Copyright 2023 Passio Inc</sup>
