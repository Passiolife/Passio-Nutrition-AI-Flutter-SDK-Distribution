import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_ai_example/const/app_colors.dart';
import 'package:nutrition_ai_example/const/app_images.dart';
import 'package:nutrition_ai_example/const/dimens.dart';
import 'package:nutrition_ai_example/const/styles.dart';
import 'package:nutrition_ai_example/common/util/context_extension.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({this.searchController, this.onTapCancel, super.key});

  final TextEditingController? searchController;
  final VoidCallback? onTapCancel;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.searchBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: Dimens.h8),
      child: Row(
        children: [
          SizedBox(width: Dimens.w8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.searchFieldColor,
                borderRadius: BorderRadius.circular(Dimens.r8),
              ),
              child: TextFormField(
                controller: widget.searchController,
                textInputAction: TextInputAction.search,
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.w8),
                    child: SvgPicture.asset(
                      AppImages.icSearch,
                      width: Dimens.r18,
                      height: Dimens.r18,
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(maxWidth: Dimens.w40),
                  suffixIconConstraints: BoxConstraints(maxWidth: Dimens.w40),
                  suffixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.w8),
                    child: (widget.searchController?.text.isNotEmpty ?? false)
                        ? GestureDetector(
                            onTap: () {
                              widget.searchController?.clear();
                            },
                            child: SvgPicture.asset(
                              AppImages.icCancel,
                              width: Dimens.r18,
                              height: Dimens.r18,
                            ),
                          )
                        : const SizedBox(),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  hintText: context.localization?.searchFor ?? '',
                  hintStyle: AppStyles.style14
                      .copyWith(color: AppColors.searchHintColor),
                ),
              ),
            ),
          ),
          SizedBox(width: Dimens.w16),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onTapCancel,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.h8),
              child: Text(
                context.localization?.cancel ?? '',
                style: AppStyles.style18,
              ),
            ),
          ),
          SizedBox(width: Dimens.w8),
        ],
      ),
    );
  }
}
