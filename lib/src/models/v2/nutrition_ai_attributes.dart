import '../../converter/platform_output_converter.dart';
import '../../nutrition_ai_detection.dart';
import '../enums.dart';
import 'passio_alternative.dart';
import 'nutrition_ai_fooditemdata.dart';
import 'nutrition_ai_recipe.dart';

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

  const PassioIDAttributes(
    this.passioID,
    this.name,
    this.entityType,
    this.foodItem,
    this.recipe,
    this.parents,
    this.siblings,
    this.children,
  );

  factory PassioIDAttributes.fromJson(Map<String, dynamic> json) =>
      PassioIDAttributes(
          json["passioID"],
          json["name"],
          PassioIDEntityType.values.byName(json["entityType"]),
          json.ifValueNotNull("foodItem", PassioFoodItemData.fromJson),
          json.ifValueNotNull("recipe", PassioFoodRecipe.fromJson),
          mapListOfObjectsOptional(json["parents"], PassioAlternative.fromJson),
          mapListOfObjectsOptional(
              json["siblings"], PassioAlternative.fromJson),
          mapListOfObjectsOptional(
              json["children"], PassioAlternative.fromJson));

  Map<String, dynamic> toJson() => {
        'passioID': passioID,
        'name': name,
        'entityType': entityType.name,
        'foodItem': foodItem?.toJson(),
        'recipe': recipe?.toJson(),
        'parents': parents?.map((e) => e.toJson()).toList(),
        'siblings': siblings?.map((e) => e.toJson()).toList(),
        'children': children?.map((e) => e.toJson()).toList(),
      };

  bool isOpenFood() {
    return foodItem?.isOpenFood() ?? recipe?.isOpenFood() ?? false;
  }

  String? openFoodLicense() {
    return foodItem?.openFoodLicense() ?? recipe?.openFoodLicense();
  }
}
