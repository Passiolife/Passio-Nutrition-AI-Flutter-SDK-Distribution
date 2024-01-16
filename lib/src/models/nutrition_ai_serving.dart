import '../converter/platform_input_converter.dart';
import '../converter/platform_output_converter.dart';
import '../models/nutrition_ai_measurement.dart';

/// Data class that represents the serving sizes of a food item.
class PassioServingSize {
  final double quantity;
  final String unitName;

  PassioServingSize(this.quantity, this.unitName);

  factory PassioServingSize.fromJson(Map<String, dynamic> json) =>
      mapToPassioServingSize(json);

  Map<String, dynamic> toJson() => mapOfPassioServingSize(this);
}

/// Data class that represents the serving unit of a food item.
class PassioServingUnit {
  final String unitName;
  final UnitMass weight;

  PassioServingUnit(this.unitName, this.weight);

  factory PassioServingUnit.fromJson(Map<String, dynamic> json) =>
      mapToPassioServingUnit(json);

  Map<String, dynamic> toJson() => mapOfPassioServingUnit(this);
}
