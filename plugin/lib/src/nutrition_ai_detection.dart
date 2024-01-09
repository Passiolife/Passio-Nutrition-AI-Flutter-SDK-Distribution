import 'dart:math';

import 'models/nutrition_ai_image.dart';

import 'package:nutrition_ai/src/nutrition_ai_configuration.dart';

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
  VolumeDetectionMode volumeDetectionMode;

  FoodDetectionConfiguration(
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
  void recognitionResults(FoodCandidates foodCandidates, PlatformImage? image);
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
  List<DetectedCandidate> detectedCandidates = [];
  List<BarcodeCandidate>? barcodeCandidates;
  List<PackagedFoodCandidate>? packagedFoodCandidates;
}

/// Class that represents the results of the food detection process.
class DetectedCandidate {
  final PassioID passioID;
  final double confidence;
  final Rectangle<double> boundingBox;
  AmountEstimate? amountEstimate;

  DetectedCandidate(this.passioID, this.confidence, this.boundingBox);
}

/// Data class that represents the results of the barcode detection process.
class BarcodeCandidate {
  final String value;
  final Rectangle<double> boundingBox;

  BarcodeCandidate(this.value, this.boundingBox);
}

/// Represents the result of the packaged food detection process.
class PackagedFoodCandidate {
  final PackagedFoodCode packagedFoodCode;
  final double confidence;

  PackagedFoodCandidate(this.packagedFoodCode, this.confidence);
}

/// Data class that represents the results of the volume detection process.
class AmountEstimate {
  /// Volume estimate.
  double? volumeEstimate;

  /// Scanned Amount in grams.
  double? weightEstimate;

  /// The quality of the estimate (eventually for feedback to the user or
  /// SDK-based app developer).
  EstimationQuality? estimationQuality;

  /// Hints how to move the device for better estimation.
  MoveDirection? moveDevice;

  /// The Angel in radians from the perpendicular surface.
  double? viewingAngle;
}

enum MoveDirection { away, ok, up, down, around }

enum EstimationQuality { good, fair, poor, noEstimation }
