import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../util/permission_manager_utility.dart';

part 'advisor_image_event.dart';
part 'advisor_image_state.dart';

class AdvisorImageBloc extends Bloc<AdvisorImageEvent, AdvisorImageState> {
  AdvisorImageBloc() : super(const AdvisorImageInitial()) {
    on<DoInitConversionEvent>(_handleDoInitConversionEvent);
    on<DoImagePickEvent>(_handleDoImagePickEvent);
    on<DoSendMessageEvent>(_handleDoSendMessageEvent);
  }

  FutureOr<void> _handleDoInitConversionEvent(
      DoInitConversionEvent event, Emitter<AdvisorImageState> emit) async {
    final result = await NutritionAdvisor.instance.initConversation();
    switch (result) {
      case Error():
        emit(InitializationErrorState(message: result.message));
        break;
      case Success():
        emit(const InitializationSuccessState());
        break;
    }
  }

  Future _handleDoImagePickEvent(
      DoImagePickEvent event, Emitter<AdvisorImageState> emit) async {
    /// Here we are checking is Android Device and it is Lower than Android 13.
    bool isLowerAndroidVersion = Platform.isAndroid &&
        (await DeviceInfoPlugin().androidInfo).version.sdkInt <= 32;

    try {
      await PermissionManagerUtility().request(
        (event.source == ImageSource.gallery)
            ? (isLowerAndroidVersion)
                ? Permission.storage
                : Permission.photos
            : Permission.camera,
        onUpdateStatus: (Permission? permission) async {
          if (((await permission?.isGranted) ?? false) ||
              (await permission?.isLimited ?? false)) {
            /// Open the appropriate source with [ImagePicker].
            final XFile? image =
                await ImagePicker().pickImage(source: event.source);

            if (image != null && (image.path.isNotEmpty)) {
              add(DoSendMessageEvent(image: image, source: event.source));
            }
          }
        },
      );
    } on Exception catch (e) {
      emit(const OnSelectImageLoadingState(isLoading: false));
      emit(OnSelectImageFailureState(message: 'Failed to pick image: $e'));
    }
  }

  FutureOr<void> _handleDoSendMessageEvent(
      DoSendMessageEvent event, Emitter<AdvisorImageState> emit) async {
    /// If image is taken from a camera then rotate it if required.
    if (event.source == ImageSource.camera) {
      // Rotate the image to fix the wrong rotation coming from ImagePicker
      await FlutterExifRotation.rotateImage(path: event.image?.path ?? '');
    }

    /// Passing image to the UI.
    emit(OnSelectImageState(image: event.image));

    var file = File(event.image?.path ?? '');
    var bytes = file.readAsBytesSync();
    final result = await NutritionAdvisor.instance.sendImage(bytes);
    switch (result) {
      case Success():
        emit(SendMessageSuccessState(data: result.value));
        break;
      case Error():
        emit(SendMessageErrorState(message: result.message));
        break;
    }
  }
}
