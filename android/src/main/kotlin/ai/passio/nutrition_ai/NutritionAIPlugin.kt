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
  private lateinit var advisorMethod : MethodChannel

  private lateinit var detectionChannel: EventChannel
  // Declared a lateinit variable to hold the EventChannel for status updates.
  private lateinit var statusChannel: EventChannel
  private lateinit var nutritionFactsChannel: EventChannel
  private lateinit var accountChannel: EventChannel

  private var activity: ActivityPluginBinding? = null
  private var handler: NutritionAIHandler? = null
  private var advisorHandler: NutritionAdvisorHandler? = null

  private val previewFactory = NativePreviewFactory()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    method = MethodChannel(flutterPluginBinding.binaryMessenger, "nutrition_ai/method")
    advisorMethod = MethodChannel(flutterPluginBinding.binaryMessenger, "nutrition_advisor/method")
    detectionChannel = EventChannel(flutterPluginBinding.binaryMessenger, "nutrition_ai/event/detection")
    // Initialize the statusChannel with the binary messenger and a unique channel name.
    statusChannel = EventChannel(flutterPluginBinding.binaryMessenger, "nutrition_ai/event/status")
    nutritionFactsChannel = EventChannel(flutterPluginBinding.binaryMessenger, "nutrition_ai/event/nutritionFact")
    accountChannel = EventChannel(flutterPluginBinding.binaryMessenger, "nutrition_ai/event/account")

    flutterPluginBinding.platformViewRegistry
      .registerViewFactory("native-preview-view", previewFactory)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    setStreamHandlers(false)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding
    handler = NutritionAIHandler(activity!!.activity, previewFactory)
    advisorHandler = NutritionAdvisorHandler(activity!!.activity)
    setStreamHandlers(true)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    setStreamHandlers(false)
    handler = null
    advisorHandler = null
    activity = null
  }

  private fun setStreamHandlers(enable: Boolean) {
    method.setMethodCallHandler(if (enable) handler else null)
    advisorMethod.setMethodCallHandler(if (enable) advisorHandler else null)
    detectionChannel.setStreamHandler(if (enable) handler else null)
    statusChannel.setStreamHandler(if (enable) handler else null)
    nutritionFactsChannel.setStreamHandler(if (enable) handler else null)
    accountChannel.setStreamHandler(if (enable) handler else null)
  }
}
