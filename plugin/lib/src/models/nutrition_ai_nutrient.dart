import '../converter/platform_input_converter.dart';
import '../converter/platform_output_converter.dart';

class PassioNutrient {
  final double amount;
  final double inflammatoryEffectScore;
  final String name;
  final String unit;

  PassioNutrient(
      this.amount, this.inflammatoryEffectScore, this.name, this.unit);

  factory PassioNutrient.fromJson(Map<String, dynamic> json) =>
      mapToPassioNutrient(json);

  Map<String, dynamic> toJson() => mapOfPassioNutrient(this);
}
