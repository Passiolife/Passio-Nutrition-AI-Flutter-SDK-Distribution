import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/util/permission_manager_utility.dart';
import 'package:permission_handler/permission_handler.dart';

part 'recognize_image_event.dart';
part 'recognize_image_state.dart';

class RecognizeImageBloc
    extends Bloc<RecognizeImageEvent, RecognizeImageState> {
  RecognizeImageBloc() : super(RecognizeImageInitial()) {
    on<DoImagePickEvent>(_handleDoImagePickEvent);
    on<DoOnImageSelectEvent>(_handleDoOnImageSelectEvent);
  }

  Future _handleDoImagePickEvent(
      DoImagePickEvent event, Emitter<RecognizeImageState> emit) async {
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
              add(DoOnImageSelectEvent(image: image, source: event.source));
            }
          }
        },
      );
    } on Exception catch (e) {
      emit(OnSelectImageLoadingState(isLoading: false));
      emit(OnSelectImageFailureState(message: 'Failed to pick image: $e'));
    }
  }

  Future _handleDoOnImageSelectEvent(
      DoOnImageSelectEvent event, Emitter<RecognizeImageState> emit) async {
    // Here, passing the loading state to ui.
    // So, loader will be visible to the user.
    emit(OnSelectImageLoadingState(isLoading: true));

    /// If image is taken from a camera then rotate it if required.
    if (event.source == ImageSource.camera) {
      // Rotate the image to fix the wrong rotation coming from ImagePicker
      await FlutterExifRotation.rotateImage(path: event.image?.path ?? '');
    }

    /// Passing image to the UI.
    emit(OnSelectImageState(image: event.image));

    var file = File(event.image?.path ?? '');
    var bytes = file.readAsBytesSync();
    final list = await NutritionAI.instance.recognizeImageRemote(bytes);

    emit(OnSelectImageLoadingState(isLoading: false));
    emit(ImageRecognitionSuccessState(list));
  }
}
