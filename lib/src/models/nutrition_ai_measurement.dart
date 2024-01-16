import '../converter/platform_input_converter.dart';
import '../converter/platform_output_converter.dart';

/// Base class used to create units for mass, energy, etc.
abstract class Unit {
  double value = 1.0;
  double converter = 1.0;
  String symbol = "";

  Unit(this.value, this.converter, this.symbol);

  Unit operator *(double mult) => times(mult);

  Unit times(double mult);
}

/// Class that represents a measurement of mass.
class UnitMass extends Unit {
  final UnitMassType unit;

  UnitMass(double value, this.unit) : super(value, unit.converter, unit.symbol);

  double gramsValue() => value * unit.converter * 1000;

  @override
  Unit times(double mult) {
    return UnitMass(value * mult, unit);
  }

  factory UnitMass.fromJson(Map<String, dynamic> json) => mapToUnitMass(json);

  Map<String, dynamic> toJson() => mapOfUnitMass(this);
}

/// Class that represents a measurement of energy.
class UnitEnergy extends Unit {
  final UnitEnergyType unit;

  UnitEnergy(double value, this.unit)
      : super(value, unit.converter, unit.symbol);

  @override
  Unit times(double mult) {
    return UnitEnergy(value * mult, unit);
  }

  factory UnitEnergy.fromJson(Map<String, dynamic> json) =>
      mapToUnitEnergy(json);

  Map<String, dynamic> toJson() => mapOfUnitEnergy(this);
}

/// Class that represents a measurement of IU.
class UnitIU extends Unit {
  UnitIU(double value) : super(value, 1.0, "iu");

  @override
  Unit times(double mult) {
    return UnitIU(value * mult);
  }

  factory UnitIU.fromJson(Map<String, dynamic> json) => mapToUnitIU(json);

  Map<String, dynamic> toJson() => mapOfUnitIU(this);
}

enum UnitMassType {
  kilograms(converter: 1.0, symbol: 'kg'),
  grams(converter: 0.001, symbol: 'g'),
  milligrams(converter: 0.000001, symbol: 'mg'),
  micrograms(converter: 0.000000001, symbol: 'µg');

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
