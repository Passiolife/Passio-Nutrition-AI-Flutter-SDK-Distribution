import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/util/json_utility.dart';

part 'legacy_api_event.dart';
part 'legacy_api_state.dart';

class LegacyApiBloc extends Bloc<LegacyApiEvent, LegacyApiState> {
  LegacyApiBloc() : super(const LegacyApiInitial()) {
    on<DoFetchLegacyEvent>(_handleDoFetchLegacyEvent);
  }

  Future<void> _handleDoFetchLegacyEvent(
      DoFetchLegacyEvent event, Emitter<LegacyApiState> emit) async {
    final result =
        await NutritionAI.instance.fetchFoodItemLegacy(event.passioID);
    final formattedJson = JsonUtility.getPrettyJSONString(result);
    emit(FetchLegacySuccessState(formattedJson));
  }
}
