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

  /// Defines how often the recognition system processes a frame.
  final FramesPerSecond framesPerSecond;

  /// Defines a volume detection mode.
  final VolumeDetectionMode volumeDetectionMode;

  /// Constructs a [FoodDetectionConfiguration] with optional parameters.
  const FoodDetectionConfiguration({
    this.detectVisual = true,
    this.detectBarcodes = false,
    this.detectPackagedFood = false,
    this.framesPerSecond = FramesPerSecond.two,
    this.volumeDetectionMode = VolumeDetectionMode.none,
  });
}

/// Enumeration for the frames per second options.
enum FramesPerSecond {
  /// Process one frame per second.
  one,

  /// Process two frames per second.
  two,

  /// Process three frames per second.
  three,

  /// Process four frames per second.
  four,

  /// Process frames at the maximum possible rate.
  max
}

/// Enumeration for the volume detection mode options.
enum VolumeDetectionMode {
  /// Automatic volume detection mode.
  auto,

  /// Use dual wide cameras for volume detection.
  dualWideCamera,

  /// No volume detection.
  none
}

/// Used as a callback to receive results from analyzing camera frames.
abstract class FoodRecognitionListener {
  /// Method called to deliver recognition results.
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

  /// Constructs a [FoodCandidates] instance.
  FoodCandidates({
    this.barcodeCandidates,
    this.detectedCandidates,
    this.packagedFoodCandidates,
  });

  /// Constructs a [FoodCandidates] from a JSON map.
  factory FoodCandidates.fromJson(Map<String, dynamic> json) {
    // Parsing barcodeCandidates from the JSON map
    // Using mapListOfObjectsOptional to handle null or non-existent 'barcodeCandidates' key
    List<BarcodeCandidate>? barcodeCandidates = mapListOfObjectsOptional(
        json['barcodeCandidates'],
        (inMap) => BarcodeCandidate.fromJson(inMap.cast<String, dynamic>()));

    // Parsing detectedCandidates from the JSON map
    // Using mapListOfObjectsOptional to handle null or non-existent 'detectedCandidate' key
    List<DetectedCandidate>? detectedCandidates = mapListOfObjectsOptional(
        json['detectedCandidate'],
        (inMap) => DetectedCandidate.fromJson(inMap.cast<String, dynamic>()));

    // Parsing packagedFoodCandidates from the JSON map
    // Using mapListOfObjectsOptional to handle null or non-existent 'packagedFoodCandidates' key
    List<PackagedFoodCandidate>? packagedFoodCandidates =
        mapListOfObjectsOptional(
            json['packagedFoodCandidates'],
            (inMap) =>
                PackagedFoodCandidate.fromJson(inMap.cast<String, dynamic>()));

    // Returning an instance of FoodCandidates with parsed data
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

  /// Constructs a [DetectedCandidate] from a JSON map.
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

  /// Compares two `DetectedCandidate` objects for equality.
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

  /// Calculates the hash code for this `DetectedCandidate` object.
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
  /// The detected barcode value.
  final String value;

  /// The bounding box of the detected barcode in the image.
  final Rectangle<double> boundingBox;

  /// Constructs a [BarcodeCandidate] with the provided [value] and [boundingBox].
  const BarcodeCandidate(this.value, this.boundingBox);

  /// Constructs a [BarcodeCandidate] from a JSON map.
  factory BarcodeCandidate.fromJson(Map<String, dynamic> json) {
    List<double> boxArray = json['boundingBox'].cast<double>();
    var boundingBox =
        Rectangle(boxArray[0], boxArray[1], boxArray[2], boxArray[3]);
    return BarcodeCandidate(json['value'], boundingBox);
  }
}

/// Represents the result of the packaged food detection process.
class PackagedFoodCandidate {
  /// The detected packaged food code.
  final PackagedFoodCode packagedFoodCode;

  /// The confidence level of the detection.
  final double confidence;

  /// Constructs a [PackagedFoodCandidate] with the provided [packagedFoodCode] and [confidence].
  const PackagedFoodCandidate(
    this.packagedFoodCode,
    this.confidence,
  );

  /// Constructs a [PackagedFoodCandidate] from a JSON map.
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

  /// Creates a `AmountEstimate` instance from a JSON map.
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

  /// Compares two `AmountEstimate` objects for equality.
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

  /// Calculates the hash code for this `AmountEstimate` object.
  @override
  int get hashCode => Object.hash(
        estimationQuality.hashCode,
        moveDevice.hashCode,
        volumeEstimate.hashCode,
        viewingAngle.hashCode,
        weightEstimate.hashCode,
      );
}

/// Enum representing different move directions.
enum MoveDirection {
  /// Indicates moving away.
  away,

  /// Indicates no significant movement.
  ok,

  /// Indicates moving up.
  up,

  /// Indicates moving down.
  down,

  /// Indicates moving around.
  around
}

/// Enum representing the quality of an estimation.
enum EstimationQuality {
  /// Indicates a good estimation quality.
  good,

  /// Indicates a fair estimation quality.
  fair,

  /// Indicates a poor estimation quality.
  poor,

  /// Indicates that no estimation could be made.
  noEstimation
}
