import 'dart:convert';

import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/data/models/user_profile/user_profile_model.dart';
import 'package:flutter_nutrition_ai_demo/passio_connector.dart';
import 'package:flutter_nutrition_ai_demo/util/database_helper.dart';
import 'package:flutter_nutrition_ai_demo/util/date_time_utility.dart';

class LocalDBConnector extends PassioConnector {
  final DatabaseHelper databaseHelper;

  LocalDBConnector({required this.databaseHelper});

  @override
  Future<void> updateRecord(FoodRecord foodRecord, bool isNew) async {
    // If [isNew] is [true] then perform the insert operation.
    if (isNew) {
      String createdAt = DateTime.fromMillisecondsSinceEpoch(foodRecord.createdAt?.toInt() ?? 0).format(format9);

      final values = {databaseHelper.colCreatedAt: createdAt, databaseHelper.colData: jsonEncode(foodRecord)};
      final insertId = await databaseHelper.database.insert(databaseHelper.tblFoodRecord, values);
      if (insertId > 0) {
        foodRecord.id = insertId.toString();
      }
    } else {
      final row = {databaseHelper.colData: jsonEncode(foodRecord)};
      await databaseHelper.database.update(databaseHelper.tblFoodRecord, row, where: '${databaseHelper.colId} = ?', whereArgs: [foodRecord.id]);
    }
  }

  @override
  Future<List<FoodRecord>?> fetchDayRecords(DateTime dateTime) async {
    final date = dateTime.format(format9);
    List<Map>? data = await databaseHelper.database.query(
      databaseHelper.tblFoodRecord,
      where: '${databaseHelper.colCreatedAt} = ?',
      whereArgs: [date],
      orderBy: '${databaseHelper.colId} DESC',
    );
    return data.map((e) {
      final foodRecordResponse = FoodRecord.fromJson(jsonDecode(e[databaseHelper.colData]));
      foodRecordResponse.id = e[databaseHelper.colId].toString();
      return foodRecordResponse;
    }).toList();
  }

  @override
  Future<void> deleteRecord(FoodRecord foodRecord) async {
    await databaseHelper.database.delete(databaseHelper.tblFoodRecord, where: '${databaseHelper.colId} = ?', whereArgs: [foodRecord.id]);
  }

  @override
  Future<void> updateFavorite(FoodRecord foodRecord, bool isNew) async {
    if(isNew) {
      String createdAt = DateTime.fromMillisecondsSinceEpoch(foodRecord.createdAt?.toInt() ?? 0).format(format9);

      final values = {databaseHelper.colCreatedAt: createdAt, databaseHelper.colData: jsonEncode(foodRecord)};
      final insertId = await databaseHelper.database.insert(databaseHelper.tblFavorite, values);
      if(insertId > 0) {
        foodRecord.id = insertId.toString();
      }
    } else {
      final row = {databaseHelper.colData: jsonEncode(foodRecord)};
      await databaseHelper.database.update(databaseHelper.tblFavorite, row, where: '${databaseHelper.colId} = ?', whereArgs: [foodRecord.id]);
    }

  }

  @override
  Future<List<FoodRecord>?> fetchFavorites() async {
    List<Map?>? data = await databaseHelper.database.query(databaseHelper.tblFavorite, orderBy: '${databaseHelper.colId} DESC');
    return data.map((e) {
      final foodRecordResponse = FoodRecord.fromJson(jsonDecode(e?[databaseHelper.colData]));
      foodRecordResponse.id = e?[databaseHelper.colId].toString();
      return foodRecordResponse;
    }).toList();
  }

  @override
  Future<void> deleteFavorite(FoodRecord foodRecord) async {
    await databaseHelper.database.delete(databaseHelper.tblFavorite, where: '${databaseHelper.colId} = ?', whereArgs: [foodRecord.id]);
  }

  @override
  Future<void> updateUserProfile(UserProfileModel userProfile, bool isNew) async {
    final values = {databaseHelper.colData: jsonEncode(userProfile)};
    if (isNew) {
      final insertId = await databaseHelper.database.insert(databaseHelper.tblUserProfile, values);
      if (insertId > 0) {
        userProfile.id = insertId.toString();
      }
    } else {
      await databaseHelper.database.update(databaseHelper.tblUserProfile, values, where: '${databaseHelper.colId} = ?', whereArgs: [userProfile.id]);
    }
  }

  @override
  Future<UserProfileModel?> fetchUserProfile() async {
    Map? data = (await databaseHelper.database.query(databaseHelper.tblUserProfile, limit: 1)).firstOrNull;
    if (data?.containsKey(databaseHelper.colData) ?? false) {
      return UserProfileModel.fromJson(jsonDecode(data?[databaseHelper.colData]));
    }
    return null;
  }
}
