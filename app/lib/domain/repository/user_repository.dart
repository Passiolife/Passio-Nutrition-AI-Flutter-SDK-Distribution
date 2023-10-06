import 'package:flutter_nutrition_ai_demo/data/models/api_error.dart';
import 'package:flutter_nutrition_ai_demo/data/models/user_profile/user_profile_model.dart';

abstract class UserRepository {
  Future<({UserProfileModel? response, APIError? error})> getUserProfile(String? id);
  Future<({void response, APIError? error})> updateUserProfile(UserProfileModel userProfile, bool isNew);
}
