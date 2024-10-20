import '../../converter/platform_output_converter.dart';
import '../enums.dart';
import '../nutrition_ai_measurement.dart';
import 'passio_alternative.dart';
import '../passio_food_origin.dart';
import '../../nutrition_ai_detection.dart';
import '../passio_serving_size.dart';
import '../passio_serving_unit.dart';

/// Data class that contains the nutritional information for a single food item.
class PassioFoodItemData {
  /// ID to query the nutritional database
  final PassioID passioID;

  /// Name of the single food item.
  final String name;

  /// Currently selected weight quantity.
  double selectedQuantity;

  /// Currently selected weight unit.
  String selectedUnit;

  /// Type of the food item.
  final PassioIDEntityType entityType;

  /// List of predefined serving units from the nutritional database.
  final List<PassioServingUnit> servingUnits;

  /// List of predefined serving size from the nutritional database.
  final List<PassioServingSize> servingSize;

  /// List of ingredients of the food item.
  final String? ingredientsDescription;

  /// Corresponding barcode code of the food item.
  final Barcode? barcode;

  /// List of sources from which data on the food item is populated from.
  final List<PassioFoodOrigin>? foodOrigins;

  /// List of [PassioAlternative] that are one level above in the food hierarchy.
  final List<PassioAlternative>? parents;

  /// List of [PassioAlternative]s that are on the same level the food hierarchy.
  final List<PassioAlternative>? siblings;

  /// List of [PassioAlternative]s that are one level below in the food hierarchy.
  final List<PassioAlternative>? children;

  /// List of tags associated with the food item.
  final List<String>? tags;

  final UnitMass _referenceWeight = UnitMass(100.0, UnitMassType.grams);

  // Nutrients per 100 grams
  final UnitEnergy? _calories;
  final UnitMass? _carbs;
  final UnitMass? _fat;
  final UnitMass? _proteins;
  final UnitMass? _saturatedFat;
  final UnitMass? _transFat;
  final UnitMass? _monounsaturatedFat;
  final UnitMass? _polyunsaturatedFat;
  final UnitMass? _cholesterol;
  final UnitMass? _sodium;
  final UnitMass? _fibers;
  final UnitMass? _sugars;
  final UnitMass? _sugarsAdded;
  final UnitMass? _vitaminD;
  final UnitMass? _calcium;
  final UnitMass? _iron;
  final UnitMass? _potassium;
  final UnitIU? _vitaminA;
  final UnitMass? _vitaminC;
  final UnitMass? _alcohol;
  final UnitMass? _sugarAlcohol;
  final UnitMass? _vitaminB12Added;
  final UnitMass? _vitaminB12;
  final UnitMass? _vitaminB6;
  final UnitMass? _vitaminE;
  final UnitMass? _vitaminEAdded;
  final UnitMass? _magnesium;
  final UnitMass? _phosphorus;
  final UnitMass? _iodine;

  /// Creates a new instance of `PassioFoodItemData`.
  PassioFoodItemData(
    this.passioID,
    this.name,
    this.tags,
    this.selectedQuantity,
    this.selectedUnit,
    this.entityType,
    this.servingUnits,
    this.servingSize,
    this.ingredientsDescription,
    this.barcode,
    this.foodOrigins,
    this.parents,
    this.siblings,
    this.children,
    this._calories,
    this._carbs,
    this._fat,
    this._proteins,
    this._saturatedFat,
    this._transFat,
    this._monounsaturatedFat,
    this._polyunsaturatedFat,
    this._cholesterol,
    this._sodium,
    this._fibers,
    this._sugars,
    this._sugarsAdded,
    this._vitaminD,
    this._calcium,
    this._iron,
    this._potassium,
    this._vitaminA,
    this._vitaminC,
    this._alcohol,
    this._sugarAlcohol,
    this._vitaminB12Added,
    this._vitaminB12,
    this._vitaminB6,
    this._vitaminE,
    this._vitaminEAdded,
    this._magnesium,
    this._phosphorus,
    this._iodine,
  );

