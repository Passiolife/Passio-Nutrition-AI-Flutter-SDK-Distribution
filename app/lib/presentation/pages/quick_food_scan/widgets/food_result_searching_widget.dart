import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/dimens.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';

class FoodResultSearchingWidget extends StatelessWidget {
  const FoodResultSearchingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.r16)),
      child: Container(
        height: Dimens.h100,
        padding: EdgeInsets.only(top: Dimens.h16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: Dimens.w16),
                const CupertinoActivityIndicator(radius: 18),
                SizedBox(width: Dimens.w16),
                Text(context.localization?.scanningForFood ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
