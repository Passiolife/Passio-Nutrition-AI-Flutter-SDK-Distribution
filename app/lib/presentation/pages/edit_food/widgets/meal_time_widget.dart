import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/animated_tab_bar/segment_animation.dart' as segment_animation;
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/data/models/food_record/food_record.dart';

typedef OnUpdateMealTime = Function(MealLabel label);

class MealTimeWidget extends StatelessWidget {
  const MealTimeWidget({this.onUpdateMealTime, this.selectedMealLabel, super.key});
  final OnUpdateMealTime? onUpdateMealTime;
  final MealLabel? selectedMealLabel;

  // []
  List<MealLabel> get mealLabels => MealLabel.values;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: Dimens.w4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.r26)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          segment_animation.AnimatedSegment(
            initialSegment: mealLabels.firstWhere((element) => element.value==selectedMealLabel?.value, orElse: () => mealLabels.first).index,
            segmentNames: mealLabels.map((e) => e.value).toList(),
            onSegmentChanged: (index) {
              onUpdateMealTime?.call(mealLabels.elementAt(index));
            },
            backgroundColor: AppColors.whiteColor,
            segmentTextColor: AppColors.bgColor,
            rippleEffectColor: AppColors.bgColor,
            selectedSegmentColor: AppColors.buttonColor,
          ),
        ],
      ),
    );
  }
}
