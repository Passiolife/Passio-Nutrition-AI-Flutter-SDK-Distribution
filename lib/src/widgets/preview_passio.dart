import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget that is used to display the camera preview and the frames being
/// processed by the NutritionAI SDK.
class PassioPreview extends StatelessWidget {
  const PassioPreview({super.key});

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    TargetPlatform platform = defaultTargetPlatform;

    return Center(
      child: _getBodyContent(platform, context),
    );
  }

  Widget _getBodyContent(TargetPlatform platform, BuildContext context) {
    switch (platform) {
      case TargetPlatform.android:
        return _createAndroidPreview();
      case TargetPlatform.iOS:
        return _createiOSPreview(context);
      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }

  Widget _createAndroidPreview() {
    const String viewType = 'native-preview-view';
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  Widget _createiOSPreview(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'PassioPreviewViewType';
    // Pass parameters to the platform side.
    //final Map<String, dynamic> creationParams = <String, dynamic>{};

    double viewWidth = MediaQuery.of(context).size.width;
    double viewHeight = MediaQuery.of(context).size.height;

    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: {
        'width': viewWidth,
        'height': viewHeight,
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
