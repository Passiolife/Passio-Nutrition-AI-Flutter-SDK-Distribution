import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_constants.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/inject/injector.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/bloc/edit_food_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/dialogs/rename_food_dialogs.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/action_buttons_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/food_detail_header.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/ingredients_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/meal_time_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/serving_size_view_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/visual_alternative_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_nutrition_ai_demo/router/routes.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/double_extensions.dart';
import 'package:flutter_nutrition_ai_demo/util/string_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

typedef SliderData = ({double sliderMax, double sliderMin, double sliderStep, double sliderValue});

class EditFoodPage extends StatefulWidget {
  final FoodRecord? foodRecord;

  /// [index] is item index from list of previous screen.
  final int index;

  const EditFoodPage({
    this.index = 0,
    this.foodRecord,
    this.backgroundColor,
    this.visibleCancelButton = true,
    this.visibleFavouriteButton = true,
    this.visibleSaveButton = true,
    this.visibleAppBar = true,
    this.visibleIngredientsView = true,
    this.onSave,
    this.onCancel,
    this.onFavourite,
    super.key,
  });

  // [visibleCancelButton] is by default [true], so the cancel button will be visible, else hidden if [visibleCancelButton] is [false].
  final bool visibleCancelButton;

  // [visibleFavouriteButton] is by default [true], so the favourite button will be visible, else hidden if [visibleFavouriteButton] is [false].
  final bool visibleFavouriteButton;

  // [visibleSaveButton] is by default [true], so the save button will be visible, else hidden if [visibleSaveButton] is [false].
  final bool visibleSaveButton;

  // [visibleAppBar] is by default [true], so the app bar will be visible by default, else hidden if [visibleAppBar] is [false].
  final bool visibleAppBar;

  // [backgroundColor]  default color is scaffold color from theme else set the color in background.
  final Color? backgroundColor;

  // [visibleIngredientsView] is by default [true], so the ingredients view will be visible by default, else hidden if [visibleIngredientsView] is [false].
  final bool visibleIngredientsView;

  // [onSave] will call when user taps on save button.
  final OnSave? onSave;

  // [onCancel] will call when user taps on cancel button.
  final OnCancel? onCancel;

  // [onFavourite] will call when user taps on favourite button.
  final OnFavourite? onFavourite;

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  /// [_updatedFoodRecord] is clone of [_updatedFoodRecord],
  /// but this object contains the updated changes.
  FoodRecord? _updatedFoodRecord;

  /// below are the tags for the [Hero] widget.
  PassioID get tagPassioId => '${_updatedFoodRecord?.passioID}${widget.index}';

  String get tagName => '${_updatedFoodRecord?.name}${widget.index}';

  String get tagSubtitle => '${AppConstants.subtitle}${widget.index}';

  String get tagCalories => '${context.localization?.calories}${widget.index}';

  String get tagCaloriesData => '${AppConstants.calories}${widget.index}';

  /// Getting food name from the food record.
  String get title => _updatedFoodRecord?.name.toUpperCaseWord ?? '';

  /// Getting nutrition from the food record.
  String get subTitle => "${(_updatedFoodRecord?.selectedQuantity ?? 1).removeDecimalZeroFormat} ${_updatedFoodRecord?.selectedUnit ?? ""} "
      "(${_updatedFoodRecord?.computedWeight.value.removeDecimalZeroFormat ?? ""} ${_updatedFoodRecord?.computedWeight.symbol ?? ""})";

  // Get total calories from food.
  String get _totalCalories => (_updatedFoodRecord?.totalCalories.toInt() ?? 0).toString();

  String get _totalCarbs =>
      "${(_updatedFoodRecord?.totalCarbs ?? 0).removeDecimalZeroFormat} ${_updatedFoodRecord?.ingredients?.firstOrNull?.totalCarbs()?.unit.symbol ?? ""}";

  String get _totalProteins =>
      "${(_updatedFoodRecord?.totalProteins ?? 0).removeDecimalZeroFormat} ${_updatedFoodRecord?.ingredients?.firstOrNull?.totalProteins()?.unit.symbol ?? ""}";

