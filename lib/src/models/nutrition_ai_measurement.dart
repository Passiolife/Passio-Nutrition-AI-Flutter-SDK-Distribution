/// Base class used to create units for mass, energy, etc.
abstract class Unit {
  double value = 1.0;
  double converter = 1.0;
  String symbol = "";

  Unit(this.value, this.converter, this.symbol);

  Unit operator *(double mult) => times(mult);

  Unit operator +(UnitMass? add) => plus(add);

  double operator /(UnitMass divide) => division(divide);

  Unit times(double mult);

  Unit plus(Unit? add);

  double division(Unit divide);
}

/// Class that represents a measurement of mass.
class UnitMass extends Unit {
  /// The type of unit used for the mass measurement.
  final UnitMassType unit;

  /// Creates a new `UnitMass` object.
  UnitMass(double value, this.unit) : super(value, unit.converter, unit.symbol);

  /// Converts the mass value to grams.
  double gramsValue() => value * unit.converter * 1000;

  /// Multiplies the mass value by a scalar.
  @override
  Unit times(double mult) {
    return UnitMass(value * mult, unit);
  }

  /// Creates a `UnitMass` object from a JSON map.
  factory UnitMass.fromJson(Map<String, dynamic> json) =>
      UnitMass(json["value"], UnitMassType.values.byName(json["unit"]));

  /// Converts the `UnitMass` object to a JSON map.
  Map<String, dynamic> toJson() => {
        'value': value,
        'unit': unit.name,
      };

  /// Compares two `UnitMass` objects for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UnitMass) return false;
    return value == other.value && unit == other.unit;
  }

  /// Calculates the hash code for this `UnitMass` object.
  @override
  int get hashCode => Object.hash(value, unit);

  /// Adds another unit to the current unit.
  @override
  Unit plus(Unit? add) {
    if (add == null || (add is! UnitMass)) return this;
    return (unit == add.unit)
        ? UnitMass(value + add.value, unit)
        : UnitMass(
            gramsValue() + add.gramsValue(),
            UnitMassType.grams,
          );
  }

  /// Divides the current unit by another unit.
  @override
  double division(Unit divide) {
    return gramsValue() / (divide as UnitMass).gramsValue();
  }
}

/// Class that represents a measurement of energy.
class UnitEnergy extends Unit {
  /// The type of unit used for the energy measurement.
  final UnitEnergyType unit;

  /// Converts the energy value to kilocalories (kcal).
  double kcalValue() => value * unit.converter;

  /// Creates a new `UnitEnergy` object with a specific value and unit type.
  UnitEnergy(double value, this.unit)
      : super(value, unit.converter, unit.symbol);

  /// Creates a `UnitEnergy` object from a JSON map.
  factory UnitEnergy.fromJson(Map<String, dynamic> json) =>
      UnitEnergy(json["value"], UnitEnergyType.values.byName(json["unit"]));

  /// Converts the `UnitEnergy` object to a JSON map.
  Map<String, dynamic> toJson() => {'value': value, 'unit': unit.name};

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UnitEnergy) return false;
    return value == other.value && unit == other.unit;
  }

  @override
  int get hashCode => Object.hash(value, unit);

  /// Multiplies the energy value by a scalar.
  @override
  Unit times(double mult) {
    return UnitEnergy(value * mult, unit);
  }

  /// Currently not implemented. Throws an exception if called.
  @override
  double division(Unit divide) {
    throw ("UnitEnergy division(Unit divide) has not been implemented.");
  }

  /// Adds another unit to the current unit.
  @override
  Unit plus(Unit? add) {
    if (add == null || add is! UnitEnergy) return this;
    return (unit == add.unit)
        ? UnitEnergy(value + add.value, unit)
        : UnitEnergy(
            kcalValue() + add.kcalValue(), UnitEnergyType.kilocalories);
  }
}

/// Class that represents a measurement of IU.
class UnitIU extends Unit {
  /// Creates a new `UnitIU` object with a specific value.
  UnitIU(double value) : super(value, 1.0, "iu");

  factory UnitIU.fromJson(Map<String, dynamic> json) => UnitIU(json["value"]);

  Map<String, dynamic> toJson() => {'value': value};

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UnitIU) return false;
    return value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  /// Multiplies the energy value by a scalar.
  @override
  Unit times(double mult) {
    return UnitIU(value * mult);
  }

  /// Currently not implemented. Throws an exception if called.
  @override
  double division(Unit divide) {
    throw ("UnitIU division(Unit divide) has not been implemented.");
  }

  /// Adds another unit to the current unit.
  @override
  Unit plus(Unit? add) {
    if (add == null) return this;
    return UnitIU(value + add.value);
  }
}

enum UnitMassType {
  kilograms(converter: 1.0, symbol: 'kg'),
  grams(converter: 0.001, symbol: 'g'),
  milligrams(converter: 0.000001, symbol: 'mg'),
  micrograms(converter: 0.000000001, symbol: 'µg'),
  milliliter(converter: 0.001, symbol: 'ml');

  final double converter;
  final String symbol;

  const UnitMassType({required this.converter, required this.symbol});
}

enum UnitEnergyType {
  kilocalories(converter: 1.0, symbol: 'kcal');

  final double converter;
  final String symbol;

  const UnitEnergyType({required this.converter, required this.symbol});
}
