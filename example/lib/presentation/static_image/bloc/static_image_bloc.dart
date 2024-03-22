import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:device_info_plus/device_info_plus.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:nutrition_ai_example/domain/repository/nutrition_ai_wrapper.dart';
import 'package:nutrition_ai_example/util/permission_manager_utility.dart';
import 'package:permission_handler/permission_handler.dart';

part 'static_image_event.dart';
part 'static_image_state.dart';

class StaticImageBloc extends Bloc<StaticImageEvent, StaticImageState> {
  final NutritionAiWrapper nutritionAiWrapper;

  StaticImageBloc({required this.nutritionAiWrapper})
      : super(StaticImageInitial()) {
    on<DoImagePickEvent>(_handleDoImagePickEvent);
    on<DoOnImageSelectEvent>(_handleDoOnImageSelectEvent);
  }

  Future _handleDoImagePickEvent(
      DoImagePickEvent event, Emitter<StaticImageState> emit) async {
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
      DoOnImageSelectEvent event, Emitter<StaticImageState> emit) async {
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

    /// Here, we will call the SDK for the food detection from image.
    const detectionConfig = FoodDetectionConfiguration(
        detectBarcodes: true, detectPackagedFood: true);
    FoodCandidates? foodCandidates = await nutritionAiWrapper.detectFoodIn(
        event.image?.path, detectionConfig);

    if (foodCandidates == null) {
      return;
    }

    emit(OnSelectImageLoadingState(isLoading: false));

    var passioID = foodCandidates.detectedCandidates?.firstOrNull?.passioID;
    var barcode = foodCandidates.barcodeCandidates?.firstOrNull?.value;
    var packagedFoodCode =
        foodCandidates.packagedFoodCandidates?.firstOrNull?.packagedFoodCode;

    /// If the scan result is Bar code.
    if (barcode != null) {
      final foodItem =
          await NutritionAI.instance.fetchFoodItemForProductCode(barcode);
      final candidate = foodCandidates.barcodeCandidates!.firstOrNull!;
      final candidateBB = candidate.boundingBox;
      emit(OnImageAttributeFoundState(
          confidence: 1.00,
          relativeBoundingBox: candidateBB,
          foodName: foodItem?.name ?? 'Unknown'));
    }

    /// If the scan result is food package.
    else if (packagedFoodCode != null) {
      final foodItem = await NutritionAI.instance
          .fetchFoodItemForProductCode(packagedFoodCode);
      const box = math.Rectangle(0.0, 0.0, 1.0, 1.0);
      emit(OnImageAttributeFoundState(
          confidence: 1.00,
          relativeBoundingBox: box,
          foodName: foodItem?.name ?? 'Unknown'));
    }

    /// If the scan result is passioID.
    else if (passioID != null) {
      final foodItem =
          await NutritionAI.instance.fetchFoodItemForPassioID(passioID);
      final candidate = foodCandidates.detectedCandidates!.first;
      final candidateBB = candidate.boundingBox;
      emit(OnImageAttributeFoundState(
          confidence: 1.00,
          relativeBoundingBox: candidateBB,
          foodName: foodItem?.name ?? 'Unknown'));
    }
  }
}