  String get _totalFat =>
      "${(_updatedFoodRecord?.totalFat ?? 0).removeDecimalZeroFormat} ${_updatedFoodRecord?.ingredients?.firstOrNull?.totalFat()?.unit.symbol ?? ""}";

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
  void dispose() {
    _quantityController.dispose();
    _bloc.close();
    super.dispose();
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

        /// States for DoAddIngredientsEvent
        else if (state is AddIngredientsSuccessState) {
          _handleAddIngredientsSuccessState(state: state);
        }

        // States for DoRemoveIngredientsEvent
        else if (state is RemoveIngredientsState) {
          _handleRemoveIngredientsState(state: state);
        }

        //
        else if (state is UpdateAmountEditableState) {
          _handleUpdateAmountEditableState(state: state);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: widget.backgroundColor ?? context.theme.scaffoldBackgroundColor,
          resizeToAvoidBottomInset: false,
          appBar: widget.visibleAppBar
              ? CustomAppBar(
                  title: title,
                  isBackVisible: true,
                  leadingWidth: Dimens.w58,
                  backPageName: context.localization?.back ?? '',
                  onBackTap: () {
                    context.pop();
                  },
                  foregroundColor: AppColors.blackColor,
                )
              : null,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: widget.visibleIngredientsView ? 1 : 0,
                child: ListView(
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
                      onTapTitle: () {
                        RenameFoodDialogs.show(
                          context: context,
                          title: context.localization?.renameFoodRecord,
                          text: title,
                          onRenameFood: (text) {
                            _updatedFoodRecord?.name = text;
                          },
                        );
                      },
                    ),
                    Dimens.h4.verticalSpace,
                    AnimatedCrossFade(
                      crossFadeState: (visibleCloseButton) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: Dimens.duration500),
                      firstChild: Column(
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
                          Dimens.h8.verticalSpace,
                          Visibility(
                            visible: widget.visibleIngredientsView,
                            child: IngredientsWidget(
                              data: _updatedFoodRecord?.ingredients,
                              onTapAddIngredients: _handleOnTapAddIngredients,
                              onDeleteItem: _handleDeleteItem,
                              onEditItem: _handleOnEditItem,
                            ),
                          ),
                        ],
                      ),
                      secondChild: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                          Dimens.h8.verticalSpace,
                          Visibility(
                            visible: widget.visibleIngredientsView,
                            child: IngredientsWidget(
                              data: _updatedFoodRecord?.ingredients,
                              onTapAddIngredients: _handleOnTapAddIngredients,
                              onDeleteItem: _handleDeleteItem,
                              onEditItem: _handleOnEditItem,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Dimens.h12.verticalSpace,
              ActionButtonsWidget(
                visibleCancelButton: widget.visibleCancelButton,
                visibleFavouriteButton: widget.visibleFavouriteButton,
                visibleSaveButton: widget.visibleSaveButton,
                onCancel: widget.onCancel ??
                    () {
                      context.pop();
                    },
                onSave: (widget.onSave != null)
                    ? (_) => widget.onSave?.call(_updatedFoodRecord)
                    : (_) {
                        context.pop((context.localization?.save, _updatedFoodRecord));
                      },
                onFavorites: _handleOnFavorites,
              ),
              Dimens.h24.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  void _initialize() {
    _updatedFoodRecord = FoodRecord.fromJson(widget.foodRecord?.toJson());

    /// Here checking ingredients count if it is more than 1 then editable is not visible by default,
    /// else we will show the editable widget.
    visibleCloseButton = (_updatedFoodRecord?.ingredients?.length ?? 0) <= 1;
    visibleEditAmountButton = (_updatedFoodRecord?.ingredients?.length ?? 0) > 1;
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

  void _handleAddIngredientsSuccessState({required AddIngredientsSuccessState state}) {
    _updateSelectedPassioServingSize();
    _bloc.add(DoSliderUpdateEvent(data: _updatedFoodRecord));
  }

  Future _handleOnTapAddIngredients() async {
    final data = await context.pushNamed(Routes.foodSearchPage);
    if (data != null && data is PassioIDAndName?) {
      _bloc.add(DoAddIngredientsEvent(data: _updatedFoodRecord, ingredientData: data as PassioIDAndName?));
    }
  }

  void _handleDeleteItem(int index) {
    _bloc.add(DoRemoveIngredientsEvent(index: index, data: _updatedFoodRecord));
  }

  void _handleRemoveIngredientsState({required RemoveIngredientsState state}) {
    _updateSelectedPassioServingSize();
    _bloc.add(DoSliderUpdateEvent(data: _updatedFoodRecord));
  }

  Future<void> _handleOnEditItem(int index) async {
    PassioFoodItemData? data = await context
        .pushNamed(Routes.editFoodItemPage, extra: {AppConstants.index: index, AppConstants.data: _updatedFoodRecord?.ingredients?.elementAt(index)});
    if (data != null) {
      _bloc.add(DoUpdateIngredientEvent(atIndex: index, updatedFoodItemData: data, data: _updatedFoodRecord));
    }
  }

  void _handleUpdateAmountEditableState({required UpdateAmountEditableState state}) {
    visibleCloseButton = state.isEditable;
    visibleEditAmountButton = !state.isEditable;
  }

  void _handleOnFavorites(FoodRecord? foodRecord) {
    RenameFoodDialogs.show(
      context: context,
      title: context.localization?.favoriteDialogTitle,
      text: '',
      placeHolder: 'My ${_updatedFoodRecord?.name}'.toUpperCaseWord,
      onRenameFood: (value) {
        _updatedFoodRecord?.name = value;
        (widget.onFavourite != null)
            ? widget.onFavourite?.call(_updatedFoodRecord)
            : context.pop((context.localization?.favorites, _updatedFoodRecord));
      },
    );
  }
}
