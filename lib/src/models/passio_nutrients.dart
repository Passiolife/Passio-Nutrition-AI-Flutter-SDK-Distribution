import 'package:nutrition_ai/src/converter/platform_output_converter.dart';

import 'nutrition_ai_measurement.dart';

/// Represents the nutritional information of a food item, including various nutrients
/// and their quantities.
class PassioNutrients {
  /// The total weight of the food item.
  final UnitMass weight;

  /// The amount of alcohol in the food.
  final UnitMass? _alcohol;

  /// The amount of calcium in the food.
  final UnitMass? _calcium;

  /// The energy (calories) in the food.
  final UnitEnergy? _calories;

  /// The amount of carbohydrates in the food.
  final UnitMass? _carbs;

  /// The amount of cholesterol in the food.
  final UnitMass? _cholesterol;

  /// The amount of fibers in the food.
  final UnitMass? _fibers;

  /// The amount of fat in the food.
  final UnitMass? _fat;

  /// The amount of iodine in the food.
  final UnitMass? _iodine;

  /// The amount of iron in the food.
  final UnitMass? _iron;

  /// The amount of magnesium in the food.
  final UnitMass? _magnesium;

  /// The amount of monounsaturatedFat in the food.
  final UnitMass? _monounsaturatedFat;

  /// The amount of phosphorus in the food.
  final UnitMass? _phosphorus;

  /// The amount of polyunsaturatedFat in the food.
  final UnitMass? _polyunsaturatedFat;

  /// The amount of potassium in the food.
  final UnitMass? _potassium;

  /// The amount of proteins in the food.
  final UnitMass? _proteins;

  /// The amount of satFat in the food.
  final UnitMass? _satFat;

  /// The amount of sodium in the food.
  final UnitMass? _sodium;

  /// The amount of sugars in the food.
  final UnitMass? _sugars;

  /// The amount of sugarsAdded in the food.
  final UnitMass? _sugarsAdded;

  /// The amount of sugarAlcohol in the food.
  final UnitMass? _sugarAlcohol;

  /// The amount of transFat in the food.
  final UnitMass? _transFat;

  /// The amount of vitaminA in the food.
  final UnitIU? _vitaminA;

  /// The amount of vitaminB6 in the food.
  final UnitMass? _vitaminB6;

  /// The amount of vitaminB12 in the food.
  final UnitMass? _vitaminB12;

  /// The amount of vitaminB12Added in the food.
  final UnitMass? _vitaminB12Added;

  /// The amount of vitaminC in the food.
  final UnitMass? _vitaminC;

  /// The amount of vitaminD in the food.
  final UnitMass? _vitaminD;

  /// The amount of vitaminE in the food.
  final UnitMass? _vitaminE;

  /// The amount of vitaminEAdded in the food.
  final UnitMass? _vitaminEAdded;

  /// Reference weight used for scaling nutrient values (100 grams by default).
  final UnitMass _referenceWeight = UnitMass(100.0, UnitMassType.grams);

  UnitMass get referenceWeight => _referenceWeight;

  // Getters for individual nutrients
  UnitMass? get alcohol => _scaleByAmount(_alcohol);

  UnitMass? get calcium => _scaleByAmount(_calcium);

  UnitEnergy? get calories => _scaleByAmount(_calories);

  UnitMass? get carbs => _scaleByAmount(_carbs);

  UnitMass? get cholesterol => _scaleByAmount(_cholesterol);

  UnitMass? get fibers => _scaleByAmount(_fibers);

  UnitMass? get fat => _scaleByAmount(_fat);

  UnitMass? get iodine => _scaleByAmount(_iodine);

  UnitMass? get iron => _scaleByAmount(_iron);

  UnitMass? get magnesium => _scaleByAmount(_magnesium);

  UnitMass? get monounsaturatedFat => _scaleByAmount(_monounsaturatedFat);

  UnitMass? get phosphorus => _scaleByAmount(_phosphorus);

  UnitMass? get polyunsaturatedFat => _scaleByAmount(_polyunsaturatedFat);

  UnitMass? get potassium => _scaleByAmount(_potassium);

  UnitMass? get proteins => _scaleByAmount(_proteins);

  UnitMass? get satFat => _scaleByAmount(_satFat);

