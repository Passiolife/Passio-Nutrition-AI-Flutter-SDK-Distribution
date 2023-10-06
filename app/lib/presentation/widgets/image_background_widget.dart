import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/common/constant/app_images.dart';
import 'package:flutter_nutrition_ai_demo/util/context_extension.dart';

class ImageBackgroundWidget extends StatelessWidget {
  final Widget? child;

  const ImageBackgroundWidget({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height,
      width: context.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.launchBackgroundImage),
          opacity: 1,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
        ),
      ),
      child: child,
    );
  }
}
