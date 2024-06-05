import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_ai_example/common/util/context_extension.dart';

import '../constant/app_constants.dart';

typedef MenuCallback = Function(OverlayPortalController menuController);

// Define a custom callback type for menu item tap
typedef OnMenuItemTap = Function(String? item);

// Custom AppBar widget
class CustomAppBarWidget extends StatefulWidget {
  const CustomAppBarWidget({
    this.onTapBack,
    this.title,
    this.titleStyle,
    this.isMenuVisible = true,
    this.suffix,
    this.children = const [],
    super.key,
  });

  // Callback for back button tap
  final VoidCallback? onTapBack;

  // Title of the app bar
  final String? title;

  final TextStyle? titleStyle;

  // Boolean to determine menu visibility
  final bool isMenuVisible;

  final Widget? suffix;

  final List<Widget> children;

  @override
  State<CustomAppBarWidget> createState() => CustomAppBarWidgetState();
}

class CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      decoration: AppShadows.base,
      padding: EdgeInsets.only(
        left: 8.w,
        right: 8.w,
        top: 48.h,
        bottom: 8.h,
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  (widget.onTapBack != null)
                      ? widget.onTapBack?.call()
                      : Navigator.canPop(context)
                          ? Navigator.pop(context)
                          : null;
                },
                icon: SvgPicture.asset(
                  AppImages.icChevronLeft,
                  width: 24.r,
                  height: 24.r,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Center(
                    child: Text(
                      widget.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: widget.titleStyle ??
                          AppTextStyle.text2xl.addAll([
                            AppTextStyle.text2xl.leading8,
                            AppTextStyle.extraBold
                          ]).copyWith(color: AppColors.gray900),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 24.r,
                height: 24.r,
              ),
            ],
          ),
          ...widget.children,
          // widget.child ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
