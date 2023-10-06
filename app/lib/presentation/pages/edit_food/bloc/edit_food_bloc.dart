import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/edit_food_page.dart';
import 'package:flutter_nutrition_ai_demo/util/passio_food_item_data_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/passio_id_attributes_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/string_extensions.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'edit_food_event.dart';

part 'edit_food_state.dart';

class EditFoodBloc extends Bloc<EditFoodEvent, EditFoodState> {
  // [cachedMaxForSlider] stores the max value for the slider.
  final _cachedMaxForSlider = HashMap<String, double>();

  final double minSliderValue = 0.0001;

  EditFoodBloc() : super(EditFoodInitial()) {
    on<DoUpdateUnitKeepWeightEvent>(_handleDoUpdateUnitKeepWeightEvent);
    on<DoUpdateQuantityEvent>(_handleDoUpdateQuantityEvent);
    on<DoUpdateServingSizeEvent>(_handleDoUpdateServingSizeEvent);
    on<DoSliderUpdateEvent>(_handleDoSliderUpdateEvent);
    on<DoAlternateEvent>(_handleDoAlternateEvent);
    on<DoAddIngredientsEvent>(_handleDoAddIngredientsEvent);
    on<DoRemoveIngredientsEvent>(_handleDoRemoveIngredientsEvent);
    on<RefreshPageEvent>(_handleRefreshPageEvent);
    on<DoUpdateIngredientEvent>(_handleDoUpdateIngredientEvent);
    on<DoUpdateAmountEditableEvent>(_handleDoUpdateAmountEditableEvent);
  }

  FutureOr<void> _handleDoUpdateQuantityEvent(DoUpdateQuantityEvent event, Emitter<EditFoodState> emit) {
    final quantity = event.updatedQuantity == 0 ? event.updatedQuantity / 1000 : event.updatedQuantity;
    event.data?.setFoodRecordServing(event.data?.selectedUnit ?? '', quantity);
    add(DoSliderUpdateEvent(data: event.data));
  }

  FutureOr<void> _handleDoSliderUpdateEvent(DoSliderUpdateEvent event, Emitter<EditFoodState> emit) async {
    SliderData sliderData = _updateSliderData(event.data);
    emit(SliderUpdateState(sliderData: sliderData));
  }

  SliderData _updateSliderData(FoodRecord? foodRecord) {
    /// [sliderMultiplier] is use to multiply the quantity with [currentValue].
    /// So for ex: user selects 100gm then slider should be max up to 500.
    double sliderMultiplier = 5.0;

    /// Here define the [maxSliderFromData] value.
    /// It is sliderMultiplier * 1.0. So, the value is 5.0.
    double maxSliderFromData = 1.0 * sliderMultiplier;

    /// currentValue is the [selectedQuantity]. If it is null then set it 1.0.
    // double currentValue = max(foodRecord?.selectedQuantity ?? 1.0, minSliderValue);
    double currentValue = foodRecord?.selectedQuantity ?? 1;

    ///
    double sliderMaximumValue = 0;

    if (!_cachedMaxForSlider.containsKey(foodRecord?.selectedUnit)) {
      sliderMaximumValue = sliderMultiplier * max(currentValue, 1);
      _cachedMaxForSlider.putIfAbsent(foodRecord?.selectedUnit ?? '', () => sliderMaximumValue);
    } else {
      double? maxFromCache = _cachedMaxForSlider[foodRecord?.selectedUnit];
      if (maxFromCache == null || (maxFromCache > maxSliderFromData && maxFromCache > currentValue)) {
        sliderMaximumValue = maxFromCache ?? 0;
      } else if (maxSliderFromData > currentValue) {
        sliderMaximumValue = maxSliderFromData;
      } else {
        sliderMaximumValue = currentValue;
        _cachedMaxForSlider[foodRecord?.selectedUnit ?? ''] = sliderMaximumValue;
      }
    }

    double sliderStep = switch (sliderMaximumValue) {
      < 10 => sliderMaximumValue / 0.5,
      < 500 => sliderMaximumValue / 1,
      _ => sliderMaximumValue / 10,
    };

    return (sliderValue: currentValue, sliderStep: sliderStep, sliderMin: minSliderValue, sliderMax: sliderMaximumValue);
  }

  Future _handleDoAlternateEvent(DoAlternateEvent event, Emitter<EditFoodState> emit) async {
    if (event.passioID?.isNotNullOrEmpty ?? false) {
      final attributes = await NutritionAI.instance.lookupPassioAttributesFor(event.passioID!);
      final now = DateTime.now();
      final foodData = attributes?.toFoodRecord(dateTime: now);
      emit(AlternateSuccessState(data: foodData));
    }
  }

  FutureOr<void> _handleDoAddIngredientsEvent(DoAddIngredientsEvent event, Emitter<EditFoodState> emit) async {
    final attributes = await NutritionAI.instance.lookupPassioAttributesFor(event.ingredientData?.passioID ?? '');
    if (attributes != null) {

      if (attributes.foodItem != null) {
        event.data?.addIngredients(ingredient: attributes.foodItem?.copyWith(passioID: attributes.passioID, name: attributes.name), isFirst: true);
        emit(AddIngredientsSuccessState());
      } else if (attributes.entityType == PassioIDEntityType.recipe) {
        attributes.recipe?.foodItems.forEach((element) {
          event.data?.addIngredients(ingredient: element.copyWith(passioID: attributes.passioID, name: attributes.name), isFirst: true);
        });
        emit(AddIngredientsSuccessState());
      }
    }
  }

  FutureOr<void> _handleDoRemoveIngredientsEvent(DoRemoveIngredientsEvent event, Emitter<EditFoodState> emit) async {
    event.data?.removeIngredient(event.index) ?? false;
    emit(RemoveIngredientsState());
  }

  FutureOr<void> _handleRefreshPageEvent(RefreshPageEvent event, Emitter<EditFoodState> emit) async {
    emit(RefreshPageState());
  }

  FutureOr<void> _handleDoUpdateUnitKeepWeightEvent(DoUpdateUnitKeepWeightEvent event, Emitter<EditFoodState> emit) async {
    event.data?.setSelectedUnitKeepWeight(event.selectedUnitName);
    add(DoSliderUpdateEvent(data: event.data));
  }

  FutureOr<void> _handleDoUpdateServingSizeEvent(DoUpdateServingSizeEvent event, Emitter<EditFoodState> emit) {
    event.data?.setFoodRecordServing(event.updatedUnitName ?? '', event.updatedQuantity ?? 0);
    add(DoSliderUpdateEvent(data: event.data));
  }

  FutureOr<void> _handleDoUpdateIngredientEvent(DoUpdateIngredientEvent event, Emitter<EditFoodState> emit) async {
    if (event.updatedFoodItemData != null) {
      event.data?.replaceIngredient(event.updatedFoodItemData!, event.atIndex);
    }
    add(DoSliderUpdateEvent(data: event.data));
  }

  FutureOr<void> _handleDoUpdateAmountEditableEvent(DoUpdateAmountEditableEvent event, Emitter<EditFoodState> emit) {
    emit(UpdateAmountEditableState(isEditable: event.isEditable));
  }
}
