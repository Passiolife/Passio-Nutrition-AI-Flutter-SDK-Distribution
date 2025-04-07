import 'package:flutter/material.dart';
import 'package:nutrition_ai_example/common/widgets/camera_widget.dart';

class ThirdPartyCameraPage extends StatelessWidget {
  const ThirdPartyCameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CameraWidget(),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, "Data");
              },
              child: Text('Take Photo'),
            ),
          )
        ],
      ),
    );
  }
}
