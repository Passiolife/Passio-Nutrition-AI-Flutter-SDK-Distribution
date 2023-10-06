import '../models/nutrition_ai_attributes.dart';
import '../nutrition_ai_detection.dart';
import 'nutrition_ai_serving.dart';
import 'nutrition_ai_measurement.dart';

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

  bool isOpenFood() {
    return foodOrigins?.map((e) => e.source).contains('openfood') ?? false;
  }

  String? openFoodLicense() {
    return foodOrigins
        ?.cast<PassioFoodOrigin?>()
        .firstWhere((element) => element!.source == 'openfood',
            orElse: () => null)
        ?.licenseCopy;
  }

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

  T? _scaleByAmount<T extends Unit>(T? unit) {
    if (unit == null) {
      return null;
    }

    return (unit *
        (computedWeight().gramsValue() / _referenceWeight.gramsValue())) as T;
  }

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
