import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:nutrition_ai/src/converter/platform_output_converter.dart';
import 'package:nutrition_ai/src/nutrition_ai_configuration.dart';

import 'models/platform_image.dart';

/// Identifier of food items in the NutritionAI's database.
typedef PassioID = String;

/// Identifier of a product code scanned from a barcode.
typedef Barcode = String;

/// Identifier of a product code scanned from a package.
typedef PackagedFoodCode = String;

/// Configuration object used to define a recognition session.
class FoodDetectionConfiguration {
  /// Food item detection using Passio's AI system.
  final bool detectVisual;

  /// Barcode detection.
  final bool detectBarcodes;

  /// Detection of the front side of a packaged food item.
  final bool detectPackagedFood;

  /// Detection of nutrition facts table.
  final bool detectNutritionFacts;

  /// Defines how often the recognition system processes a frame.
  final FramesPerSecond framesPerSecond;

  /// Defines a volume detection mode.
  final VolumeDetectionMode volumeDetectionMode;

  const FoodDetectionConfiguration(
      {this.detectVisual = true,
      this.detectBarcodes = false,
      this.detectPackagedFood = false,
      this.detectNutritionFacts = false,
      this.framesPerSecond = FramesPerSecond.two,
      this.volumeDetectionMode = VolumeDetectionMode.none});
}

enum FramesPerSecond { one, two, three, four, max }

enum VolumeDetectionMode { auto, dualWideCamera, none }

/// Used as a callback to receive results from analyzing camera frames.
abstract class FoodRecognitionListener {
  void recognitionResults(FoodCandidates? foodCandidates, PlatformImage? image);
}

abstract interface class PassioStatusListener {
  /// Every time the SDK's configuration process changes
  /// a state, a new event will be emitted with the
  /// current [PassioStatus].
  void onPassioStatusChanged(PassioStatus status);

  /// Will be called once all of the files are downloaded.
  ///
  /// This doesn't mean that the SDK will immediately run
  /// the newly downloaded files.
  void onCompletedDownloadingAllFiles(List<Uri> fileUris);

  /// Signals the completion of the download process for a
  /// single files. This method also informs how many files
  /// are still left in the download queue.
  void onCompletedDownloadingFile(Uri fileUri, int filesLeft);

  /// If a certain file cannot be downloaded, [onDownloadError]
  /// will be invoked with the download error message attached.
  void onDownloadError(String message);
}

/// Data class that represents the results of the SDK's detection process.
class FoodCandidates {
  /// The Barcode candidates if available
  final List<BarcodeCandidate>? barcodeCandidates;

  /// The visual candidates returned from the recognition
  final List<DetectedCandidate>? detectedCandidates;

  /// The packaged food candidates if available
  final List<PackagedFoodCandidate>? packagedFoodCandidates;

  FoodCandidates({
    this.barcodeCandidates,
    this.detectedCandidates,
    this.packagedFoodCandidates,
  });

  factory FoodCandidates.fromJson(Map<String, dynamic> json) {
    List<BarcodeCandidate>? barcodeCandidates = mapListOfObjectsOptional(
        json['barcodeCandidates'],
        (inMap) => BarcodeCandidate.fromJson(inMap.cast<String, dynamic>()));

    List<DetectedCandidate>? detectedCandidates = mapListOfObjectsOptional(
        json['detectedCandidate'],
        (inMap) => DetectedCandidate.fromJson(inMap.cast<String, dynamic>()));

    List<PackagedFoodCandidate>? packagedFoodCandidates =
        mapListOfObjectsOptional(
            json['packagedFoodCandidates'],
            (inMap) =>
                PackagedFoodCandidate.fromJson(inMap.cast<String, dynamic>()));

    return FoodCandidates(
      detectedCandidates: detectedCandidates,
      barcodeCandidates: barcodeCandidates,
      packagedFoodCandidates: packagedFoodCandidates,
    );
  }
}

/// Class that represents the results of the food detection process.
class DetectedCandidate {
  /// List of alternative detected candidates.
  final List<DetectedCandidate> alternatives;

  /// Estimated amount of the detected food.
  final AmountEstimate? amountEstimate;

  /// Bounding box representing the location of the detected food.
  final Rectangle<double> boundingBox;

  /// Confidence level (0.0 to 1.0) of the detection.
  final double confidence;

  /// Cropped image associated with the detection.
  final PlatformImage? croppedImage;

  /// Name of the detected food.
  final String foodName;

  /// Identifier recognized by the ML model.
  final PassioID passioID;

  /// Constructs a DetectedCandidate instance.
  const DetectedCandidate({
    required this.alternatives,
    required this.boundingBox,
    required this.confidence,
    required this.foodName,
    required this.passioID,
    this.amountEstimate,
    this.croppedImage,
  });