  /// Creates a `PassioFoodItemData` instance from a JSON map.
  factory PassioFoodItemData.fromJson(Map<String, dynamic> json) =>
      PassioFoodItemData(
        json["passioID"],
        json["name"],
        mapDynamicListToListOfString(json["tags"]),
        json["selectedQuantity"],
        json["selectedUnit"],
        PassioIDEntityType.values.byName(json["entityType"]),
        mapListOfObjects(json["servingUnits"], PassioServingUnit.fromJson),
        mapListOfObjects(json["servingSizes"], PassioServingSize.fromJson),
        json["ingredientsDescription"],
        json["barcode"],
        mapListOfObjectsOptional(
            json["foodOrigins"], PassioFoodOrigin.fromJson),
        mapListOfObjectsOptional(json["parents"], PassioAlternative.fromJson),
        mapListOfObjectsOptional(json["siblings"], PassioAlternative.fromJson),
        mapListOfObjectsOptional(json["children"], PassioAlternative.fromJson),
        json.ifValueNotNull("calories", UnitEnergy.fromJson),
        json.ifValueNotNull("carbs", UnitMass.fromJson),
        json.ifValueNotNull("fat", UnitMass.fromJson),
        json.ifValueNotNull("proteins", UnitMass.fromJson),
        json.ifValueNotNull("saturatedFat", UnitMass.fromJson),
        json.ifValueNotNull("transFat", UnitMass.fromJson),
        json.ifValueNotNull("monounsaturatedFat", UnitMass.fromJson),
        json.ifValueNotNull("polyunsaturatedFat", UnitMass.fromJson),
        json.ifValueNotNull("cholesterol", UnitMass.fromJson),
        json.ifValueNotNull("sodium", UnitMass.fromJson),
        json.ifValueNotNull("fibers", UnitMass.fromJson),
        json.ifValueNotNull("sugars", UnitMass.fromJson),
        json.ifValueNotNull("sugarsAdded", UnitMass.fromJson),
        json.ifValueNotNull("vitaminD", UnitMass.fromJson),
        json.ifValueNotNull("calcium", UnitMass.fromJson),
        json.ifValueNotNull("iron", UnitMass.fromJson),
        json.ifValueNotNull("potassium", UnitMass.fromJson),
        json.ifValueNotNull("vitaminA", UnitIU.fromJson),
        json.ifValueNotNull("vitaminC", UnitMass.fromJson),
        json.ifValueNotNull("alcohol", UnitMass.fromJson),
        json.ifValueNotNull("sugarAlcohol", UnitMass.fromJson),
        json.ifValueNotNull("vitaminB12Added", UnitMass.fromJson),
        json.ifValueNotNull("vitaminB12", UnitMass.fromJson),
        json.ifValueNotNull("vitaminB6", UnitMass.fromJson),
        json.ifValueNotNull("vitaminE", UnitMass.fromJson),
        json.ifValueNotNull("vitaminEAdded", UnitMass.fromJson),
        json.ifValueNotNull("magnesium", UnitMass.fromJson),
        json.ifValueNotNull("phosphorus", UnitMass.fromJson),
        json.ifValueNotNull("iodine", UnitMass.fromJson),
      );

  /// Converts the `PassioFoodItemData` instance to a JSON map.
  Map<String, dynamic> toJson() => _mapOfPassioFoodItemData();

  Map<String, dynamic> _mapOfPassioFoodItemData() {
    return {
      'passioID': passioID,
      'name': name,
      'tags': tags,
      'selectedQuantity': selectedQuantity,
      'selectedUnit': selectedUnit,
      'entityType': entityType.name,
      'servingUnits': servingUnits.map((e) => e.toJson()).toList(),
      'servingSizes': servingSize.map((e) => e.toJson()).toList(),
      'ingredientsDescription': ingredientsDescription,
      'barcode': barcode,
      'foodOrigins': foodOrigins?.map((e) => e.toJson()).toList(),
      'parents': parents?.map((e) => e.toJson()).toList(),
      'siblings': siblings?.map((e) => e.toJson()).toList(),
      'children': children?.map((e) => e.toJson()).toList(),
      'calories': _calories?.toJson(),
      'carbs': _carbs?.toJson(),
      'fat': _fat?.toJson(),
      'proteins': _proteins?.toJson(),
      'saturatedFat': _saturatedFat?.toJson(),
      'transFat': _transFat?.toJson(),
      'monounsaturatedFat': _monounsaturatedFat?.toJson(),
      'polyunsaturatedFat': _polyunsaturatedFat?.toJson(),
      'cholesterol': _cholesterol?.toJson(),
      'sodium': _sodium?.toJson(),
      'fibers': _fibers?.toJson(),
      'sugars': _sugars?.toJson(),
      'sugarsAdded': _sugarsAdded?.toJson(),
      'vitaminD': _vitaminD?.toJson(),
      'calcium': _calcium?.toJson(),
      'iron': _iron?.toJson(),
      'potassium': _potassium?.toJson(),
      'vitaminA': _vitaminA?.toJson(),
      'vitaminC': _vitaminC?.toJson(),
      'alcohol': _alcohol?.toJson(),
      'sugarAlcohol': _sugarAlcohol?.toJson(),
      'vitaminB12Added': _vitaminB12Added?.toJson(),
      'vitaminB12': _vitaminB12?.toJson(),
      'vitaminB6': _vitaminB6?.toJson(),
      'vitaminE': _vitaminE?.toJson(),
      'vitaminEAdded': _vitaminEAdded?.toJson(),
      'magnesium': _magnesium?.toJson(),
      'phosphorus': _phosphorus?.toJson(),
      'iodine': _iodine?.toJson(),
    };
  }

