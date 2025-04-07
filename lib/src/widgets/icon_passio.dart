import 'package:flutter/material.dart';

import '../models/platform_image.dart';

class PassioIcon extends StatelessWidget {
  final PlatformImage? image;
  final double? size;

  const PassioIcon({
    this.image,
    this.size = 30,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return CircleAvatar(
        radius: size,
        backgroundImage: MemoryImage(image!.pixels),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}
