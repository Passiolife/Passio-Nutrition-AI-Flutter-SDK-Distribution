import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_constants.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/inject/injector.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/action_buttons_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/food_detail_header.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/serving_size_view_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/widgets/visual_alternative_widget.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food_ingredient/bloc/edit_food_item_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/custom_app_bar.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/double_extensions.dart';
import 'package:flutter_nutrition_ai_demo/util/string_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

typedef SliderData = ({double sliderMax, double sliderMin, double sliderStep, double sliderValue});

class EditFoodItemPage extends StatefulWidget {
  final PassioFoodItemData? foodItemData;

  /// [index] is item index from list of previous screen.
  final int index;

  const EditFoodItemPage({required this.index, this.foodItemData, super.key});

  @override
  State<EditFoodItemPage> createState() => _EditFoodItemPageState();
}

class _EditFoodItemPageState extends State<EditFoodItemPage> {
  /// [_updatedFoodRecord] is clone of [_updatedFoodRecord],
  /// but this object contains the updated changes.
  PassioFoodItemData? _updatedFoodRecord;

  /// below are the tags for the [Hero] widget.
  PassioID get tagPassioId => '${_updatedFoodRecord?.passioID}${widget.index}';

  String get tagName => '${_updatedFoodRecord?.name}${widget.index}';

  String get tagSubtitle => '${AppConstants.subtitle}${widget.index}';

  String get tagCalories => '${context.localization?.calories}${widget.index}';

  String get tagCaloriesData => '${AppConstants.calories}${widget.index}';

  /// Getting food name from the food record.
  String get _title => _updatedFoodRecord?.name.toUpperCaseWord ?? '';

  /// Getting nutritions from the food record.
  String get _subTitle => "${(_updatedFoodRecord?.selectedQuantity ?? 1).removeDecimalZeroFormat} ${_updatedFoodRecord?.selectedUnit ?? ""} "
      "(${_updatedFoodRecord?.computedWeight().value.removeDecimalZeroFormat ?? ""} ${_updatedFoodRecord?.computedWeight().symbol ?? ""})";

  // Get total calories from food.
  String get _totalCalories => (_updatedFoodRecord?.totalCalories()?.value ?? 0).removeDecimalZeroFormat;

  String get _totalCarbs =>
      "${(_updatedFoodRecord?.totalCarbs()?.value ?? 0).removeDecimalZeroFormat} ${_updatedFoodRecord?.totalCarbs()?.unit.symbol ?? ""}";

  String get _totalProteins =>
      "${(_updatedFoodRecord?.totalProteins()?.value ?? 0).removeDecimalZeroFormat} ${_updatedFoodRecord?.totalProteins()?.unit.symbol ?? ""}";

  String get _totalFat =>
      "${(_updatedFoodRecord?.totalFat()?.value ?? 0).removeDecimalZeroFormat} ${_updatedFoodRecord?.totalFat()?.unit.symbol ?? ""}";

  /// [_quantityController] is use to update and get the value from quantity text field.
  final TextEditingController _quantityController = TextEditingController();

  // [sliderValue] is defines the position of slider.
  // [sliderMaximum] is maximum value the user can select.
  SliderData _sliderData = (sliderValue: 0.0001, sliderStep: 1, sliderMin: 0.0001, sliderMax: 1.0);

  /// [FoodDetailsBloc] is use to call the events and emitting the states.
  final _bloc = sl<EditFoodItemBloc>();

  PassioServingSize? _selectedServingSize;

  List<PassioAlternative?> get _alternatives =>
      (_updatedFoodRecord?.parents ?? []) + (_updatedFoodRecord?.siblings ?? []) + (_updatedFoodRecord?.children ?? []);

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
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
            title: _title,
            isBackVisible: true,
            backPageName: context.localization?.back ?? '',
            leadingWidth: Dimens.w58,
            onBackTap: () {
              context.pop();
            },
            foregroundColor: AppColors.blackColor,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    FoodDetailHeader(
                      key: ValueKey(_updatedFoodRecord?.passioID),
                      passioID: _updatedFoodRecord?.passioID,
                      entityType: _updatedFoodRecord?.entityType ?? PassioIDEntityType.item,
                      title: _title,
                      subTitle: _subTitle,
                      totalCalories: _totalCalories,
                      totalCarbs: _totalCarbs,
                      totalProteins: _totalProteins,
                      totalFat: _totalFat,
                      tagPassioId: tagPassioId,
                      tagName: tagName,
                      tagSubtitle: tagSubtitle,
                      tagCalories: tagCalories,
                      tagCaloriesData: tagCaloriesData,
                    ),
                    Dimens.h4.verticalSpace,
                    ServingSizeViewWidget(
                      quantityController: _quantityController,
                      selectedServingUnitName: _updatedFoodRecord?.selectedUnit,
                      servingUnits: _updatedFoodRecord?.servingUnits,
                      onChangeServingUnit: (PassioServingUnit? servingUnit) {
                        _bloc.add(DoUpdateServingUnitEvent(data: _updatedFoodRecord, updatedUnitName: servingUnit?.unitName ?? ''));
                      },
                      computedWeight: _updatedFoodRecord?.computedWeight(),
                      sliderData: _sliderData,
                      onQuantityChange: (value) {
                        _bloc.add(DoUpdateQuantityEvent(data: _updatedFoodRecord, updatedQuantity: value));
                      },
                      servingSizes: _updatedFoodRecord?.servingSize,
                      selectedServingSize: _selectedServingSize,
                      onServingSizeChange: (servingSize) {
                        _bloc.add(DoUpdateServingSizeEvent(
                            data: _updatedFoodRecord, updatedUnitName: servingSize?.unitName, updatedQuantity: servingSize?.quantity));
                      },
                    ),
                    Dimens.h4.verticalSpace,
                    VisualAlternativeWidget(
                      alternatives: _alternatives,
                      onTapAlternative: (alternative) {
                        _bloc.add(DoAlternateEvent(passioID: alternative?.passioID));
                      },
                    ),
                    Dimens.h8.verticalSpace,
                  ],
                ),
              ),
              Dimens.h12.verticalSpace,
              ActionButtonsWidget(
                visibleCancelButton: true,
                visibleFavouriteButton: false,
                visibleSaveButton: true,
                onCancel: () {
                  context.pop();
                },
                onSave: (_) {
                  context.pop(_updatedFoodRecord);
                },
              ),
              Dimens.h16.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  void _initialize() {
    if (widget.foodItemData != null) {
      _updatedFoodRecord = const PassioFoodItemDataConverter().fromJson(const PassioFoodItemDataConverter().toJson(widget.foodItemData!));
    }
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
}
