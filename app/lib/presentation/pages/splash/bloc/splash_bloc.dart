import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nutrition_ai_demo/data/models/user_profile/user_profile_model.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/user/get_user_profile_use_case.dart';
import 'package:flutter_nutrition_ai_demo/domain/use_cases/user/update_user_profile_use_case.dart';
import 'package:flutter_nutrition_ai_demo/util/user_session.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final UserSession userSession;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final GetUserProfileUseCase getUserProfileUseCase;

  SplashBloc({required this.userSession, required this.updateUserProfileUseCase, required this.getUserProfileUseCase}) : super(SplashInitial()) {
    on<DoConfigureSdkEvent>(_handleDoConfigureSdk);
  }

  Future _handleDoConfigureSdk(DoConfigureSdkEvent event, Emitter<SplashState> emit) async {
    emit(ConfigureLoadingState(isLoading: true));

    try {
      /// Here, we are checking the platform version.
      final platformVersion = await NutritionAI.instance.getSDKVersion();
      if (platformVersion == null || platformVersion.isEmpty) {
        /// If unknown platform then fire failure state.
        emit(ConfigureFailureState(message: 'Unknown platform version'));
      }
    } on PlatformException {
      /// If any [PlatformException] then fire failure state.
      emit(ConfigureFailureState(message: 'Failed to get platform version.'));
    }

    String passioKey = /* enter key here*/;
    var configuration = PassioConfiguration(passioKey);

    /// [configureSDK] method is use to initialize the SDK.
    final passioStatus = await NutritionAI.instance.configureSDK(configuration);

    /// Here, we are checking if sdk is ready for detection.
    if (passioStatus.mode == PassioMode.isReadyForDetection) {
      // Getting user profile from database.
      final result = await getUserProfileUseCase((id: null));

      // Checking is there any error while getting profile data from database.
      if (result.error != null) {
        // If is there any error then set default [UserProfileModel] to the user session.
        userSession.userProfile = UserProfileModel();
      } else {
        // No any error while getting profile from database.
        // Checking response is null
        if (result.response == null) {
          // Then assigning default  [UserProfileModel] to the user session.
          userSession.userProfile = UserProfileModel();
          if (userSession.userProfile != null) {
            // Storing user profile data in database.
            await updateUserProfileUseCase((userProfile: userSession.userProfile!, isNew: true));
          }
        } else {
          // Updating user profile data from database.
          userSession.userProfile = result.response;
        }
      }
      emit(ConfigureSuccessState());
    }
  }
}
