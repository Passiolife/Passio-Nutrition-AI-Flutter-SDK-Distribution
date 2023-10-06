import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/adaptive_action_button_widget.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';
import 'package:flutter_nutrition_ai_demo/util/string_extensions.dart';
import 'package:go_router/go_router.dart';

typedef OnRenameFood = Function(String text);

class RenameFoodDialogs {
  RenameFoodDialogs.show({required BuildContext context, String? title, required String text, String? placeHolder, OnRenameFood? onRenameFood}) {
    TextEditingController controller = TextEditingController(text: text);
    showAdaptiveDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog.adaptive(
        title: Text(title ?? ''),
        content: CupertinoTextField(
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          controller: controller,
          clearButtonMode: OverlayVisibilityMode.editing,
          placeholder: placeHolder,
        ),
        actions: <Widget>[
          adaptiveAction(
            context: context,
            onPressed: () => context.pop(),
            child: Text(context.localization?.cancel.toUpperCaseWord ?? ''),
          ),
          adaptiveAction(
            context: context,
            onPressed: () {
              String foodName;
              if (controller.text.isNotEmpty) {
                foodName = controller.text;
              } else {
                foodName = text;
              }
              if ((placeHolder?.isNotEmpty ?? false) && foodName.isEmpty) {
                foodName = placeHolder ?? '';
              }
              context.pop();
              onRenameFood?.call(foodName);
            },
            child: Text(context.localization?.save.toUpperCaseWord ?? ''),
          ),
        ],
      ),
    );
  }
}
