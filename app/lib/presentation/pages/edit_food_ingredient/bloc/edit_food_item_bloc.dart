import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/edit_food_page.dart';
import 'package:flutter_nutrition_ai_demo/util/string_extensions.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'edit_food_item_event.dart';

part 'edit_food_item_state.dart';

class EditFoodItemBloc extends Bloc<EditFoodItemEvent, EditFoodItemState> {
  // [cachedMaxForSlider] stores the max value for the slider.
  final _cachedMaxForSlider = HashMap<String, double>();

  EditFoodItemBloc() : super(FoodDetailsInitial()) {
    on<EditFoodItemEvent>((event, emit) {});
    on<DoUpdateServingUnitEvent>(_handleDoUpdateServingUnitEvent);
    on<DoUpdateQuantityEvent>(_handleDoUpdateQuantityEvent);
    on<DoSliderUpdateEvent>(_handleDoSliderUpdateEvent);
    on<DoAlternateEvent>(_handleDoAlternateEvent);
    on<DoUpdateServingSizeEvent>(_handleDoUpdateServingSizeEvent);
  }

  FutureOr<void> _handleDoUpdateServingSizeEvent(DoUpdateServingSizeEvent event, Emitter<EditFoodItemState> emit) async {
    event.data?.setServingSize(event.updatedUnitName ?? '', event.updatedQuantity ?? 1);
    add(DoSliderUpdateEvent(data: event.data));
  }

  FutureOr<void> _handleDoUpdateServingUnitEvent(DoUpdateServingUnitEvent event, Emitter<EditFoodItemState> emit) {
    event.data?.setServingUnitKeepWeight(event.updatedUnitName);
    add(DoSliderUpdateEvent(data: event.data));
  }

  FutureOr<void> _handleDoUpdateQuantityEvent(DoUpdateQuantityEvent event, Emitter<EditFoodItemState> emit) async {
    event.data?.setServingSize(event.data?.selectedUnit ?? '', event.updatedQuantity);
    add(DoSliderUpdateEvent(data: event.data));
  }

  FutureOr<void> _handleDoSliderUpdateEvent(DoSliderUpdateEvent event, Emitter<EditFoodItemState> emit) async {
    SliderData sliderData = _updateSliderData(event.data);
    emit(SliderUpdateState(sliderData: sliderData));
  }

  SliderData _updateSliderData(PassioFoodItemData? foodRecord) {
    /// [sliderMultiplier] is use to multiply the quantity with [sliderMultiplier].
    /// So for ex: user selects 100gm then slider should be max upto 500.
    double sliderMultiplier = 5.0;

    /// Here define the [maxSliderFromData] value.
    /// It is sliderMultiplier * 1.0. So, the value is 5.0.
    double maxSliderFromData = 1.0 * sliderMultiplier;

    /// currentValue is the [selectedQuantity]. If it is null then set it 1.0.
    double currentValue = max(foodRecord?.selectedQuantity ?? 1.0, 0.0001);

    ///
    double sliderMaximumValue = 0;

    if (!_cachedMaxForSlider.containsKey(foodRecord?.selectedUnit)) {
      sliderMaximumValue = sliderMultiplier * currentValue;
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
    return (sliderValue: currentValue, sliderStep: sliderStep, sliderMin: 0.0001, sliderMax: sliderMaximumValue);
  }

  Future _handleDoAlternateEvent(DoAlternateEvent event, Emitter<EditFoodItemState> emit) async {
    if (event.passioID?.isNotNullOrEmpty ?? false) {
      final attributes = await NutritionAI.instance.lookupPassioAttributesFor(event.passioID!);
      PassioFoodItemData? data = attributes?.foodItem;
      emit(AlternateSuccessState(data: data));
    }
  }

}
