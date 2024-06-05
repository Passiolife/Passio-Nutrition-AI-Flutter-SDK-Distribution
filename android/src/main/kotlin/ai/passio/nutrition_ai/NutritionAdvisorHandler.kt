package ai.passio.nutrition_ai

import ai.passio.nutrition_ai.converter.mapFromPassioResult
import ai.passio.nutrition_ai.converter.mapToPassioAdvisorResponse
import ai.passio.passiosdk.passiofood.NutritionAdvisor
import android.app.Activity
import android.graphics.BitmapFactory
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class NutritionAdvisorHandler(private val activity: Activity) : MethodCallHandler {
    @Suppress("UNCHECKED_CAST")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "configure" -> configure(call.arguments as String, result)
            "initConversation" -> initConversation(result)
            "sendMessage" -> sendMessage(call.arguments as String, result)
            "sendImage" -> sendImage(call.arguments as ByteArray, result)
            "fetchIngredients" -> fetchIngredients(call.arguments as HashMap<String, Any?>, result)
        }
    }

    private fun configure(key: String, result: MethodChannel.Result) {
        NutritionAdvisor.instance.configure(activity, key) { callback ->
            result.success(mapFromPassioResult(callback))
        }
    }

    private fun initConversation(result: MethodChannel.Result) {
        NutritionAdvisor.instance.initConversation { callback ->
            result.success(mapFromPassioResult(callback))
        }
    }

    private fun sendMessage(message: String, result: MethodChannel.Result) {
        NutritionAdvisor.instance.sendMessage(message) { callback ->
            result.success(mapFromPassioResult(callback))
        }
    }

    private fun sendImage(bytes: ByteArray, result: MethodChannel.Result) {
        val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
        NutritionAdvisor.instance.sendImage(bitmap) { callback ->
            result.success(mapFromPassioResult(callback))
        }
    }

    private fun fetchIngredients(map: Map<String, Any?>, result: MethodChannel.Result) {
        val response = mapToPassioAdvisorResponse(map)
        NutritionAdvisor.instance.fetchIngredients(response) { callback ->
            result.success(mapFromPassioResult(callback))
        }
    }
}