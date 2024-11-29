import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/const/app_constants.dart';
import 'package:nutrition_ai_example/const/app_images.dart';
import 'package:nutrition_ai_example/const/dimens.dart';
import 'package:nutrition_ai_example/const/styles.dart';

typedef OnTapItem = Function(PassioFoodDataInfo? data);

class FoodSearchItemRow extends StatefulWidget {
  const FoodSearchItemRow({
    this.data,
    this.foodItemsImages,
    this.onTapItem,
    super.key,
  });

  final PassioFoodDataInfo? data;

  final Map<String?, PlatformImage?>? foodItemsImages;

  final OnTapItem? onTapItem;

  @override
  State<FoodSearchItemRow> createState() => _FoodSearchItemRowState();
}

class _FoodSearchItemRowState extends State<FoodSearchItemRow> {
  final ValueNotifier<PlatformImage?> _image = ValueNotifier(null);

  @override
  void initState() {
    _getFoodIcon();
    super.initState();
  }

  @override
  void dispose() {
    _image.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.onTapItem?.call(widget.data),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              if (widget.data?.iconID.contains(AppConstants.removeIcon) ??
                  false)
                SizedBox(
                  width: Dimens.r52,
                  height: Dimens.r52,
                )
              else if (widget.data?.iconID.contains(AppConstants.searching) ??
                  false)
                SizedBox(
                  width: Dimens.r52,
                  height: Dimens.r52,
                  child: Center(
                    child: CupertinoActivityIndicator(
                      radius: Dimens.r16,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                )
              else
                ValueListenableBuilder(
                  valueListenable: _image,
                  builder: (context, value, child) {
                    return AnimatedSwitcher(
                      key: ValueKey<PlatformImage?>(_image.value),
                      duration: const Duration(milliseconds: 500),
                      child: (value?.pixels != null)
                          ? PassioIcon(image: _image.value)
                          : SizedBox(
                              width: Dimens.r52,
                              height: Dimens.r52,
                            ),
                    );
                  },
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(widget.data?.foodName ?? '',
                    style: AppStyles.style18.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
              ),
              Visibility(
                visible: !(widget.data?.iconID.contains("removeIcon") ?? false),
                child: SvgPicture.asset(
                  AppImages.icPlusCircle,
                  width: Dimens.r26,
                  height: Dimens.r26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getFoodIcon() async {
    /// Here, checking value of [passioID], if it is [AppConstants.removeIcon] OR [AppConstants.searching] then do nothing.
    /// else fetch the image using [passioID].
    if (widget.data?.iconID != AppConstants.removeIcon &&
        widget.data?.iconID != AppConstants.searching &&
        !(widget.foodItemsImages?.containsKey(widget.data?.iconID) ?? false)) {
      /// Here, wait for the
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        PassioID passioID = widget.data?.iconID ?? '';
        PassioFoodIcons passioIcons =
            await NutritionAI.instance.lookupIconsFor(passioID);

        if (passioIcons.cachedIcon != null) {
          _setImage(passioIcons.cachedIcon);
          widget.foodItemsImages
              ?.putIfAbsent(widget.data?.iconID ?? '', () => _image.value);
          return;
        }

        _setImage(passioIcons.defaultIcon);
        var remoteIcon = await NutritionAI.instance.fetchIconFor(passioID);
        if (remoteIcon != null) {
          _setImage(remoteIcon);
        }

        /// Storing image into the map, so while scrolling it doesn't calls the API call again.
        widget.foodItemsImages
            ?.putIfAbsent(widget.data?.iconID ?? '', () => _image.value);
      });
    } else {
      /// Fetching stored image using passioID.
      _setImage(widget.foodItemsImages?[widget.data?.iconID]);
    }
  }

  void _setImage(PlatformImage? image) {
    if (mounted) {
      _image.value = image;
    }
  }
}
