package ai.passio.nutrition_ai

import ai.passio.nutrition_ai.view.NativePreviewFactory
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** NutritionAiPlugin */
class NutritionAIPlugin: FlutterPlugin, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var method : MethodChannel
  private lateinit var detectionChannel: EventChannel
  // Declared a lateinit variable to hold the EventChannel for status updates.
  private lateinit var statusChannel: EventChannel
  private var activity: ActivityPluginBinding? = null
  private var handler: NutritionAIHandler? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    method = MethodChannel(flutterPluginBinding.binaryMessenger, "nutrition_ai/method")
    detectionChannel = EventChannel(flutterPluginBinding.binaryMessenger, "nutrition_ai/event/detection")
    // Initialize the statusChannel with the binary messenger and a unique channel name.
    statusChannel = EventChannel(flutterPluginBinding.binaryMessenger, "nutrition_ai/event/status")

    flutterPluginBinding.platformViewRegistry
      .registerViewFactory("native-preview-view", NativePreviewFactory())
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    method.setMethodCallHandler(null)
    detectionChannel.setStreamHandler(null)
    // Set the stream handler for statusChannel to null, stopping the event stream.
    statusChannel.setStreamHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding
    handler = NutritionAIHandler(activity!!.activity)
    method.setMethodCallHandler(handler)
    detectionChannel.setStreamHandler(handler)
    // Set the stream handler for statusChannel to the provided handler, enabling the event stream.
    statusChannel.setStreamHandler(handler)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    method.setMethodCallHandler(null)
    detectionChannel.setStreamHandler(null)
    // Set the stream handler for statusChannel to null, stopping the event stream.
    statusChannel.setStreamHandler(null)
    handler = null
    activity = null
  }

}
