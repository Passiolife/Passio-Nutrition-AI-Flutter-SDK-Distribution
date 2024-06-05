import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/common/constant/app_colors.dart';
import 'package:nutrition_ai_example/common/util/context_extension.dart';
import 'package:nutrition_ai_example/common/util/string_extensions.dart';
import 'package:nutrition_ai_example/util/snackbar_extension.dart';

import '../../common/passio_image_widget.dart';
import '../../util/permission_manager_utility.dart';
import 'bloc/advisor_image_bloc.dart';

class AdvisorImagePage extends StatefulWidget {
  const AdvisorImagePage({super.key});

  @override
  State<AdvisorImagePage> createState() => _AdvisorImagePageState();
}

class _AdvisorImagePageState extends State<AdvisorImagePage>
    with WidgetsBindingObserver {
  /// [_selectedImage] contains the file which picked from gallery or camera.
  XFile? _selectedImage;

  PassioAdvisorResponse? _response;

  final _bloc = AdvisorImageBloc();
  bool _isLoading = false;

  final TextEditingController _messageController =
      TextEditingController(text: 'Banana Recipe');

  @override
  void initState() {
    _bloc.add(const DoInitConversionEvent());
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    PermissionManagerUtility().didChangeAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdvisorImageBloc, AdvisorImageState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is OnSelectImageState) {
          _selectedImage = state.image;
        } else if (state is OnSelectImageFailureState) {
          context.showSnackbar(text: state.message);
        } else if (state is OnSelectImageLoadingState) {
          _isLoading = state.isLoading;
        } else if (state is InitializationSuccessState) {
        } else if (state is InitializationErrorState) {
          context.showSnackbar(text: state.message);
        } else if (state is SendMessageSuccessState) {
          _response = state.data;
        } else if (state is SendMessageErrorState) {
          context.showSnackbar(text: state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AI Advisor'),
          ),
          body: Column(
            children: [
              Container(
                color: AppColors.blue50,
                width: double.infinity,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(left: 24.w, right: 8.w),
                child: _selectedImage?.path.isNotEmpty ?? false
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
                                  context.localization?.imageNotSupported ??
                                      ''));
                        },
                      )
                    : const SizedBox.shrink(),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _response?.extractedIngredients?.length ?? 0,
                  itemBuilder: (context, index) {
                    final data =
                        _response?.extractedIngredients?.elementAt(index);
                    return ListTile(
                      leading: PassioImageWidget(
                          iconId: data?.foodDataInfo?.iconID ?? ''),
                      title: Text(
                          data?.foodDataInfo?.foodName.toUpperCaseWord ?? ''),
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
                            _bloc.add(const DoImagePickEvent(
                                source: ImageSource.camera));
                          },
                          child: Text(context.localization?.camera ?? ''),
                        ),
                        SizedBox(width: 16.w),
                        ElevatedButton(
                          onPressed: () async {
                            // Pick an image.
                            _bloc.add(const DoImagePickEvent(
                                source: ImageSource.gallery));
                          },
                          child: Text(context.localization?.photos ?? ''),
                        ),
                      ],
                    ),
              (context.bottomPadding + 8.h).verticalSpace,
            ],
          ),
        );
      },
    );
  }
}
