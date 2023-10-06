import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_constants.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/inject/injector.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/bloc/edit_food_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/dialogs/rename_food_dialogs.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/action_buttons_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/food_detail_header.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/meal_time_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/serving_size_view_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/visual_alternative_widget.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/double_extensions.dart';
import 'package:flutter_nutrition_ai_demo/util/string_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

typedef OnCancel = VoidCallback;
typedef OnLog = VoidCallback;
typedef SliderData = ({double sliderMax, double sliderMin, double sliderStep, double sliderValue});

class FoodDetailsWidget extends StatefulWidget {
  final FoodRecord? foodRecord;

  // [visibleCancelButton] is by default [true], so the cancel button will be visible, else hidden if [visibleCancelButton] is [false].
  final bool visibleCancelButton;

  // [visibleFavouriteButton] is by default [true], so the favourite button will be visible, else hidden if [visibleFavouriteButton] is [false].
  final bool visibleFavouriteButton;

  // [visibleSaveButton] is by default [true], so the save button will be visible, else hidden if [visibleSaveButton] is [false].
  final bool visibleSaveButton;

  // [onSave] will call when user taps on save button.
  final OnSave? onSave;

  // [onFavourite] will call when user taps on favourite button.
  final OnFavourite? onFavourite;

  // [onCancel] will call when user taps on cancel button.
  final OnCancel? onCancel;

  // [cancelButtonText] is use to set the text for cancel button.
  final String? cancelButtonText;

  // [saveButtonText] is use to set the text for save button.
  final String? saveButtonText;

  const FoodDetailsWidget({
    super.key,
    this.foodRecord,
    this.visibleCancelButton = true,
    this.visibleFavouriteButton = true,
    this.visibleSaveButton = true,
    this.onSave,
    this.onCancel,
    this.saveButtonText,
    this.cancelButtonText,
    this.onFavourite,
  });

  @override
  State<FoodDetailsWidget> createState() => _FoodDetailsWidgetState();
}

class _FoodDetailsWidgetState extends State<FoodDetailsWidget> with TickerProviderStateMixin {
  /// [_updatedFoodRecord] is clone of [_updatedFoodRecord],
  /// but this object contains the updated changes.
  FoodRecord? _updatedFoodRecord;

  /// below are the tags for the [Hero] widget.
  PassioID get tagPassioId => '${_updatedFoodRecord?.passioID}';

  String get tagName => '${_updatedFoodRecord?.name}';

  String get tagSubtitle => AppConstants.subtitle;

  String get tagCalories => '${context.localization?.calories}';

  String get tagCaloriesData => AppConstants.calories;

  /// Getting food name from the food record.
  String get title =>
      ((_updatedFoodRecord?.ingredients?.length ?? 0) > 1)
          ? '${(context.localization?.recipeWith.toUpperCaseWord ?? '')} ${_updatedFoodRecord?.name.toUpperCaseWord ?? ''}'
          : _updatedFoodRecord?.name.toUpperCaseWord ?? '';

  /// Getting nutritions from the food record.
  String get subTitle => "${(_updatedFoodRecord?.selectedQuantity ?? 1).removeDecimalZeroFormat} ${_updatedFoodRecord?.selectedUnit ?? ""} "
      "(${_updatedFoodRecord?.computedWeight.value.removeDecimalZeroFormat ?? ""} ${_updatedFoodRecord?.computedWeight.symbol ?? ""})";

  // Get total calories from food.
  String get _totalCalories => (_updatedFoodRecord?.totalCalories.toInt() ?? 0).toString();

