import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/common/util/context_extension.dart';
import 'package:nutrition_ai_example/common/util/string_extensions.dart';
import 'package:nutrition_ai_example/const/app_colors.dart';
import 'package:nutrition_ai_example/const/dimens.dart';
import 'package:nutrition_ai_example/util/permission_manager_utility.dart';
import 'package:nutrition_ai_example/util/snackbar_extension.dart';

import '../../common/passio_image_widget.dart';
import 'bloc/recognize_image_bloc.dart';

class RecognizeImagePage extends StatefulWidget {
  const RecognizeImagePage({super.key});

  @override
  State<RecognizeImagePage> createState() => _RecognizeImagePageState();
}

class _RecognizeImagePageState extends State<RecognizeImagePage>
    with WidgetsBindingObserver {
  /// [_bloc] is use to do operations on Image.
  final _bloc = RecognizeImageBloc();

  /// [_selectedImage] contains the file which picked from gallery or camera.
  XFile? _selectedImage;

  /// [_isLoading] will true when SDK is called with image.
  bool _isLoading = false;

  final List<PassioAdvisorFoodInfo> result = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    PermissionManagerUtility().didChangeAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecognizeImageBloc, RecognizeImageState>(
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
              _selectedImage?.path.isNotEmpty ?? false
                  ? Image.file(
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
                    )
                  : const SizedBox.shrink(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    final data = result.elementAt(index);
                    return ListTile(
                      leading: PassioImageWidget(
                          iconId: data.foodDataInfo?.iconID ?? ''),
                      title: Text(
                          data.foodDataInfo?.foodName.toUpperCaseWord ?? ''),
                    );
                  },
                ),
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // Capture a photo.
                            _bloc.add(
                                DoImagePickEvent(source: ImageSource.camera));
                          },
                          child: Text(context.localization?.camera ?? ''),
                        ),
                        SizedBox(width: Dimens.w16),
                        ElevatedButton(
                          onPressed: () async {
                            // Pick an image.
                            _bloc.add(
                                DoImagePickEvent(source: ImageSource.gallery));
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

  void _handleOnImageSelectState({required OnSelectImageState state}) {
    _selectedImage = state.image;
  }

  void _handleImageRecognitionSuccessState(
      {required ImageRecognitionSuccessState state}) {
    result.clear();
    result.addAll(state.data);
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
