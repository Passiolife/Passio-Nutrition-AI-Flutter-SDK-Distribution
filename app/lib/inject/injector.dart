import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_theme.dart';
import 'package:flutter_nutrition_ai_demo/data/core/network/network_info.dart';
import 'package:flutter_nutrition_ai_demo/data/datasources/favourite/favorite_local_data_source.dart';
import 'package:flutter_nutrition_ai_demo/data/datasources/food_record/food_record_local_data_source.dart';
import 'package:flutter_nutrition_ai_demo/data/datasources/user/user_local_data_source.dart';
import 'package:flutter_nutrition_ai_demo/data/local_db_connector.dart';
import 'package:flutter_nutrition_ai_demo/data/repository/favorite_repository_impl.dart';
import 'package:flutter_nutrition_ai_demo/data/repository/food_repository_impl.dart';
import 'package:flutter_nutrition_ai_demo/data/repository/user_repository_impl.dart';
import 'package:flutter_nutrition_ai_demo/domain/repository/favorite_repository.dart';
import 'package:flutter_nutrition_ai_demo/domain/repository/food_repository.dart';
import 'package:flutter_nutrition_ai_demo/domain/repository/user_repository.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/dashboard/delete_food_record_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/dashboard/fetch_day_records_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/dashboard/update_food_record_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/favourite/delete_favorite_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/favourite/get_favourites_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/favourite/update_favorite_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/user/get_user_profile_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/user/update_user_profile_use_case.dart';
import 'package:flutter_nutrition_ai_demo/passio_connector.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/bloc/edit_food_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food_ingredient/bloc/edit_food_item_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/favourite/bloc/favourite_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/food_search/bloc/food_search_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/multi_food_scan/bloc/multi_food_scan_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/progress/bloc/progress_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/quick_food_scan/bloc/quick_food_scan_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/sign_up/bloc/sign_up_bloc.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:flutter_nutrition_ai_demo/util/database_helper.dart';
import 'package:flutter_nutrition_ai_demo/util/preference_store.dart';
import 'package:flutter_nutrition_ai_demo/util/user_session.dart';
import 'package:get_it/get_it.dart';

GetIt sl = GetIt.instance;

abstract class Injector {
  static Future setup() async {
    // Configure modules here
    await _registerLocalCache();
    _registerMiscModules();
    _configureNetworkModules();
    _registerConnectors();
    _registerDataSource();
    _registerRepositories();
    _registerUseCases();
    _registerBlocProviders();
  }

  static Future<void> _registerLocalCache() async {
    sl.registerLazySingleton<PreferenceStore>(() => PreferenceStore());
    await sl<PreferenceStore>().init();

    /// Initialize database
    sl.registerLazySingleton(() => DatabaseHelper());
    await sl<DatabaseHelper>().init();
  }

  static Future<void> _registerMiscModules() async {
    // Registering the [UserSession] class for singleton.
    sl.registerLazySingleton(() => UserSession());
    sl.registerLazySingleton(() => AppTheme());
  }

  static void _configureNetworkModules() {
    sl.registerSingleton(Connectivity());
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  }

  static void _registerConnectors() {
    /// Passio Connector
    sl.registerLazySingleton<PassioConnector>(() => LocalDBConnector(databaseHelper: sl()));
  }

  static void _registerDataSource() {
    /// Food Record Data Sources
    sl.registerLazySingleton<FoodRecordLocalDataSource>(() => FoodRecordLocalDataSource(connector: sl()));

    /// User Data Sources
    sl.registerLazySingleton(() => UserLocalDataSource(connector: sl()));

    /// Favourite Data Sources
    sl.registerLazySingleton(() => FavoriteLocalDataSource(connector: sl()));
  }

  static void _registerRepositories() {
    sl.registerLazySingleton<FoodRepository>(() => FoodRepositoryImpl(networkInfo: sl(), localDataSource: sl()));
    sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(localDataSource: sl()));
    sl.registerLazySingleton<FavoriteRepository>(() => FavoriteRepositoryImpl(localDataSource: sl()));
  }

  static void _registerUseCases() {
    /// Dashboard Use Cases
    sl.registerLazySingleton(() => FetchDayRecordsUseCase(foodRepository: sl()));
    sl.registerLazySingleton(() => DeleteFoodRecordUseCase(foodRepository: sl()));
    sl.registerLazySingleton(() => UpdateFoodRecordUseCase(foodRepository: sl()));

    /// User Use Cases
    sl.registerLazySingleton(() => GetUserProfileUseCase(userRepository: sl()));
    sl.registerLazySingleton(() => UpdateUserProfileUseCase(userRepository: sl()));

    /// Favourite Use Cases
    sl.registerLazySingleton(() => FetchFavoritesUseCase(favoriteRepository: sl()));
    sl.registerLazySingleton(() => UpdateFavoriteUseCase(favoriteRepository: sl()));
    sl.registerLazySingleton(() => DeleteFavoriteUseCase(favoriteRepository: sl()));
  }

  static void _registerBlocProviders() {
    /// Splash Page Bloc
    sl.registerFactory(() => SplashBloc(updateUserProfileUseCase: sl(), getUserProfileUseCase: sl(), userSession: sl()));

    /// Sign-In Page Bloc
    sl.registerFactory(() => SignInBloc());

    /// Sign-Up Page Bloc
    sl.registerFactory(() => SignUpBloc());

    /// Quick Food Scan Page Bloc
     sl.registerFactory(() => QuickFoodScanBloc(updateFoodRecordUseCase: sl(), updateFavouriteUseCase: sl()));

    /// Multi Food Scan Page Bloc
    sl.registerFactory(() => MultiFoodScanBloc(updateFoodRecordUseCase: sl()));

    /// By Text Search Page Bloc
    sl.registerFactory(() => FoodSearchBloc());

    /// Dashboard Page Bloc
    sl.registerFactory(() => DashboardBloc(
          fetchFoodRecordsUseCase: sl(),
          deleteFoodRecordUseCase: sl(),
          updateFoodRecordUseCase: sl(),
          userSession: sl(),
          updateFavouriteUseCase: sl(),
        ));

    /// Edit Food Page Bloc
    sl.registerFactory(() => EditFoodBloc());

    /// Edit Food Item Page Bloc
    sl.registerFactory(() => EditFoodItemBloc());

    /// Profile Page Bloc
    sl.registerFactory(() => ProfileBloc(userSession: sl(), preferenceStore: sl(), updateUserProfileUseCase: sl()));

    /// Progress Page Bloc
    sl.registerFactory(() => ProgressBloc(userSession: sl(), fetchFoodRecordsUseCase: sl()));

    /// Favorite Page Bloc
    sl.registerFactory(() => FavouriteBloc(
          fetchFavouritesUseCase: sl(),
          updateFavoriteUseCase: sl(),
          deleteFavoriteUseCase: sl(),
          updateFoodRecordUseCase: sl(),
        ));
  }
}
