import 'package:flutter_nutrition_ai_demo/data/datasources/user/user_data_source.dart';
import 'package:flutter_nutrition_ai_demo/data/models/user_profile/user_profile_model.dart';
import 'package:flutter_nutrition_ai_demo/passio_connector.dart';

class UserLocalDataSource extends UserDataSource {
  final PassioConnector connector;

  UserLocalDataSource({required this.connector});

  @override
  Future<UserProfileModel?> getUserProfile(String? id) async {
    return await connector.fetchUserProfile();
  }

  @override
  Future<void> updateUserProfile(UserProfileModel userProfile, bool isNew) async {
    return connector.updateUserProfile(userProfile, isNew);
  }
}