  /// Checks if the food item is sourced from OpenFood.
  bool isOpenFood() {
    return foodOrigins?.map((e) => e.source).contains('openfood') ?? false;
  }

  /// Retrieves the OpenFood license associated with the food item.
  String? openFoodLicense() {
    return foodOrigins
        ?.cast<PassioFoodOrigin?>()
        .firstWhere((element) => element!.source == 'openfood',
            orElse: () => null)
        ?.licenseCopy;
  }

  /// Computes the total weight of the food item.
  UnitMass computedWeight() {
    PassioServingUnit? servingUnit = servingUnits
        .cast<PassioServingUnit?>()
        .firstWhere((element) => element!.unitName == selectedUnit,
            orElse: () => null);
    if (servingUnit == null) {
      return UnitMass(0.0, UnitMassType.grams);
    }

    return (servingUnit.weight * selectedQuantity) as UnitMass;
  }

  /// Sets the serving size of the food item.
  ///
  /// Returns `true` if the serving size was successfully set, otherwise `false`.
  bool setServingSize(String unit, double quantity) {
    PassioServingUnit? servingUnit = servingUnits
        .cast<PassioServingUnit?>()
        .firstWhere((element) => element!.unitName == unit, orElse: () => null);
    if (servingUnit == null) {
      return false;
    }

    selectedUnit = unit;
    selectedQuantity = quantity;
    return true;
  }

  /// Sets the serving unit of the food item while keeping the weight constant.
  ///
  /// Returns `true` if the serving unit was successfully set, otherwise `false`.
  bool setServingUnitKeepWeight(String unit) {
    PassioServingUnit? servingUnit = servingUnits
        .cast<PassioServingUnit?>()
        .firstWhere((element) => element!.unitName == unit, orElse: () => null);
    if (servingUnit == null) {
      return false;
    }

    selectedQuantity =
        computedWeight().gramsValue() / servingUnit.weight.gramsValue();
    selectedUnit = unit;
    return true;
  }

  /// Scales a nutritional unit by the computed weight of the food item.
  ///
  /// Returns `null` if the unit is `null`, otherwise the scaled unit.
  T? _scaleByAmount<T extends Unit>(T? unit) {
    if (unit == null) {
      return null;
    }

    return (unit *
        (computedWeight().gramsValue() / _referenceWeight.gramsValue())) as T;
  }

  // Nutritional information methods
  UnitEnergy? totalCalories() => _scaleByAmount(_calories);
  UnitMass? totalCarbs() => _scaleByAmount(_carbs);
  UnitMass? totalFat() => _scaleByAmount(_fat);
  UnitMass? totalProteins() => _scaleByAmount(_proteins);
  UnitMass? totalSaturatedFat() => _scaleByAmount(_saturatedFat);
  UnitMass? totalTransFat() => _scaleByAmount(_transFat);
  UnitMass? totalMonounsaturatedFat() => _scaleByAmount(_monounsaturatedFat);
  UnitMass? totalPolyunsaturatedFat() => _scaleByAmount(_polyunsaturatedFat);
  UnitMass? totalCholesterol() => _scaleByAmount(_cholesterol);
  UnitMass? totalSodium() => _scaleByAmount(_sodium);
  UnitMass? totalFibers() => _scaleByAmount(_fibers);
  UnitMass? totalSugars() => _scaleByAmount(_sugars);
  UnitMass? totalSugarsAdded() => _scaleByAmount(_sugarsAdded);
  UnitMass? totalVitaminD() => _scaleByAmount(_vitaminD);
  UnitMass? totalCalcium() => _scaleByAmount(_calcium);
  UnitMass? totalIron() => _scaleByAmount(_iron);
  UnitMass? totalPotassium() => _scaleByAmount(_potassium);
  UnitIU? totalVitaminA() => _scaleByAmount(_vitaminA);
  UnitMass? totalVitaminC() => _scaleByAmount(_vitaminC);
  UnitMass? totalAlcohol() => _scaleByAmount(_alcohol);
  UnitMass? totalSugarAlcohol() => _scaleByAmount(_sugarAlcohol);
  UnitMass? totalVitaminB12Added() => _scaleByAmount(_vitaminB12Added);
  UnitMass? totalVitaminB12() => _scaleByAmount(_vitaminB12);
  UnitMass? totalVitaminB6() => _scaleByAmount(_vitaminB6);
  UnitMass? totalVitaminE() => _scaleByAmount(_vitaminE);
  UnitMass? totalVitaminEAdded() => _scaleByAmount(_vitaminEAdded);
  UnitMass? totalMagnesium() => _scaleByAmount(_magnesium);
  UnitMass? totalPhosphorus() => _scaleByAmount(_phosphorus);
  UnitMass? totalIodine() => _scaleByAmount(_iodine);
}
