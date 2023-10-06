import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_images.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/styles.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/ingredient_list_row.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

typedef OnTapAddIngredients = VoidCallback;
typedef OnTapIngredients = Function(PassioFoodItemData? data);

class IngredientsWidget extends StatelessWidget {
  const IngredientsWidget({this.onTapAddIngredients, this.data, this.onEditItem, this.onDeleteItem, super.key,});

  final OnTapAddIngredients? onTapAddIngredients;
  final List<PassioFoodItemData>? data;

  // When user deletes the item by swiping or sliding.
  final OnDeleteItem? onDeleteItem;
  final OnEditItem? onEditItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Dimens.h56,
          child: Stack(
            children: [
              Positioned(
                top: Dimens.h16,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    context.localization?.ingredients ?? '',
                    style: AppStyles.style17,
                  ),
                ),
              ),
              Positioned(
                top: Dimens.h8,
                right: Dimens.w16,
                child: SizedBox(
                  width: Dimens.r40,
                  height: Dimens.r40,
                  child: GestureDetector(
                    onTap: onTapAddIngredients,
                    child: SvgPicture.asset(
                      AppImages.icPlusCircle,
                      width: Dimens.r24,
                      height: Dimens.r24,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SlidableAutoCloseBehavior(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: ((data?.length ?? 0) > 1) ? data?.length : 0,
            itemBuilder: (context, index) {
              final ingredient = data?.elementAt(index);
              if (ingredient != null) {
                return IngredientListRow(
                  key: ValueKey(ingredient.passioID),
                  index: index,
                  computedWeight: ingredient.computedWeight(),
                  totalCalories: ingredient
                      .totalCalories()
                      ?.value ?? 0,
                  selectedQuantity: ingredient.selectedQuantity,
                  passioID: ingredient.passioID,
                  name: ingredient.name,
                  entityType: ingredient.entityType,
                  selectedUnit: ingredient.selectedUnit,
                  onDeleteItem: onDeleteItem,
                  onEditItem: onEditItem,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