  UnitMass? get sodium => _scaleByAmount(_sodium);

  UnitMass? get sugars => _scaleByAmount(_sugars);

  UnitMass? get sugarsAdded => _scaleByAmount(_sugarsAdded);

  UnitMass? get sugarAlcohol => _scaleByAmount(_sugarAlcohol);

  UnitMass? get transFat => _scaleByAmount(_transFat);

  UnitIU? get vitaminA => _scaleByAmount(_vitaminA);

  UnitMass? get vitaminB6 => _scaleByAmount(_vitaminB6);

  UnitMass? get vitaminB12 => _scaleByAmount(_vitaminB12);

  UnitMass? get vitaminB12Added => _scaleByAmount(_vitaminB12Added);

  UnitMass? get vitaminC => _scaleByAmount(_vitaminC);

  UnitMass? get vitaminD => _scaleByAmount(_vitaminD);

  UnitMass? get vitaminE => _scaleByAmount(_vitaminE);

  UnitMass? get vitaminEAdded => _scaleByAmount(_vitaminEAdded);

  /// Creates a new `PassioNutrients` instance.
  PassioNutrients._(
    this.weight,
    this._alcohol,
    this._calcium,
    this._calories,
    this._carbs,
    this._cholesterol,
    this._fibers,
    this._fat,
    this._iodine,
    this._iron,
    this._magnesium,
    this._monounsaturatedFat,
    this._phosphorus,
    this._polyunsaturatedFat,
    this._potassium,
    this._proteins,
    this._satFat,
    this._sodium,
    this._sugars,
    this._sugarsAdded,
    this._sugarAlcohol,
    this._transFat,
    this._vitaminA,
    this._vitaminB6,
    this._vitaminB12,
    this._vitaminB12Added,
    this._vitaminC,
    this._vitaminD,
    this._vitaminE,
    this._vitaminEAdded,
  );

  factory PassioNutrients.fromWeight(UnitMass weight) {
    return PassioNutrients._(
      weight,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    );
  }

  factory PassioNutrients.fromNutrients({
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
  }) {
    return PassioNutrients._(
      UnitMass(100, UnitMassType.grams),
      alcohol,
      calcium,
      calories,
      carbs,
      cholesterol,
      fibers,
      fat,
      iodine,
      iron,
      magnesium,
      monounsaturatedFat,
      phosphorus,
      polyunsaturatedFat,
      potassium,
      proteins,
      satFat,
      sodium,
      sugars,
      sugarsAdded,
      sugarAlcohol,
      transFat,
      vitaminA,
      vitaminB6,
      vitaminB12,
      vitaminB12Added,
      vitaminC,
      vitaminD,
      vitaminE,
      vitaminEAdded,
    );
  }

  /// Constructs a [PassioNutrients] object based on reference nutrients and weight.
  ///
  /// This factory constructor creates a [PassioNutrients] object using the provided [referenceNutrients] and [weight].
  factory PassioNutrients.fromReferenceNutrients(
      PassioNutrients referenceNutrients,
      {UnitMass? weight}) {
    weight ??= UnitMass(100.0, UnitMassType.grams);
    return PassioNutrients._(
      weight,
      referenceNutrients._alcohol,
      referenceNutrients._calcium,
      referenceNutrients._calories,
      referenceNutrients._carbs,
      referenceNutrients._cholesterol,
      referenceNutrients._fibers,
      referenceNutrients._fat,
      referenceNutrients._iodine,
      referenceNutrients._iron,
      referenceNutrients._magnesium,
      referenceNutrients._monounsaturatedFat,
      referenceNutrients._phosphorus,
      referenceNutrients._polyunsaturatedFat,
      referenceNutrients._potassium,
      referenceNutrients._proteins,
      referenceNutrients._satFat,
      referenceNutrients._sodium,
      referenceNutrients._sugars,
      referenceNutrients._sugarsAdded,
      referenceNutrients._sugarAlcohol,
      referenceNutrients._transFat,
      referenceNutrients._vitaminA,
      referenceNutrients._vitaminB6,
      referenceNutrients._vitaminB12,
      referenceNutrients._vitaminB12Added,
      referenceNutrients._vitaminC,
      referenceNutrients._vitaminD,
      referenceNutrients._vitaminE,
      referenceNutrients._vitaminEAdded,
    );
  }

