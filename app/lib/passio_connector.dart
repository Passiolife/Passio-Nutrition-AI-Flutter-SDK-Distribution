import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/data/models/user_profile/user_profile_model.dart';

abstract class PassioConnector {
  // UserProfile
  Future<void> updateUserProfile(UserProfileModel userProfile, bool isNew);
  Future<UserProfileModel?> fetchUserProfile();
  // Records
  Future<void> updateRecord(FoodRecord foodRecord, bool isNew);
  Future<void> deleteRecord(FoodRecord foodRecord);
  Future<List<FoodRecord>?> fetchDayRecords(DateTime dateTime);
  // Favorites
  Future<void> updateFavorite(FoodRecord foodRecord, bool isNew);
  Future<void> deleteFavorite(FoodRecord foodRecord);
  Future<List<FoodRecord>?> fetchFavorites();
}