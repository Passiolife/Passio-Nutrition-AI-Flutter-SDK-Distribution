package ai.passio.nutrition_ai

import ai.passio.nutrition_ai.converter.*
import ai.passio.passiosdk.core.config.Bridge
import ai.passio.passiosdk.core.config.PassioConfiguration
import ai.passio.passiosdk.core.config.PassioMode
import ai.passio.passiosdk.passiofood.Barcode
import ai.passio.passiosdk.passiofood.FoodCandidates
import ai.passio.passiosdk.passiofood.FoodRecognitionListener
import ai.passio.passiosdk.passiofood.PackagedFoodCode
import ai.passio.passiosdk.passiofood.PassioID
import ai.passio.passiosdk.passiofood.PassioSDK
import ai.passio.passiosdk.passiofood.nutritionfacts.PassioNutritionFacts
import android.app.Activity
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class NutritionAIHandler(
    private val activity: Activity
) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    @Suppress("UNCHECKED_CAST")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getSDKVersion" -> getSDKVersion(result)
            "configureSDK" -> configureSDK(call.arguments as HashMap<String, Any>, result)
            "fetchIconFor" -> fetchIconFor(call.arguments as HashMap<String, Any>, result)
            "lookupIconsFor" -> lookupIconsFor(call.arguments as HashMap<String, Any>, result)
            "lookupPassioAttributesFor" -> lookupPassioAttributesFor(call.arguments as String, result)
            "searchForFood" -> searchForFood(call.arguments as String, result)
            "fetchAttributesForBarcode" -> fetchAttributesForBarcode(call.arguments as String, result)
            "fetchAttributesForPackagedFoodCode" -> fetchAttributesForPackagedFoodCode(call.arguments as String, result)
            "detectFoodIn" -> detectFoodIn(call.arguments as HashMap<String, Any>, result)
            "fetchTagsFor" -> fetchTagsFor(call.arguments as String, result)
            "iconURLFor" -> fetchURLFor(call.arguments as HashMap<String, Any>, result)
            "transformCGRectForm" -> transformRect(call.arguments as HashMap<String, Any>, result)
        }
    }

    private fun configureSDK(configMap: HashMap<String, Any>, callback: MethodChannel.Result) {
        val config = mapToPassioConfiguration(activity.applicationContext, configMap)
        config.bridge = Bridge.FLUTTER

        PassioSDK.instance.configure(config) { status ->
            val statusMap = mapFromPassioStatus(status)

            when (status.mode) {
                PassioMode.NOT_READY -> callback.success(statusMap)
                PassioMode.FAILED_TO_CONFIGURE -> callback.success(statusMap)
                PassioMode.IS_BEING_CONFIGURED -> callback.success(statusMap)
                PassioMode.IS_DOWNLOADING_MODELS -> { /* NO-OP */
                }

                PassioMode.IS_READY_FOR_DETECTION -> callback.success(statusMap)
            }
        }
    }

    private fun fetchIconFor(configMap: HashMap<String, Any>, callback: MethodChannel.Result) {
        val passioID = configMap["passioID"] as String
        val iconSizeString = configMap["iconSize"] as String

        val icon = iconSizeFromString(iconSizeString)

        PassioSDK.instance.fetchIconFor(activity.applicationContext, passioID, icon) inner@{ drawable ->
            if (drawable == null) {
                callback.success(null)
                return@inner
            }

            val bitmap = (drawable as BitmapDrawable).bitmap
            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            val byteArray: ByteArray = stream.toByteArray()

            val imageMap = mutableMapOf<String, Any>()
            imageMap["width"] = bitmap.width
            imageMap["height"] = bitmap.height
            imageMap["pixels"] = byteArray

            bitmap.recycle()

            callback.success(imageMap)
        }
    }

    private fun lookupIconsFor(configMap: HashMap<String, Any>, callback: MethodChannel.Result) {
        val passioID = configMap["passioID"] as String
        val iconSizeString = configMap["iconSize"] as String
        val iconSize = iconSizeFromString(iconSizeString)
        val typeString = configMap["type"] as String
        val type = entityTypeFromString(typeString)

        val result = PassioSDK.instance.lookupIconsFor(activity.applicationContext, passioID, iconSize, type)

        val firstBitmap = (result.first as BitmapDrawable).bitmap
        val firstStream = ByteArrayOutputStream()
        firstBitmap.compress(Bitmap.CompressFormat.PNG, 100, firstStream)
        val firstArray: ByteArray = firstStream.toByteArray()

        val secondBitmap = (result.second as? BitmapDrawable)?.bitmap
        val secondArray: ByteArray? = secondBitmap?.let {
            val secondStream = ByteArrayOutputStream()
            it.compress(Bitmap.CompressFormat.PNG, 100, secondStream)
            secondStream.toByteArray()
        }

        val imageMapFirst = mutableMapOf<String, Any>()
        imageMapFirst["width"] = firstBitmap.width
        imageMapFirst["height"] = firstBitmap.height
        imageMapFirst["pixels"] = firstArray

        val imageMapSecond = secondBitmap?.let {
            val map = mutableMapOf<String, Any?>()
            map["width"] = it.width
            map["height"] = it.height
            map["pixels"] = secondArray!!
            map
        }

        val resultMap = mutableMapOf<String, Any?>()
        resultMap["defaultIcon"] = imageMapFirst
        resultMap["cachedIcon"] = imageMapSecond

        firstBitmap.recycle()
        secondBitmap?.recycle()

        callback.success(resultMap)
    }

    @Suppress("UNCHECKED_CAST")
    override fun onListen(arguments: Any, events: EventChannel.EventSink) {
        val argMap = arguments as HashMap<String, Any>
        when (argMap["method"]) {
            "startFoodDetection" -> startFoodDetection(argMap["args"] as Map<String, Any>, events)
        }
    }

    @Suppress("UNCHECKED_CAST")
    override fun onCancel(arguments: Any) {
        val argMap = arguments as HashMap<String, Any>
        when (argMap["method"]) {
            "startFoodDetection" -> PassioSDK.instance.stopFoodDetection()
        }
    }

    private fun startFoodDetection(args: Map<String, Any>, events: EventChannel.EventSink) {
        val config = mapToFoodDetectionConfiguration(args)
        PassioSDK.instance.startFoodDetection(object : FoodRecognitionListener {
            override fun onRecognitionResults(
                candidates: FoodCandidates,
                image: Bitmap?,
                nutritionFacts: PassioNutritionFacts?
            ) {
                events.success(mapFromFoodCandidates(candidates))
            }
        }, config)
    }

    private fun lookupPassioAttributesFor(passioID: PassioID, callback: MethodChannel.Result) {
        val attrs = PassioSDK.instance.lookupPassioAttributesFor(passioID)
        if (attrs == null) {
            callback.success(null)
            return
        }

        val attrMap = mapFromPassioIDAttributes(attrs)
        callback.success(attrMap)
    }

    private fun searchForFood(byText: String, callback: MethodChannel.Result) {
        PassioSDK.instance.searchForFood(byText) { list ->
            val returnList = list.take(100).map { mapFromSearchResult(it) }
            callback.success(returnList)
        }
    }

    private fun fetchAttributesForBarcode(barcode: Barcode, callback: MethodChannel.Result) {
        PassioSDK.instance.fetchPassioIDAttributesForBarcode(barcode) { attrs ->
            if (attrs == null) {
                callback.success(null)
                return@fetchPassioIDAttributesForBarcode
            }

            val attrMap = mapFromPassioIDAttributes(attrs)
            callback.success(attrMap)
        }
    }

    private fun fetchAttributesForPackagedFoodCode(code: PackagedFoodCode, callback: MethodChannel.Result) {
        PassioSDK.instance.fetchPassioIDAttributesForPackagedFood(code) { attrs ->
            if (attrs == null) {
                callback.success(null)
                return@fetchPassioIDAttributesForPackagedFood
            }

            val attrMap = mapFromPassioIDAttributes(attrs)
            callback.success(attrMap)
        }
    }

    private fun getSDKVersion(callback: MethodChannel.Result) {
        callback.success(PassioSDK.getVersion())
    }

    private fun fetchTagsFor(passioID: PassioID, callback: MethodChannel.Result) {
        PassioSDK.instance.fetchTagsFor(passioID) { tags ->
            callback.success(tags)
        }
    }

    private fun detectFoodIn(args: HashMap<String, Any>, callback: MethodChannel.Result) {
        val bytes = args["bytes"] as ByteArray
        val extension = args["extension"] as String
        val config = if (args.containsKey("config")) {
            mapToFoodDetectionConfiguration(args["config"] as HashMap<String, Any>)
        } else {
            null
        }
        val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)

        PassioSDK.instance.detectFoodIn(bitmap, config) inner@{ candidates ->
            if (candidates == null) {
                callback.success(null)
                return@inner
            }

            callback.success(mapFromFoodCandidates(candidates))
        }
    }

    private fun fetchURLFor(args: HashMap<String, Any>, callback: MethodChannel.Result) {
        val passioID = args["passioID"] as String
        val iconSizeString = args["iconSize"] as String
        val icon = iconSizeFromString(iconSizeString)

        val url = PassioSDK.instance.iconURLFor(activity.applicationContext, passioID, icon)
        callback.success(url)
    }

    private fun transformRect(args: HashMap<String, Any>, callback: MethodChannel.Result) {
        val boundingBox = mapToRectF(args["boundingBox"] as Map<String, Any?>)
        val toRect = mapToRectF(args["toRect"] as Map<String, Any?>)

        val resultRect = PassioSDK.instance.boundingBoxToViewTransform(
            boundingBox,
            toRect.width().toInt(),
            toRect.height().toInt(),
        )

        callback.success(
            doubleArrayOf(
                resultRect.left.toDouble(),
                resultRect.top.toDouble(),
                resultRect.width().toDouble(),
                resultRect.height().toDouble()
            )
        )
    }
}