  String get _totalCarbs =>
      "${(_updatedFoodRecord?.totalCarbs ?? 0).removeDecimalZeroFormat} ${_updatedFoodRecord?.ingredients?.firstOrNull
          ?.totalCarbs()
          ?.unit
          .symbol ?? ""}";

  String get _totalProteins =>
      "${(_updatedFoodRecord?.totalProteins ?? 0).removeDecimalZeroFormat} ${_updatedFoodRecord?.ingredients?.firstOrNull
          ?.totalProteins()
          ?.unit
          .symbol ?? ""}";

  String get _totalFat =>
      "${(_updatedFoodRecord?.totalFat ?? 0).removeDecimalZeroFormat} ${_updatedFoodRecord?.ingredients?.firstOrNull
          ?.totalFat()
          ?.unit
          .symbol ?? ""}";

  /// [_quantityController] is use to update and get the value from quantity text field.
  final TextEditingController _quantityController = TextEditingController();

  // [sliderValue] is defines the position of slider.
  // [sliderMaximum] is maximum value the user can select.
  SliderData _sliderData = (sliderValue: 0.0001, sliderStep: 1, sliderMin: 0.0001, sliderMax: 1.0);

  /// [_bloc] is use to call the events and emitting the states.
  final _bloc = sl<EditFoodBloc>();

  PassioServingSize? _selectedServingSize;

  List<PassioAlternative?> get _alternatives =>
      (_updatedFoodRecord?.parents ?? []) + (_updatedFoodRecord?.siblings ?? []) + (_updatedFoodRecord?.children ?? []);

  // [visibleEditAmountButton] use in FoodDetailHeader to show the "Edit Amount" button.
  bool visibleEditAmountButton = false;

  // [visibleCloseButton] use in [ServingSizeViewWidget] to show the "Close" button.
  bool visibleCloseButton = false;

  @override
  void initState() {
    _initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _bloc,
      listener: (context, state) {
        if (state is SliderUpdateState) {
          _handleSliderUpdateState(state: state);
        } else if (state is AlternateSuccessState) {
          _handleAlternateSuccessState(state: state);
        }
      },
      builder: (context, state) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          builder: (BuildContext context, double value, Widget? child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: value,
                child: child,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(left: Dimens.w8, right: Dimens.w8, top: context.topPadding),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.r16),
                color: Colors.grey.shade200.withOpacity(Dimens.opacity50),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      Dimens.h12.verticalSpace,
                      FoodDetailHeader(
                        key: ValueKey(_updatedFoodRecord?.passioID),
                        passioID: _updatedFoodRecord?.passioID,
                        entityType: _updatedFoodRecord?.entityType ?? PassioIDEntityType.item,
                        title: title,
                        subTitle: subTitle,
                        totalCalories: _totalCalories,
                        totalCarbs: _totalCarbs,
                        totalProteins: _totalProteins,
                        totalFat: _totalFat,
                        tagPassioId: tagPassioId,
                        tagName: tagName,
                        tagSubtitle: tagSubtitle,
                        tagCalories: tagCalories,
                        tagCaloriesData: tagCaloriesData,
                        isEditAmountVisible: visibleEditAmountButton,
                        onTapEditAmount: () {
                          _bloc.add(DoUpdateAmountEditableEvent(isEditable: true));
                        },
                      ),
                      Dimens.h4.verticalSpace,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ServingSizeViewWidget(
                            quantityController: _quantityController,
                            selectedServingUnitName: _updatedFoodRecord?.selectedUnit,
                            servingUnits: _updatedFoodRecord?.servingUnits,
                            onChangeServingUnit: (PassioServingUnit? servingUnit) {
                              _bloc.add(DoUpdateUnitKeepWeightEvent(data: _updatedFoodRecord, selectedUnitName: servingUnit?.unitName ?? ''));
                            },
                            computedWeight: _updatedFoodRecord?.computedWeight,
                            sliderData: _sliderData,
                            onQuantityChange: (value) {
                              _bloc.add(DoUpdateQuantityEvent(data: _updatedFoodRecord, updatedQuantity: value));
                            },
                            servingSizes: _updatedFoodRecord?.servingSizes,
                            selectedServingSize: _selectedServingSize,
                            onServingSizeChange: (servingSize) {
                              _bloc.add(DoUpdateServingSizeEvent(
                                updatedUnitName: servingSize?.unitName,
                                updatedQuantity: servingSize?.quantity,
                                data: _updatedFoodRecord,
                              ));
                            },
                            isCloseVisible: visibleCloseButton,
                            onTapCloseEdit: () {
                              _bloc.add(DoUpdateAmountEditableEvent(isEditable: false));
                            },
                          ),
                          Dimens.h4.verticalSpace,
                          VisualAlternativeWidget(
                            alternatives: _alternatives,
                            onTapAlternative: (alternative) {
                              _bloc.add(DoAlternateEvent(passioID: alternative?.passioID));
                            },
                          ),
                          Dimens.h4.verticalSpace,
                          MealTimeWidget(
                            selectedMealLabel: _updatedFoodRecord?.mealLabel,
                            onUpdateMealTime: (label) {
                              _updatedFoodRecord?.mealLabel = label;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Dimens.h12.verticalSpace,
                  ActionButtonsWidget(
                    visibleCancelButton: widget.visibleCancelButton,
                    visibleFavouriteButton: widget.visibleFavouriteButton,
                    visibleSaveButton: widget.visibleSaveButton,
                    onCancel: widget.onCancel,
                    onSave: (_) => widget.onSave?.call(_updatedFoodRecord),
                    onFavorites: (_) => _handleOnFavorites(),
                    saveButtonText: widget.saveButtonText,
                    cancelButtonText: widget.cancelButtonText,
                  ),
                  Dimens.h24.verticalSpace,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _initialize() {
    _updatedFoodRecord = FoodRecord.fromJson(widget.foodRecord?.toJson());

    _updateSelectedPassioServingSize();
    _bloc.add(DoSliderUpdateEvent(data: _updatedFoodRecord));
  }

  void _handleSliderUpdateState({required SliderUpdateState state}) {
    _sliderData = state.sliderData;

    _updateSelectedPassioServingSize();

    // Updating the text field value.
    _quantityController.text = _sliderData.sliderValue.removeDecimalZeroFormat;
  }

  void _updateSelectedPassioServingSize() {
    _selectedServingSize = PassioServingSize(_updatedFoodRecord?.selectedQuantity ?? 0, _updatedFoodRecord?.selectedUnit ?? '');
  }

  void _handleAlternateSuccessState({required AlternateSuccessState state}) {
    _updatedFoodRecord = state.data;
  }

  void _handleOnFavorites() {
    RenameFoodDialogs.show(
      context: context,
      title: context.localization?.favoriteDialogTitle,
      text: '',
      placeHolder: 'My ${_updatedFoodRecord?.name}'.toUpperCaseWord,
      onRenameFood: (value) {
        _updatedFoodRecord?.name = value;
        widget.onFavourite?.call(_updatedFoodRecord);
      },
    );
  }
}
