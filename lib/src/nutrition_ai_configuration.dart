/// A [PassioConfiguration] object must be constructed to configure the SDK. The
/// configuration process depends on the location of the files needed for the
/// SDK to work. There are three different ways to configure the SDK depending
/// on the attributes of the object.
class PassioConfiguration {
  /// Developer key provided by Passio Inc. For obtaining this key contact
  /// support@passiolife.com.
  final String key;

  /// If you set this option to true, the SDK will download the models relevant
  /// for this version from Passio's bucket.
  final bool sdkDownloadsModels;

  /// If you set allowInternetConnection = false without working with Passio the
  /// SDK will not work. The SDK will not connect to the internet for key
  /// validations, barcode data and packaged food data.
  final bool allowInternetConnection;

  /// If you have chosen to remove the files from the SDK and provide the SDK
  /// different URLs for this files please use this variable.
  final List<String>? filesLocalURLs;

  /// Only use provided models. Don't use models previously installed.
  final bool overrideInstalledVersion;

  /// If you have problems configuring the SDK, set debugMode = 1 to get more
  /// debugging information.
  final int debugMode;

  /// Set to true to use only remote services without downloading local models.
  ///
  /// If true, the SDK will rely solely on remote services and won't download
  /// any models. This is useful when you prefer to use only remote APIs,
  /// allowing the configuration process to be faster than usual.
  final bool remoteOnly;

  /// Optional proxy URL to be used as the base URL for all API calls within the SDK
  /// targeting the Passio backend. If not provided, the default base URL will be used.
  final String? proxyUrl;

  /// Optional headers to be appended to the predefined headers when making API calls.
  /// These headers are used in conjunction with the `proxyUrl` for custom configurations.
  final Map<String, String>? proxyHeaders;

  const PassioConfiguration(
    this.key, {
    this.sdkDownloadsModels = true,
    this.allowInternetConnection = true,
    this.filesLocalURLs,
    this.overrideInstalledVersion = false,
    this.debugMode = 0,
    this.remoteOnly = false,
    this.proxyUrl,
    this.proxyHeaders,
  });
}

enum PassioMode {
  /// Indicates that the configuration process has not started yet.
  notReady,

  /// The configuration process has encountered an error and was not completed
  /// successfully.
  failedToConfigure,

  /// The configuration process is still running.
  isBeingConfigured,

  /// A newer version of files needed by the SDK are being downloaded.
  isDownloadingModels,

  /// All the files needed by the SDK are present and the SDK can be used to its
  /// full extent.
  isReadyForDetection
}

enum PassioSDKError {
  canNotRunOnSimulator,
  keyNotValid,
  licensedKeyHasExpired,
  modelsNotValid,
  modelsDownloadFailed,
  noModelsFilesFound,
  noInternetConnection,
  notLicensedForThisProject,
  minSDKVersion,
  licenseDecodingError,
  missingDependency,
  platformException,
  networkError,
}
