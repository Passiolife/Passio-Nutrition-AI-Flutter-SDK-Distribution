import 'package:get_it/get_it.dart';
//import 'package:nutrition_ai_example/data/repository/static_nutrition_ai_repository.dart';
import 'package:nutrition_ai_example/data/repository/nutrition_ai_sdk_repository.dart';
import 'package:nutrition_ai_example/domain/repository/nutrition_ai_wrapper.dart';
import 'package:nutrition_ai_example/presentation/food_search/bloc/food_search_bloc.dart';
import 'package:nutrition_ai_example/presentation/static_image/bloc/static_image_bloc.dart';
import 'package:nutrition_ai_example/presentation/camera_recognition/bloc/camera_recognition_bloc.dart';

GetIt sl = GetIt.instance;

abstract class Injector {
  static Future setup() async {
    /// Repository
    _registerRepositories();

    // Configure modules here
    _registerBlocProviders();
  }

  static void _registerRepositories() {
    sl.registerLazySingleton<NutritionAiWrapper>(
        () => NutritionAiSDKRepository());
    // sl.registerLazySingleton<NutritionAiWrapper>(() => MockNutritionAiSDKRepository());
  }

  static void _registerBlocProviders() {
    /// Food Search Page Bloc.
    sl.registerFactory(() => FoodSearchBloc());

    /// Static Image Page Bloc.
    sl.registerFactory(() => StaticImageBloc(nutritionAiWrapper: sl()));

    sl.registerFactory(() => CameraRecognitionBloc());
  }
}
