import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_ai_example/const/app_colors.dart';
import 'package:nutrition_ai_example/const/dimens.dart';
import 'package:nutrition_ai_example/const/styles.dart';
import 'package:nutrition_ai_example/inject/injector.dart';
import 'package:nutrition_ai_example/presentation/static_image/bloc/static_image_bloc.dart';
import 'package:nutrition_ai_example/util/context_extension.dart';
import 'package:nutrition_ai_example/util/double_extension.dart';
import 'package:nutrition_ai_example/util/permission_manager_utility.dart';
import 'package:nutrition_ai_example/util/snackbar_extension.dart';
import 'package:nutrition_ai_example/util/string_extensions.dart';

class StaticImagePage extends StatefulWidget {
  const StaticImagePage({super.key});

  @override
  State<StaticImagePage> createState() => _StaticImagePageState();
}

class _StaticImagePageState extends State<StaticImagePage>
    with WidgetsBindingObserver {
  /// [_bloc] is use to do operations on Image.
  final _bloc = sl<StaticImageBloc>();

  /// [_selectedImage] contains the file which picked from gallery or camera.
  XFile? _selectedImage;

  bool loading = false;

  ///
  String? _foodName;
  double? _confidence;

  /// [_foodBoxRectangle] is two-dimensional rectangles and it contains the left, top, Width & Height for the particular food.
  math.Rectangle<double>? _foodBoxRectangle;

  /// [_imageWidgetBox] contains render information of the image widget..
  RenderBox? _imageWidgetBox;

  /// Key is use to identify the image widget.
  final _imageWidgetKey = GlobalKey();

  /// Key is use to identify the stack widget.
  final _stackWidgetKey = GlobalKey();

  /// [_isLoading] will true when SDK is called with image.
  bool _isLoading = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    PermissionManagerUtility().didChangeAppLifecycleState(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StaticImageBloc, StaticImageState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is OnSelectImageState) {
          _handleOnImageSelectState(state: state);
        } else if (state is OnImageAttributeFoundState) {
          _handleOnImageAttributeFoundState(state: state);
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
            title: Text(context.localization?.staticImage ?? ''),
          ),
          body: Column(
            children: [
              Expanded(
                child: (_selectedImage?.path.isNotEmpty ?? false)
                    ? Center(
                        child: Stack(
                          key: _stackWidgetKey,
                          children: [
                            Image.file(
                              File(_selectedImage?.path ?? ''),
                              key: _imageWidgetKey,
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
                                    child: Text(context
                                            .localization?.imageNotSupported ??
                                        ''));
                              },
                            ),

                            /// Below widget is use to lightly blur the background.
                            _foodBoxRectangle != null
                                ? Positioned.fill(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 1.0,
                                        sigmaY: 1.0,
                                      ),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),

                            /// Below widget is use to blur the background and draw the bounding with box.
                            if (_foodBoxRectangle != null)
                              Positioned(
                                top: (_foodBoxRectangle?.top ?? 0),
                                left: (_foodBoxRectangle?.left ?? 0),
                                child: Container(
                                  width: _foodBoxRectangle?.width,
                                  height: _foodBoxRectangle?.height,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.borderColor,
                                        width: Dimens.r4),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        color: Colors.grey.shade200
                                            .withOpacity(0.5),
                                        child: ClipRRect(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 5.0,
                                              sigmaY: 5.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: Dimens.h4),
                                                Center(
                                                  child: Text(
                                                    (_foodName ?? '')
                                                            .toTitleCase() ??
                                                        '',
                                                    textAlign: TextAlign.center,
                                                    style: AppStyles.style18
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: Dimens.h4),
                                                Text(
                                                  context.localization?.quality
                                                          .format([
                                                        ((_confidence ?? 0) *
                                                                100)
                                                            .roundUpAbs
                                                            .toString()
                                                      ]) ??
                                                      '',
                                                  style: AppStyles.style18
                                                      .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(height: Dimens.h8),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              const SizedBox(),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ),
              SizedBox(height: Dimens.h8),
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
    _foodBoxRectangle = null;
    _selectedImage = state.image;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _imageWidgetBox =
          (_imageWidgetKey.currentContext?.findRenderObject() as RenderBox?);
    });
  }

  void _handleOnImageAttributeFoundState(
      {required OnImageAttributeFoundState state}) {
    _foodName = state.foodName;
    _confidence = state.confidence;

    _foodBoxRectangle = math.Rectangle(
      // Calculate left position
      (_imageWidgetBox
                  ?.localToGlobal(Offset.zero,
                      ancestor:
                          _stackWidgetKey.currentContext?.findRenderObject())
                  .dx ??
              0) +
          (((_imageWidgetBox?.size.width ?? 0) *
                  state.relativeBoundingBox.left) /
              1),

      // Calculate top position
      (_imageWidgetBox
                  ?.localToGlobal(Offset.zero,
                      ancestor:
                          _stackWidgetKey.currentContext?.findRenderObject())
                  .dy ??
              0) +
          (((_imageWidgetBox?.size.height ?? 0) *
                  state.relativeBoundingBox.top) /
              1),

      // Calculate width
      (((_imageWidgetBox?.size.width ?? 0) * state.relativeBoundingBox.width) /
          1),

      // Calculate Height
      (((_imageWidgetBox?.size.height ?? 0) *
              state.relativeBoundingBox.height) /
          1),
    );
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
