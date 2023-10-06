import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/dashboard/widgets/food_record_list_row.dart';
import 'package:flutter_nutrition_ai_demo/presentation/pages/dashboard/widgets/no_data_widget.dart';

class TabLunchWidget extends StatefulWidget {
  final List<FoodRecord?> data;
  final OnDeleteItem? onDeleteItem;
  final OnEditItem? onEditItem;

  const TabLunchWidget({required this.data, this.onDeleteItem, this.onEditItem, super.key});

  @override
  State<TabLunchWidget> createState() => _TabLunchWidgetState();
}

class _TabLunchWidgetState extends State<TabLunchWidget> {
  final List<FoodRecord?> _foodRecordsList = [];

  @override
  void initState() {
    _foodRecordsList
      ..addAll(widget.data)
      ..removeWhere((element) => element?.mealLabel?.value != MealLabel.lunch.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _foodRecordsList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _foodRecordsList.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final data = _foodRecordsList.elementAt(index);
              return FoodRecordListRow(
                key: ObjectKey(data?.passioID),
                data: data,
                onDeleteItem: widget.onDeleteItem,
                onEditItem: widget.onEditItem,
                index: index,
              );
            },
          )
        : const NoFoodRecordsWidget();
  }
}
