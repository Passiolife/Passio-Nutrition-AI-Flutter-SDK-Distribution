import 'package:flutter/material.dart';
import '../models/platform_image.dart';

class PassioIcon extends StatelessWidget {
  final PlatformImage? image;

  const PassioIcon({this.image, super.key});

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return CircleAvatar(
        radius: 30,
        backgroundImage: MemoryImage(image!.pixels),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}
