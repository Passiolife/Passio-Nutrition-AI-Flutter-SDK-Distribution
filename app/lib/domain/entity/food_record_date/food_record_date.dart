import 'package:json_annotation/json_annotation.dart';

part 'food_record_date.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FoodRecordDate {
  final int? id;
  final String? date;

  FoodRecordDate(this.id, this.date);

  factory FoodRecordDate.fromJson(Map<String, dynamic> json) => _$FoodRecordDateFromJson(json);

  Map<String, dynamic> toJson() => _$FoodRecordDateToJson(this);

  FoodRecordDate copyWith({int? id, String? date}) => FoodRecordDate(id ?? this.id, date ?? this.date);
}
