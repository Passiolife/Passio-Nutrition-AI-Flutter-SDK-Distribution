import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/string_extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

typedef OnTapAlternative = Function(PassioAlternative? alternative);

class VisualAlternativeWidget extends StatelessWidget {
  const VisualAlternativeWidget({required this.alternatives, this.onTapAlternative, super.key});

  final List<PassioAlternative?> alternatives;
  final OnTapAlternative? onTapAlternative;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: Dimens.w4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Dimens.h8.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.r8),
              child: Text(context.localization?.visualAlternatives ?? ''),
            ),
            Dimens.h8.verticalSpace,
            SizedBox(
              height: Dimens.h56,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(Dimens.r8),
                shrinkWrap: true,
                itemCount: alternatives.length,
                itemBuilder: (context, index) {
                  final data = alternatives.elementAt(index);
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => onTapAlternative?.call(data),
                    child: Theme(
                      data: Theme.of(context).copyWith(canvasColor: AppColors.passioLowContrast),
                      child: Chip(
                        label: Text(
                          (data?.name ?? "").toCapitalized() ?? "",
                          maxLines: 1,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Dimens.w8.horizontalSpace;
                },
              ),
            ),
            Dimens.h8.verticalSpace,
          ],
        ),
      ),
    );
  }
}
