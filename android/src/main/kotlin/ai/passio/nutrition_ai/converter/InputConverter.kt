package ai.passio.nutrition_ai.converter

import ai.passio.passiosdk.core.config.PassioConfiguration
import ai.passio.passiosdk.core.icons.IconSize
import ai.passio.passiosdk.passiofood.FoodDetectionConfiguration
import ai.passio.passiosdk.passiofood.PassioID
import ai.passio.passiosdk.passiofood.PassioSDK
import ai.passio.passiosdk.passiofood.PassioSearchNutritionPreview
import ai.passio.passiosdk.passiofood.PassioSearchResult
import ai.passio.passiosdk.passiofood.data.model.PassioIDEntityType
import android.content.Context
import android.graphics.RectF
import android.net.Uri

@Suppress("UNCHECKED_CAST")
fun <T> Map<String, Any?>.mapContains(key: String, block: (value: T) -> Unit) {
    if (this.contains(key)) {
        block(this[key]!! as T)
    }
}

@Suppress("UNCHECKED_CAST")
fun <T> Map<String, Any?>.mapContainsOptional(key: String, block: (value: T?) -> Unit) {
    if (this.contains(key)) {
        block(this[key] as T?)
    }
}

fun mapToPassioConfiguration(context: Context, map: Map<String, Any?>): PassioConfiguration {
    return PassioConfiguration(context, map["key"] as String).apply {
        map.mapContains<Boolean>("sdkDownloadsModels") { this.sdkDownloadsModels = it }
        map.mapContains<Int>("debugMode") { this.debugMode = it }
        map.mapContains<Boolean>("allowInternetConnection") { this.allowInternetConnection = it }
        map.mapContainsOptional<List<String>>("filesLocalURLs") { files ->
            val uris = files?.map { Uri.parse(it) }
            this.localFiles = uris
        }
    }
}

fun mapToFoodDetectionConfiguration(map: Map<String, Any?>): FoodDetectionConfiguration {
    return FoodDetectionConfiguration().apply {
        map.mapContains<Boolean>("detectVisual") { this.detectVisual = it }
        map.mapContains<Boolean>("detectBarcodes") { this.detectBarcodes = it }
        map.mapContains<Boolean>("detectPackagedFood") { this.detectPackagedFood = it }
        map.mapContains<Boolean>("detectNutritionFacts") { this.detectNutritionFacts = it }
        map.mapContains<String>("framesPerSecond") {
            this.framesPerSecond = framesPerSecondFromString(it)
        }
    }
}

fun iconSizeFromString(iconString: String): IconSize {
    return when (iconString) {
        "px90" -> IconSize.PX90
        "px180" -> IconSize.PX180
        "px360" -> IconSize.PX360
        else -> throw java.lang.IllegalArgumentException("No known icon size: $iconString")
    }
}

fun entityTypeFromString(typeString: String): PassioIDEntityType {
    return when (typeString) {
        "group" -> PassioIDEntityType.group
        "item" -> PassioIDEntityType.item
        "recipe" -> PassioIDEntityType.recipe
        "barcode" -> PassioIDEntityType.barcode
        "packagedFoodCode" -> PassioIDEntityType.packagedFoodCode
        "nutritionFacts" -> PassioIDEntityType.nutritionFacts
        else -> throw java.lang.IllegalArgumentException("No known entity type: $typeString")
    }
}

fun framesPerSecondFromString(fps: String): PassioSDK.FramesPerSecond {
    return when (fps) {
        "one" -> PassioSDK.FramesPerSecond.ONE
        "two" -> PassioSDK.FramesPerSecond.TWO
        "three" -> PassioSDK.FramesPerSecond.MAX
        "four" -> PassioSDK.FramesPerSecond.MAX
        "max" -> PassioSDK.FramesPerSecond.MAX
        else -> throw java.lang.IllegalArgumentException("No known fps: $fps")
    }
}

fun mapToRectF(map: Map<String, Any?>): RectF {
    return RectF(
        (map["left"] as? Double)?.toFloat() ?: 0f,
        (map["top"] as? Double)?.toFloat() ?: 0f,
        ((map["left"] as? Double) ?: 0.0).toFloat() + ((map["width"] as? Double) ?: 0.0).toFloat(),
        ((map["top"] as? Double) ?: 0.0).toFloat() + ((map["height"] as? Double) ?: 0.0).toFloat(),
    )
}

fun mapToPassioSearchResult(map: Map<String, Any?>): PassioSearchResult {
    return PassioSearchResult(
        map["foodName"] as String,
        map["brandName"] as String,
        map["iconId"] as PassioID,
        map["score"] as Double,
        map["scoredName"] as String,
        map["labelId"] as String,
        map["type"] as String,
        map["resultId"] as String,
        mapToPassioSearchNutritionPreview(map["nutritionPreview"] as Map<String, Any?>),
    );
}

private  fun mapToPassioSearchNutritionPreview(map: Map<String, Any?>): PassioSearchNutritionPreview {
    return PassioSearchNutritionPreview(
        map["calories"] as Int,
        map["servingUnit"] as String,
        map["servingQuantity"] as Double,
        map["servingWeight"] as String
    );
}