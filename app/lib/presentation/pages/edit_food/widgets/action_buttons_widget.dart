import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/custom_button.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnCancel = VoidCallback;
typedef OnSave = Function(FoodRecord? foodRecord);
typedef OnFavourite = Function(FoodRecord? foodRecord);

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({
    this.onCancel,
    this.onSave,
    this.onFavorites,
    required this.visibleCancelButton,
    required this.visibleFavouriteButton,
    required this.visibleSaveButton,
    this.saveButtonText,
    this.cancelButtonText,
    super.key,
  });

  final OnCancel? onCancel;
  final OnSave? onSave;
  final OnFavourite? onFavorites;

  // [isCancelButtonVisible] is by default [true], so the cancel button will be visible, else hidden if [isCancelButtonVisible] is [false].
  final bool visibleCancelButton;

  // [visibleFavouriteButton] is by default [true], so the favourite button will be visible, else hidden if [visibleFavouriteButton] is [false].
  final bool visibleFavouriteButton;

  // [visibleSaveButton] is by default [true], so the save button will be visible, else hidden if [visibleSaveButton] is [false].
  final bool visibleSaveButton;

  // [cancelButtonText] is use to set the text for cancel button.
  final String? cancelButtonText;

  // [saveButtonText] is use to set the text for save button.
  final String? saveButtonText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Dimens.w4.horizontalSpace,
        Visibility(
          visible: visibleCancelButton,
          child: Expanded(
            child: CustomElevatedButton(
              onTap: onCancel,
              text: cancelButtonText ?? context.localization?.cancel ?? '',
            ),
          ),
        ),
        Dimens.w8.horizontalSpace,
        Visibility(
          visible: visibleFavouriteButton,
          child: Expanded(
            child: CustomElevatedButton(
              onTap: () => onFavorites?.call(null),
              text: context.localization?.favorites ?? '',
            ),
          ),
        ),
        Dimens.w8.horizontalSpace,
        Visibility(
          visible: visibleSaveButton,
          child: Expanded(
            child: CustomElevatedButton(
              onTap: () => onSave?.call(null),
              text: saveButtonText ?? context.localization?.save ?? '',
            ),
          ),
        ),
        Dimens.w4.horizontalSpace,
      ],
    );
  }
}
