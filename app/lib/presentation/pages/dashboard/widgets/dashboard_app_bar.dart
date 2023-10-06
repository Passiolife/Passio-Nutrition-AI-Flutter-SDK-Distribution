import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_colors.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/styles.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/app_button.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/date_time_utility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

typedef OnDateChange = Function(DateTime dateTime);

class DashboardAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DashboardAppBar({required this.selectedDateTime, this.onDateChange, this.onTapMore, super.key});

  /// [onTapMore] will executes when gesture detector calls.
  final OnDateChange? onDateChange;

  /// [onTapMore] will executes when gesture detector calls.
  final VoidCallback? onTapMore;

  final DateTime selectedDateTime;

  @override
  State<DashboardAppBar> createState() => _DashboardAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  late DateTime _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.selectedDateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: GestureDetector(
        onTap: () => _showDatePicker(context),
        child: Text(
          _selectedDate.format(format8),
          style: AppStyles.style17,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: widget.onTapMore,
          behavior: HitTestBehavior.translucent,
          child: Text(
            context.localization?.more ?? '',
            style: AppStyles.style17,
          ),
        ),
        Dimens.w8.horizontalSpace,
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    if (Platform.isIOS) {
      /// Display a CupertinoDatePicker in date picker mode.
      context.showCupertinoPopup(
        height: context.height,
        child: Container(
          color: AppColors.passioLowContrast,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: Dimens.h214,
                child: CupertinoDatePicker(
                  initialDateTime: _selectedDate,
                  mode: CupertinoDatePickerMode.date,
                  // This shows day of week alongside day of month
                  showDayOfWeek: true,
                  dateOrder: DatePickerDateOrder.dmy,
                  maximumDate: DateTime.now(),
                  // This is called when the user changes the date.
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() => _selectedDate = newDate);
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimens.w8),
                      child: AppButton(
                        buttonName: context.localization?.today ?? '',
                        onTap: () {
                          context.pop();
                          setState(() {
                            _selectedDate = DateTime.now();
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimens.w8),
                      child: AppButton(
                        buttonName: context.localization?.ok ?? '',
                        onTap: () {
                          context.pop();
                          widget.onDateChange?.call(_selectedDate);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimens.h8),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    } else {
      DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2018),
        lastDate: DateTime.now(),
      );
      if (newDate != null) {
        setState(() => _selectedDate = newDate);
        widget.onDateChange?.call(_selectedDate);
      }
    }
  }
}
