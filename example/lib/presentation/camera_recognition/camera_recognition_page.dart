import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/inject/injector.dart';
import 'package:nutrition_ai_example/presentation/camera_recognition/bloc/camera_recognition_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraRecognitionPage extends StatefulWidget {
  const CameraRecognitionPage({super.key});

  @override
  State<StatefulWidget> createState() => _CameraRecognitionPageState();
}

class _CameraRecognitionPageState extends State<CameraRecognitionPage>
    implements FoodRecognitionListener {
  final _bloc = sl<CameraRecognitionBloc>();

  String? _foodName;
  PlatformImage? _image;
  final ValueNotifier<bool> _flashlightEnabled = ValueNotifier(false);
  final ValueNotifier<double> _zoomLevel = ValueNotifier(1);
  PassioCameraZoomLevel? _cameraZoomLevel;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CameraRecognitionBloc, CameraRecognitionState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is SearchingState) {
          _onSearchingState(state);
        } else if (state is UpdateFoodNameState) {
          _onUpdateFoodNameState(state);
        } else if (state is UpdateFoodIconState) {
          _onUpdateFoodIconState(state);
        } else if (state is UpdateCameraZoomLevels) {
          _cameraZoomLevel = state.cameraZoomLevel;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Passio Preview'),
            actions: [
              ValueListenableBuilder(
                valueListenable: _flashlightEnabled,
                builder: (context, value, child) {
                  return Switch(
                    value: value,
                    onChanged: (value) {
                      _flashlightEnabled.value = value;
                      NutritionAI.instance
                          .enableFlashlight(enabled: value, level: 0.3);
                    },
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              const PassioPreview(),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ValueListenableBuilder(
                    valueListenable: _zoomLevel,
                    builder: (context, value, child) {
                      return Slider(
                        value: value,
                        min: _cameraZoomLevel?.minZoomLevel ?? 1,
                        max: _cameraZoomLevel?.maxZoomLevel ?? 10,
                        onChanged: (value) {
                          _zoomLevel.value = value;
                          NutritionAI.instance
                              .setCameraZoomLevel(zoomLevel: value);
                        },
                      );
                    }),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: PassioResult(foodName: _foodName, image: _image),
              )
            ],
          ),
        );
      },
    );
  }

  void _onSearchingState(SearchingState state) {
    _foodName = null;
    _image = null;
  }

  void _onUpdateFoodNameState(UpdateFoodNameState state) {
    _foodName = state.name;
  }

  void _onUpdateFoodIconState(UpdateFoodIconState state) {
    _image = state.image;
  }

  void _checkPermission() async {
    if (await Permission.camera.request().isGranted) {
      _startFoodDetection();
      _bloc.add(GetCameraZoomLevelEvent());
    }
  }

  void _startFoodDetection() {
    var detectionConfig = const FoodDetectionConfiguration(
        detectBarcodes: true,
        detectPackagedFood: true,);
    NutritionAI.instance.startFoodDetection(detectionConfig, this);
  }

  @override
  void recognitionResults(
      FoodCandidates? foodCandidates, PlatformImage? image) {
    _bloc.add(FoodRecognizedEvent(candidates: foodCandidates, image: image));
  }

  @override
  void dispose() {
    NutritionAI.instance.stopFoodDetection();
    super.dispose();
  }
}

class PassioResult extends StatelessWidget {
  final String? foodName;
  final PlatformImage? image;

  const PassioResult({required this.foodName, required this.image, super.key});

  String _resultString() {
    if (foodName == null) {
      return 'Searching...';
    }
    return foodName!;
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = defaultTargetPlatform;

    return Container(
      width: double.infinity,
      height: 100,
      margin: const EdgeInsets.all(10),
      padding: _getPadding(platform),
      decoration: const BoxDecoration(color: Colors.lightBlueAccent),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PassioIcon(image: image),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 32,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  _resultString(),
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  softWrap: true,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  EdgeInsets _getPadding(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
        return const EdgeInsets.symmetric(vertical: 24, horizontal: 16);
      case TargetPlatform.iOS:
        return const EdgeInsets.fromLTRB(10, 10, 10, 32);
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }
}
