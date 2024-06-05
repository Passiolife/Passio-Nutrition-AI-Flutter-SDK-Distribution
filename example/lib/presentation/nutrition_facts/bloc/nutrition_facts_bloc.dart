import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'nutrition_facts_event.dart';
part 'nutrition_facts_state.dart';

class NutritionFactsBloc
    extends Bloc<NutritionFactsEvent, NutritionFactsState> {
  PassioID? currentPassioID;

  NutritionFactsBloc() : super(SearchingState()) {
    on<NutritionFactsRecognizedEvent>(_handleCameraRecognitionEvent);
  }

  Future _handleCameraRecognitionEvent(NutritionFactsRecognizedEvent event,
      Emitter<NutritionFactsState> emit) async {
    emit(UpdateNutritionFactsState(
        text: event.text, nutritionFacts: event.nutritionFacts));
  }
}
