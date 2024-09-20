import 'package:flutter/material.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/common/passio_image_widget.dart';
import 'package:nutrition_ai_example/const/styles.dart';

typedef OnTapItem = Function(PassioAdvisorFoodInfo? data);

class FoodSearchItemRow extends StatefulWidget {
  const FoodSearchItemRow({
    this.data,
    this.onTapItem,
    super.key,
  });

  final PassioAdvisorFoodInfo? data;

  final OnTapItem? onTapItem;

  @override
  State<FoodSearchItemRow> createState() => _FoodSearchItemRowState();
}

class _FoodSearchItemRowState extends State<FoodSearchItemRow> {

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
              PassioImageWidget(
                key: ValueKey(widget.data?.foodDataInfo?.iconID),
                iconId: widget.data?.foodDataInfo?.iconID ?? '',
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(widget.data?.foodDataInfo?.foodName ?? '',
                    style: AppStyles.style18.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
