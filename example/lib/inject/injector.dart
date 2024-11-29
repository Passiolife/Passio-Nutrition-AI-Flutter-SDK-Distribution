import 'package:get_it/get_it.dart';
import 'package:nutrition_ai_example/presentation/food_search/bloc/food_search_bloc.dart';
import 'package:nutrition_ai_example/presentation/camera_recognition/bloc/camera_recognition_bloc.dart';

import '../presentation/search_food_semantic/bloc/search_food_semantic_bloc.dart';

GetIt sl = GetIt.instance;

abstract class Injector {
  static Future setup() async {
    // Configure modules here
    _registerBlocProviders();
  }

  static void _registerBlocProviders() {
    /// Food Search Page Bloc.
    sl.registerFactory(() => FoodSearchBloc());

    sl.registerFactory(() => CameraRecognitionBloc());

    sl.registerFactory(() => SearchFoodSemanticBloc());
  }
}
