import 'package:flutter_nutrition_ai_demo/data/models/user_profile/user_profile_model.dart';

abstract class UserDataSource {
  Future<UserProfileModel?> getUserProfile(String? id);
  Future<void> updateUserProfile(UserProfileModel userProfile, bool isNew);
}
