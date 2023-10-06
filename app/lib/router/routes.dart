import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_constants.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/dashboard/dashboard_page.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food/edit_food_page.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/edit_food_ingredient/edit_food_item_page.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/favourite/favourite_page.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/food_search/food_search_page.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/multi_food_scan/multi_food_scan_page.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/profile/profile_page.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/progress/progress_page.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/quick_food_scan/quick_food_scan_page.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/sign_in/sign_in_page.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/sign_up/sign_up_page.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/splash/splash_page.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/welcome/welcome_page.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

/// set this key to [MaterialApp]'s [navigatorKey].
/// If you are using [GoRouter] then set to it's constructor.
/// so we will get the context from [navigatorKey] and perform the route operations.
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Routes {
  /// [initialRoute] to display the page on app start.
  static String initialRoute = splashPage;

  /// Auth Screens
  static const splashPage = '/splashPage';
  static const welcomePage = '/';
  static const signInPage = '/signInPage';
  static const signUpPage = '/signUpPage';

  /// Dashboard screens
  static const dashboardPage = '/dashboardPage';
  static const quickFoodScanPage = '/quickFoodScanPage';
  static const multiFoodScanPage = '/multiFoodScanPage';
  static const foodSearchPage = '/foodSearchPage';
  static const editFoodPage = '/editFoodPage';
  static const editFoodItemPage = '/editFoodItemPage';
  static const profilePage = '/profilePage';
  static const progressPage = '/progressPage';
  static const favouritesPage = '/favouritesPage';

  static GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: initialRoute,
    routes: <GoRoute>[
      GoRoute(
        path: splashPage,
        name: splashPage,
        builder: (context, state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: welcomePage,
        name: welcomePage,
        builder: (context, state) {
          return const WelcomePage();
        },
      ),
      GoRoute(
        path: signInPage,
        name: signInPage,
        builder: (context, state) {
          return const SignInPage();
        },
      ),
      GoRoute(
        path: signUpPage,
        name: signUpPage,
        builder: (context, state) {
          return const SignUpPage();
        },
      ),
      GoRoute(
        path: dashboardPage,
        name: dashboardPage,
        builder: (context, state) {
          return const DashboardPage();
        },
      ),

      /// [quickFoodScanPage] route.
      GoRoute(
        path: quickFoodScanPage,
        name: quickFoodScanPage,
        builder: (context, state) {
          DateTime dateTime = _getExtra<DateTime?>(state.extra, AppConstants.dateTime, null) ?? DateTime.now();
          return QuickFoodScanPage(selectedDateTime: dateTime);
        },
      ),

      /// [MultiFoodScanPage] route.
      GoRoute(
        path: multiFoodScanPage,
        name: multiFoodScanPage,
        builder: (context, state) {
          DateTime dateTime = _getExtra<DateTime?>(state.extra, AppConstants.dateTime, null) ?? DateTime.now();
          return MultiFoodScanPage(selectedDateTime: dateTime);
        },
      ),

      /// [MultiFoodScanPage] route.
      GoRoute(
        path: foodSearchPage,
        name: foodSearchPage,
        builder: (context, state) {
          return const FoodSearchPage();
        },
      ),

      /// [EditFoodPage] route.
      GoRoute(
        path: editFoodPage,
        name: editFoodPage,
        builder: (context, state) {
          int index = _getExtra<int>(state.extra, AppConstants.index, 0);
          FoodRecord? data = _getExtra<FoodRecord?>(state.extra, AppConstants.data, null);
          bool visibleFavouriteButton = _getExtra<bool>(state.extra, AppConstants.visibleFavouriteButton, true);

          if (state.extra is FoodRecord?) {
            data = state.extra as FoodRecord?;
          }
          return EditFoodPage(
            foodRecord: data,
            index: index,
            visibleFavouriteButton: visibleFavouriteButton,
          );
        },
      ),

      GoRoute(
        path: editFoodItemPage,
        name: editFoodItemPage,
        builder: (context, state) {
          int index = _getExtra<int>(state.extra, AppConstants.index, 0);
          PassioFoodItemData? data = _getExtra<PassioFoodItemData?>(state.extra, AppConstants.data, null);
          if (state.extra is PassioFoodItemData?) {
            data = state.extra as PassioFoodItemData?;
          }
          return EditFoodItemPage(
            foodItemData: data,
            index: index,
          );
        },
      ),

      // Route for Profile Page
      GoRoute(
        path: profilePage,
        name: profilePage,
        builder: (context, state) {
          return const ProfilePage();
        },
      ),

      // Route for Profile Page
      GoRoute(
        path: progressPage,
        name: progressPage,
        builder: (context, state) {
          return const ProgressPage();
        },
      ),

      // Route for Favourites Page
      GoRoute(
        path: favouritesPage,
        name: favouritesPage,
        builder: (context, state) {
          return const FavouritePage();
        },
      ),
    ],
  );

  static T _getExtra<T>(Object? params, String key, T defaultValue) {
    if (params is Map) {
      return (((params.containsKey(key)) ? params[key] : defaultValue) as T);
    }
    return params as T;
  }
}
