import '../models/nutrition_ai_measurement.dart';

/// Data class that represents the serving sizes of a food item.
class PassioServingSize {
  final double quantity;
  final String unitName;

  PassioServingSize(this.quantity, this.unitName);
}

/// Data class that represents the serving unit of a food item.
class PassioServingUnit {
  final String unitName;
  final UnitMass weight;

  PassioServingUnit(this.unitName, this.weight);
}
