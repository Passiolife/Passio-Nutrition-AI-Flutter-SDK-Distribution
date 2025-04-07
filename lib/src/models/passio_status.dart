import 'package:flutter/foundation.dart';
import 'package:nutrition_ai/src/extensions/list_extension.dart';

import '../../nutrition_ai.dart';

/// Object that is returned as a result of the configuration process.
class PassioStatus {
  /// Indicates the state of the configuration process.
  final PassioMode mode;

  /// If the SDK is missing files or new files could be used. It will send the
  /// list of files needed for the update.
  final List<String>? missingFiles;

  /// A string with more verbose information related to the configuration.
  final String? debugMessage;

  /// The error in case the SDK failed to configure
  final PassioSDKError? error;

  /// The version of the latest models that are now used by the SDK.
  final int? activeModels;

  const PassioStatus({
    this.mode = PassioMode.notReady,
    this.missingFiles,
    this.debugMessage,
    this.error,
    this.activeModels,
  });

  factory PassioStatus.fromJson(Map<String, dynamic> json) {
    return PassioStatus(
      mode: PassioMode.values.byName(json['mode']),
      error: (json['error'] != null)
          ? PassioSDKError.values.byName(json['error'])
          : null,
      activeModels: json['activeModels'],
      debugMessage: json['debugMessage'],
      missingFiles: (json['missingFiles'] as List<dynamic>?)?.toListOfString(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! PassioStatus) return false;
    if (identical(this, other)) return true;

    return mode == other.mode &&
        listEquals(missingFiles, other.missingFiles) &&
        debugMessage == other.debugMessage &&
        error == other.error &&
        activeModels == other.activeModels;
  }

  @override
  int get hashCode {
    return Object.hash(
      mode,
      Object.hashAll(missingFiles ?? []),
      debugMessage,
      error,
      activeModels,
    );
  }

  @override
  String toString() {
    return 'PassioStatus{mode: ${mode.name}, missingFiles: $missingFiles, debugMessage: $debugMessage, error: ${error?.name}, activeModels: $activeModels}';
  }
}
