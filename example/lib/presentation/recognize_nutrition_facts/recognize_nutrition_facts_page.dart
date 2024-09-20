import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/common/util/context_extension.dart';
import 'package:nutrition_ai_example/common/util/string_extensions.dart';
import 'package:nutrition_ai_example/const/app_colors.dart';
import 'package:nutrition_ai_example/const/dimens.dart';
import 'package:nutrition_ai_example/presentation/recognize_nutrition_facts/bloc/recognize_nutrition_facts_bloc.dart';
import 'package:nutrition_ai_example/util/permission_manager_utility.dart';
import 'package:nutrition_ai_example/util/snackbar_extension.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/passio_image_widget.dart';

class RecognizeNutritionFactsPage extends StatefulWidget {
  const RecognizeNutritionFactsPage({super.key});

  @override
  State<RecognizeNutritionFactsPage> createState() =>
      _RecognizeNutritionFactsPageState();
}

class _RecognizeNutritionFactsPageState
    extends State<RecognizeNutritionFactsPage> with WidgetsBindingObserver {
  /// [_bloc] is use to do operations on Image.
  final _bloc = RecognizeNutritionFactsBloc();

  /// [_selectedImage] contains the file which picked from gallery or camera.
  XFile? _selectedImage;

  /// [_isLoading] will true when SDK is called with image.
  bool _isLoading = false;

  PassioFoodItem? result;

  // Listener for app lifecycle changes
  AppLifecycleListener? _lifecycleListener;

  // Instance of PermissionManagerUtility to handle permissions
  final PermissionManagerUtility _permissionManager =
      PermissionManagerUtility();

  @override
  void initState() {
    _lifecycleListener = AppLifecycleListener(
      // Callback function triggered on app lifecycle state change
      onStateChange: (state) {
        // Call permission manager to handle app lifecycle state change
        _permissionManager.didChangeAppLifecycleState(state);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _lifecycleListener?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _permissionManager.didChangeAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecognizeNutritionFactsBloc,
        RecognizeNutritionFactsState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is OnSelectImageState) {
          _handleOnImageSelectState(state: state);
        } else if (state is ImageRecognitionSuccessState) {
          _handleImageRecognitionSuccessState(state: state);
        } else if (state is OnSelectImageFailureState) {
          _handleOnSelectImageFailureState(state: state);
        } else if (state is OnSelectImageLoadingState) {
          _handleOnSelectImageLoadingState(state: state);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.searchFieldColor,
          appBar: AppBar(
            title: Text(context.localization?.recognizeImage ?? ''),
          ),
          body: Column(
            children: [
              if (_selectedImage?.path.isNotEmpty ?? false)
                Expanded(
                  child: Image.file(
                    File(_selectedImage?.path ?? ''),
                    width: 300,
                    height: 300,
                    frameBuilder: (BuildContext context, Widget child,
                        int? frame, bool? wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded ?? false) {
                        return child;
                      }
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Center(
                          child: Text(
                              context.localization?.imageNotSupported ?? ''));
                    },
                  ),
                )
              else
                const Expanded(child: SizedBox.shrink()),
              result != null
                  ? ListTile(
                      leading: PassioImageWidget(iconId: result?.iconId ?? ''),
                      title: Text(result?.name.toUpperCaseWord ?? ''),
                    )
                  : const SizedBox.shrink(),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            _checkPermission(source: ImageSource.camera);
                          },
                          child: Text(context.localization?.camera ?? ''),
                        ),
                        SizedBox(width: Dimens.w16),
                        ElevatedButton(
                          onPressed: () async {
                            _checkPermission(source: ImageSource.gallery);
                          },
                          child: Text(context.localization?.photos ?? ''),
                        ),
                      ],
                    ),
              SizedBox(height: Dimens.h16),
            ],
          ),
        );
      },
    );
  }

  // Check camera permission
  Future _checkPermission({required ImageSource source}) async {
    /// Here we are checking is Android Device and it is Lower than Android 13.
    bool isLowerAndroidVersion = Platform.isAndroid &&
        (await DeviceInfoPlugin().androidInfo).version.sdkInt <= 32;

    await _permissionManager.request(
      (source == ImageSource.gallery)
          ? (isLowerAndroidVersion)
              ? Permission.storage
              : Permission.photos
          : Permission.camera,
      onUpdateStatus: (Permission? permission) async {
        if (((await permission?.isGranted) ?? false) ||
            (await permission?.isLimited ?? false)) {
          _bloc.add(DoImagePickEvent(source: source));
        }
      },
    );
  }

  void _handleOnImageSelectState({required OnSelectImageState state}) {
    _selectedImage = state.image;
  }

  void _handleImageRecognitionSuccessState(
      {required ImageRecognitionSuccessState state}) {
    result = state.data;
  }

  void _handleOnSelectImageFailureState(
      {required OnSelectImageFailureState state}) {
    context.showSnackbar(text: state.message);
  }

  void _handleOnSelectImageLoadingState(
      {required OnSelectImageLoadingState state}) {
    _isLoading = state.isLoading;
  }
}
