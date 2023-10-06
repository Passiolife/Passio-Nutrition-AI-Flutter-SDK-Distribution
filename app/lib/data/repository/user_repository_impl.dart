import 'package:flutter_nutrition_ai_demo/data/datasources/user/user_local_data_source.dart';
import 'package:flutter_nutrition_ai_demo/data/models/api_error.dart';
import 'package:flutter_nutrition_ai_demo/data/models/user_profile/user_profile_model.dart';
import 'package:flutter_nutrition_ai_demo/domain/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({required this.localDataSource});

  @override
  Future<({APIError? error, UserProfileModel? response})> getUserProfile(String? id) async {
    try {
      final response = await localDataSource.getUserProfile(id);
      return (response: response, error: null);
    } on Exception catch (e) {
      return (response: null, error: APIError(message: e.toString()));
    }
  }

  @override
  Future<({APIError? error, void response})> updateUserProfile(UserProfileModel userProfile, bool isNew) async {
    try {
      await localDataSource.updateUserProfile(userProfile, isNew);
      return (response: null, error: null);
    } on Exception catch (e) {
      return (response: null, error: APIError(message: e.toString()));
    }
  }
}
