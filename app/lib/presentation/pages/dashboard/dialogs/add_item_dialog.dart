import 'package:flutter/cupertino.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';

typedef OnTapItem = Function(String? item);

class AddItemDialog {
  AddItemDialog.show({
    required BuildContext context,
    OnTapItem? onTapItem,
  }) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(context.localization?.addItem ?? ''),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => onTapItem?.call(context.localization?.quickFoodScan),
            child: Text(
              context.localization?.quickFoodScan ?? '',
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () => onTapItem?.call(context.localization?.multiFoodScan),
            child: Text(
              context.localization?.multiFoodScan ?? '',
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () => onTapItem?.call(context.localization?.byTextSearch),
            child: Text(
              context.localization?.byTextSearch ?? '',
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () => onTapItem?.call(context.localization?.fromFavorites),
            child: Text(
              context.localization?.fromFavorites ?? '',
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => onTapItem?.call(context.localization?.cancel),
            child: Text(
              context.localization?.cancel ?? '',
            ),
          ),
        ],
      ),
    );
  }
}