  factory DetectedCandidate.fromJson(Map<String, dynamic> json) {
    final alternatives =
        mapListOfObjects(json['alternatives'], DetectedCandidate.fromJson);

    // Extract bounding box values from the input map and create a Rectangle
    List<double> boxArray = json['boundingBox'].cast<double>();
    var boundingBox = Rectangle(
      boxArray[0],
      boxArray[1],
      boxArray[2],
      boxArray[3],
    );

    // Map the 'amountEstimate' key to an [AmountEstimate] object
    AmountEstimate? amountEstimate =
        json.ifValueNotNull('amountEstimate', AmountEstimate.fromJson);

    // Converting the mapped croppedImage properties to a PlatformImage
    final croppedImage = json.ifValueNotNull('croppedImage',
        (map) => PlatformImage.fromJson(map.cast<String, dynamic>()));

    // Create and return a DetectedCandidate object with the extracted values
    return DetectedCandidate(
      alternatives: alternatives,
      boundingBox: boundingBox,
      confidence: json['confidence'],
      croppedImage: croppedImage,
      foodName: json["foodName"],
      passioID: json['passioID'],
      amountEstimate: amountEstimate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DetectedCandidate &&
        listEquals(alternatives, other.alternatives) &&
        amountEstimate == other.amountEstimate &&
        boundingBox == other.boundingBox &&
        confidence == other.confidence &&
        croppedImage == other.croppedImage &&
        foodName == other.foodName &&
        passioID == other.passioID;
  }

  @override
  int get hashCode => Object.hash(
        alternatives,
        amountEstimate,
        boundingBox,
        confidence,
        croppedImage,
        foodName,
        passioID,
      );
}

/// Data class that represents the results of the barcode detection process.
class BarcodeCandidate {
  final String value;
  final Rectangle<double> boundingBox;

  const BarcodeCandidate(this.value, this.boundingBox);

  factory BarcodeCandidate.fromJson(Map<String, dynamic> json) {
    List<double> boxArray = json['boundingBox'].cast<double>();
    var boundingBox =
        Rectangle(boxArray[0], boxArray[1], boxArray[2], boxArray[3]);
    return BarcodeCandidate(json['value'], boundingBox);
  }
}

/// Represents the result of the packaged food detection process.
class PackagedFoodCandidate {
  final PackagedFoodCode packagedFoodCode;
  final double confidence;

  const PackagedFoodCandidate(this.packagedFoodCode, this.confidence);

  factory PackagedFoodCandidate.fromJson(Map<String, dynamic> json) {
    return PackagedFoodCandidate(json['packagedFoodCode'], json['confidence']);
  }
}

/// Data class that represents the results of the volume detection process.
class AmountEstimate {
  /// The quality of the estimate (eventually for feedback to the user or
  /// SDK-based app developer).
  final EstimationQuality? estimationQuality;

  /// Hints how to move the device for better estimation.
  final MoveDirection? moveDevice;

  /// Volume estimate.
  final double? volumeEstimate;

  /// The Angel in radians from the perpendicular surface.
  final double? viewingAngle;

  /// Scanned Amount in grams.
  final double? weightEstimate;

  // Constructor for the AmountEstimate class
  const AmountEstimate({
    this.estimationQuality,
    this.moveDevice,
    this.volumeEstimate,
    this.viewingAngle,
    this.weightEstimate,
  });

  factory AmountEstimate.fromJson(Map<String, dynamic> json) {
    // Extract estimationQuality from JSON and convert it to EstimationQuality enum
    EstimationQuality? estimationQuality = (json['estimationQuality'] != null)
        ? EstimationQuality.values.firstWhere(
            (element) => element.name == json['estimationQuality'],
            orElse: () => EstimationQuality.noEstimation)
        : null;

    // Extract moveDevice from JSON and convert it to MoveDirection enum
    MoveDirection? moveDevice = (json['moveDevice'] != null)
        ? MoveDirection.values.firstWhere(
            (element) => element.name == json['moveDevice'],
            orElse: () => MoveDirection.ok)
        : null;

    // Extract volumeEstimate, viewingAngle, and weightEstimate from JSON
    double? volumeEstimate = json["volumeEstimate"];
    double? viewingAngle = json["viewingAngle"];
    double? weightEstimate = json["weightEstimate"];

    // Create and return an AmountEstimate object with the extracted values
    return AmountEstimate(
      estimationQuality: estimationQuality,
      moveDevice: moveDevice,
      volumeEstimate: volumeEstimate,
      viewingAngle: viewingAngle,
      weightEstimate: weightEstimate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AmountEstimate &&
        other.estimationQuality == estimationQuality &&
        other.moveDevice == moveDevice &&
        other.volumeEstimate == volumeEstimate &&
        other.viewingAngle == viewingAngle &&
        other.weightEstimate == weightEstimate;
  }

  @override
  int get hashCode => Object.hash(
        estimationQuality.hashCode,
        moveDevice.hashCode,
        volumeEstimate.hashCode,
        viewingAngle.hashCode,
        weightEstimate.hashCode,
      );
}

enum MoveDirection { away, ok, up, down, around }

enum EstimationQuality { good, fair, poor, noEstimation }
