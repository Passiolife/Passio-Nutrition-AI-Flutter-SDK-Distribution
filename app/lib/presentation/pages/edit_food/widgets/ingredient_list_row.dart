import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_images.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/styles.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/double_extensions.dart';
import 'package:flutter_nutrition_ai_demo/util/string_extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

typedef OnDeleteItem = Function(int index);
typedef OnEditItem = Function(int index);

class IngredientListRow extends StatefulWidget {
  const IngredientListRow({
    required this.index,
    required this.computedWeight,
    required this.totalCalories,
    required this.selectedQuantity,
    this.passioID,
    this.name = '',
    this.entityType,
    this.selectedUnit,
    this.onDeleteItem,
    this.onEditItem,
    super.key,
  });

  final int index;

  //
  final PassioID? passioID;
  final String name;

  final PassioIDEntityType? entityType;

  ///
  // final FoodRecordResponse? data;
  final double totalCalories;
  final double selectedQuantity;
  final String? selectedUnit;
  final UnitMass computedWeight;

  // When user deletes the item by swiping or sliding.
  final OnDeleteItem? onDeleteItem;
  final OnEditItem? onEditItem;

  @override
  State<IngredientListRow> createState() => _IngredientListRowState();
}

class _IngredientListRowState extends State<IngredientListRow> {
  final ValueNotifier<PlatformImage?> _image = ValueNotifier(null);

  @override
  void initState() {
    _getFoodIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(onDismissed: () => widget.onDeleteItem?.call(widget.index)),
        children: [
          SlidableAction(
            onPressed: (context) => widget.onDeleteItem?.call(widget.index),
            backgroundColor: AppColors.errorColor,
            foregroundColor: Colors.white,
            label: context.localization?.delete ?? '',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => widget.onEditItem?.call(widget.index),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.r50)),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(Dimens.r8),
                child: Material(
                  type: MaterialType.transparency,
                  child: ValueListenableBuilder(
                    valueListenable: _image,
                    builder: (context, value, child) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: SizedBox(
                          width: Dimens.r52,
                          height: Dimens.r52,
                          child: PassioIcon(
                            key: ObjectKey(_image.value),
                            image: _image.value,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: Dimens.w8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        widget.name.toUpperCaseWord,
                        style: AppStyles.style17,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        "${(widget.selectedQuantity).removeDecimalZeroFormat} ${widget.selectedUnit?.toUpperCaseWord ?? ""} "
                        "(${widget.computedWeight.value.removeDecimalZeroFormat} ${widget.computedWeight.symbol})",
                        style: AppStyles.style12,
                      ),
                    ),
                    Row(
                      children: [
                        Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "${context.localization?.calories}: ",
                            style: AppStyles.style12,
                          ),
                        ),
                        Material(
                          type: MaterialType.transparency,
                          child: Text(
                            "${widget.totalCalories.toInt()}",
                            style: AppStyles.style12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimens.w8),
              SvgPicture.asset(
                AppImages.icArrowRight,
                width: Dimens.r30,
                height: Dimens.r30,
              ),
              SizedBox(width: Dimens.w8),
            ],
          ),
        ),
      ),
    );
  }

  void _getFoodIcon() async {
    /// Here, checking value of [passioID], if it is [AppConstants.removeIcon] OR [AppConstants.searching] then do nothing.
    /// else fetch the image using [passioID].
    if (widget.passioID == null) {
      _image.value = null;
      return;
    }

    PassioFoodIcons passioFoodIcons =
        await NutritionAI.instance.lookupIconsFor(widget.passioID ?? '', type: widget.entityType ?? PassioIDEntityType.item);

    if (passioFoodIcons.cachedIcon != null) {
      _image.value = passioFoodIcons.cachedIcon;
      return;
    }
    _image.value = passioFoodIcons.defaultIcon;

    var remoteIcon = await NutritionAI.instance.fetchIconFor(widget.passioID ?? '');
    if (remoteIcon != null) {
      _image.value = remoteIcon;
    }
  }
}