  /// Creates a `PassioNutrients` instance from a JSON map.
  factory PassioNutrients.fromIngredientsData(
      List<(PassioNutrients, double)> ingredientsData, UnitMass weight) {
    return PassioNutrients._(
      weight,
      ingredientsData
              .map((e) => e.$1._alcohol?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._calcium?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._calories?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitEnergy?,
      ingredientsData
              .map((e) => e.$1._carbs?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._cholesterol?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._fibers?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._fat?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._iodine?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._iron?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._magnesium?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData.map((e) => e.$1._monounsaturatedFat?.times(e.$2)).reduce(
          (value, element) => (value != null)
              ? (value as UnitMass) + (element as UnitMass?)
              : element) as UnitMass?,
      ingredientsData
              .map((e) => e.$1._phosphorus?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._polyunsaturatedFat?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._potassium?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._proteins?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._satFat?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._sodium?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._sugars?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._sugarsAdded?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._sugarAlcohol?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._transFat?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._vitaminA?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitIU?,
      ingredientsData
              .map((e) => e.$1._vitaminB6?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._vitaminB12?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._vitaminB12Added?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._vitaminC?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._vitaminD?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._vitaminE?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
      ingredientsData
              .map((e) => e.$1._vitaminEAdded?.times(e.$2))
              .reduce((value, element) => value?.plus(element) ?? element)
          as UnitMass?,
    );
  }

  /// Converts the `PassioNutrients` instance to a JSON map.
  factory PassioNutrients.fromJson(Map<String, dynamic> json) =>
      PassioNutrients._(
        UnitMass.fromJson(
            (json["weight"] as Map<Object?, Object?>).cast<String, dynamic>()),
        json.ifValueNotNull("alcohol", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("calcium", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("calories", (it) => UnitEnergy.fromJson(it)),
        json.ifValueNotNull("carbs", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("cholesterol", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("fibers", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("fat", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("iodine", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("iron", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("magnesium", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull(
            "monounsaturatedFat", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("phosphorus", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull(
            "polyunsaturatedFat", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("potassium", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("proteins", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("satFat", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("sodium", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("sugars", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("sugarsAdded", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("sugarAlcohol", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("transFat", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("vitaminA", (it) => UnitIU.fromJson(it)),
        json.ifValueNotNull("vitaminB6", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("vitaminB12", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("vitaminB12Added", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("vitaminC", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("vitaminD", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("vitaminE", (it) => UnitMass.fromJson(it)),
        json.ifValueNotNull("vitaminEAdded", (it) => UnitMass.fromJson(it)),
      );

  /// Converts the `PassioNutrients` object to a JSON map.
  Map<String, dynamic> toJson() => {
        'weight': weight.toJson(),
        'alcohol': _alcohol?.toJson(),
        'calcium': _calcium?.toJson(),
        'calories': _calories?.toJson(),
        'carbs': _carbs?.toJson(),
        'cholesterol': _cholesterol?.toJson(),
        'fibers': _fibers?.toJson(),
        'fat': _fat?.toJson(),
        'iodine': _iodine?.toJson(),
        'iron': _iron?.toJson(),
        'magnesium': _magnesium?.toJson(),
        'monounsaturatedFat': _monounsaturatedFat?.toJson(),
        'phosphorus': _phosphorus?.toJson(),
        'polyunsaturatedFat': _polyunsaturatedFat?.toJson(),
        'potassium': _potassium?.toJson(),
        'proteins': _proteins?.toJson(),
        'saturatedFat': _satFat?.toJson(),
        'sodium': _sodium?.toJson(),
        'sugars': _sugars?.toJson(),
        'sugarsAdded': _sugarsAdded?.toJson(),
        'sugarAlcohol': _sugarAlcohol?.toJson(),
        'transFat': _transFat?.toJson(),
        'vitaminA': _vitaminA?.toJson(),
        'vitaminB6': _vitaminB6?.toJson(),
        'vitaminB12': _vitaminB12?.toJson(),
        'vitaminB12Added': _vitaminB12Added?.toJson(),
        'vitaminC': _vitaminC?.toJson(),
        'vitaminD': _vitaminD?.toJson(),
        'vitaminE': _vitaminE?.toJson(),
        'vitaminEAdded': _vitaminEAdded?.toJson(),
      };

  /// Compares two `PassioNutrients` objects for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PassioNutrients) return false;
    // Compare all non-null properties except for reference weight
    return weight == other.weight &&
        _alcohol == other._alcohol &&
        _calcium == other._calcium &&
        _calories == other._calories &&
        _carbs == other._carbs &&
        _cholesterol == other._cholesterol &&
        _fibers == other._fibers &&
        _fat == other._fat &&
        _iodine == other._iodine &&
        _iron == other._iron &&
        _magnesium == other._magnesium &&
        _monounsaturatedFat == other._monounsaturatedFat &&
        _phosphorus == other._phosphorus &&
        _polyunsaturatedFat == other._polyunsaturatedFat &&
        _potassium == other._potassium &&
        _proteins == other._proteins &&
        _satFat == other._satFat &&
        _sodium == other._sodium &&
        _sugars == other._sugars &&
        _sugarsAdded == other._sugarsAdded &&
        _sugarAlcohol == other._sugarAlcohol &&
        _transFat == other._transFat &&
        _vitaminA == other._vitaminA &&
        _vitaminB6 == other._vitaminB6 &&
        _vitaminB12 == other._vitaminB12 &&
        _vitaminB12Added == other._vitaminB12Added &&
        _vitaminC == other._vitaminC &&
        _vitaminD == other._vitaminD &&
        _vitaminE == other._vitaminE &&
        _vitaminEAdded == other._vitaminEAdded;
  }

  /// Calculates the hash code for this `PassioNutrients` object.
  @override
  int get hashCode {
    // Combine the hash codes of all non-null properties except for reference weight
    var hash = weight.hashCode;
    hash ^= _alcohol?.hashCode ?? 0;
    hash ^= _calcium?.hashCode ?? 0;
    hash ^= _calories?.hashCode ?? 0;
    hash ^= _carbs?.hashCode ?? 0;
    hash ^= _cholesterol?.hashCode ?? 0;
    hash ^= _fibers?.hashCode ?? 0;
    hash ^= _fat?.hashCode ?? 0;
    hash ^= _iodine?.hashCode ?? 0;
    hash ^= _iron?.hashCode ?? 0;
    hash ^= _magnesium?.hashCode ?? 0;
    hash ^= _monounsaturatedFat?.hashCode ?? 0;
    hash ^= _phosphorus?.hashCode ?? 0;
    hash ^= _polyunsaturatedFat?.hashCode ?? 0;
    hash ^= _potassium?.hashCode ?? 0;
    hash ^= _proteins?.hashCode ?? 0;
    hash ^= _satFat?.hashCode ?? 0;
    hash ^= _sodium?.hashCode ?? 0;
    hash ^= _sugars?.hashCode ?? 0;
    hash ^= _sugarsAdded?.hashCode ?? 0;
    hash ^= _sugarAlcohol?.hashCode ?? 0;
    hash ^= _transFat?.hashCode ?? 0;
    hash ^= _vitaminA?.hashCode ?? 0;
    hash ^= _vitaminB6?.hashCode ?? 0;
    hash ^= _vitaminB12?.hashCode ?? 0;
    hash ^= _vitaminB12Added?.hashCode ?? 0;
    hash ^= _vitaminC?.hashCode ?? 0;
    hash ^= _vitaminD?.hashCode ?? 0;
    hash ^= _vitaminE?.hashCode ?? 0;
    hash ^= _vitaminEAdded?.hashCode ?? 0;
    return hash;
  }

  /// This method is used to calculate the actual amount of a nutrient per 100 grams
  /// based on the provided value and the weight of the food item.
  ///
  /// Returns the scaled unit value, or null if the input unit is null.
  T? _scaleByAmount<T extends Unit>(T? unit) {
    if (unit == null) {
      /// Return null if the input unit is null.
      return null;
    }

    /// Calculate the scaling factor by dividing the current weight by the reference weight.
    final double scalingFactor =
        weight.gramsValue() / _referenceWeight.gramsValue();

    /// Apply the scaling factor to the unit and return the scaled value.
    return unit * scalingFactor as T?;
  }
}
