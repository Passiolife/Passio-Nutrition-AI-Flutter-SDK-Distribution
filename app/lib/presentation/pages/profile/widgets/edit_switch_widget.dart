import 'package:flutter/cupertino.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/styles.dart';

typedef OnChangeSegment = void Function(String? value);

class EditSwitchWidget extends StatelessWidget {
  const EditSwitchWidget({
    required this.items,
    this.title,
    this.selected,
    this.onChangeSegment,
    super.key,
  });

  final String? title;
  final List<String?> items;
  final String? selected;
  final OnChangeSegment? onChangeSegment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.w16, vertical: Dimens.h12),
          child: Text(
            title ?? '',
            style: AppStyles.style17,
          ),
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.w16, vertical: Dimens.h8),
          child: CupertinoSlidingSegmentedControl<String>(
            // This represents the currently selected segmented control.
            groupValue: selected,
            backgroundColor: AppColors.passioInset,
            thumbColor: AppColors.customBase,
            children: Map.fromIterable(
              items,
              key: (v) => (v as String?)?.toLowerCase() ?? '',
              value: (v) => Text(
                v,
                style: AppStyles.style12.copyWith(color: selected?.toLowerCase() == (v as String?)?.toLowerCase() ? AppColors.passioInset : AppColors.blackColor),
              ),
            ),
            onValueChanged: (value) => onChangeSegment?.call(value),
          ),
        ),
      ],
    );
  }
}
