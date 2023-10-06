import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/styles.dart';
import 'package:flutter_nutrition_ai_demo/data/models/user_profile/user_profile_model.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnTapDailyMacro = VoidCallback;

class EditMacrosWidget extends StatelessWidget {
  const EditMacrosWidget({this.onTapDailyMacro, this.userProfileModel, super.key});
  final OnTapDailyMacro? onTapDailyMacro;
  final UserProfileModel? userProfileModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTapDailyMacro,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.w20),
            child: Text(
              context.localization?.dailyMacroTarget ?? '',
              style: AppStyles.style17,
            ),
          ),
          Dimens.h8.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      context.localization?.carbs ?? '',
                      style: AppStyles.style17,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${userProfileModel?.carbsPercent ?? ''}%',
                          style: AppStyles.style17,
                        ),
                        Dimens.w2.horizontalSpace,
                        Flexible(
                          child: Text(
                            '(${userProfileModel?.carbsGrams}g)',
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.style16.copyWith(color: AppColors.darkGreyColor),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      context.localization?.protein ?? '',
                      style: AppStyles.style17,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${userProfileModel?.proteinPercent ?? ''}%',
                          style: AppStyles.style17,
                        ),
                        Dimens.w2.horizontalSpace,
                        Flexible(
                          child: Text(
                            '(${userProfileModel?.proteinGrams ?? ''}g)',
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.style16.copyWith(color: AppColors.darkGreyColor),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      context.localization?.fat ?? '',
                      style: AppStyles.style17,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${userProfileModel?.fatPercent ?? ''}%',
                          style: AppStyles.style17,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Dimens.w2.horizontalSpace,
                        Flexible(
                          child: Text(
                            '(${userProfileModel?.fatGrams ?? ''}g)',
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.style16.copyWith(color: AppColors.darkGreyColor),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
