import '../models/nutrition_ai_fooditemdata.dart';
import '../models/nutrition_ai_recipe.dart';
import '../nutrition_ai_detection.dart';

/// Data class that represent an entry in the SDK's nutritional database.
class PassioIDAttributes {
  /// ID of the food entry.
  final PassioID passioID;

  /// Name of the food entry.
  final String name;

  /// Defines the type of the food entry.
  final PassioIDEntityType entityType;

  /// If the food entry represent a single food item (as opposed to a recipe),
  /// this field will contain the information for the food item.
  final PassioFoodItemData? foodItem;

  /// If the food entry represent a recipe (as opposed to a single food item),
  /// this field will contain the information for that recipe.
  final PassioFoodRecipe? recipe;

  /// Contains a list of all of the parent nodes of the food entry.
  final List<PassioAlternative>? parents;

  /// Contains a list of all of the sibling nodes of the food entry.
  final List<PassioAlternative>? siblings;

  /// Contains a list of all of the children nodes of the food entry.
  final List<PassioAlternative>? children;

  const PassioIDAttributes(this.passioID, this.name, this.entityType,
      this.foodItem, this.recipe, this.parents, this.siblings, this.children);

  bool isOpenFood() {
    return foodItem?.isOpenFood() ?? recipe?.isOpenFood() ?? false;
  }

  String? openFoodLicense() {
    return foodItem?.openFoodLicense() ?? recipe?.openFoodLicense();
  }
}

/// Food items in the nutritional database are structured in a hierarchical way.
/// The [PassioAlternative] data class represents a child, sibling or a parent
/// of a given food item.
class PassioAlternative {
  final PassioID passioID;
  final String name;
  final double? quantity;
  final String? unitName;

  const PassioAlternative(
      this.passioID, this.name, this.quantity, this.unitName);
}

/// The origin of the data for a given food item of the nutritional database.
class PassioFoodOrigin {
  final String id;
  final String source;
  final String? licenseCopy;

  const PassioFoodOrigin(this.id, this.source, this.licenseCopy);
}

/// Defines different categories of food items provided by the SDK.
enum PassioIDEntityType {
  group,
  item,
  recipe,
  barcode,
  packagedFoodCode,
  nutritionFacts
}
