package ai.passio.nutrition_ai.converter

import ai.passio.passiosdk.core.config.PassioConfiguration
import ai.passio.passiosdk.core.icons.IconSize
import ai.passio.passiosdk.passiofood.Barcode
import ai.passio.passiosdk.passiofood.FoodDetectionConfiguration
import ai.passio.passiosdk.passiofood.PassioFoodDataInfo
import ai.passio.passiosdk.passiofood.PassioID
import ai.passio.passiosdk.passiofood.PassioImageResolution
import ai.passio.passiosdk.passiofood.PassioSDK
import ai.passio.passiosdk.passiofood.PassioSearchNutritionPreview
import ai.passio.passiosdk.passiofood.data.measurement.Grams
import ai.passio.passiosdk.passiofood.data.measurement.KiloCalories
import ai.passio.passiosdk.passiofood.data.measurement.Kilograms
import ai.passio.passiosdk.passiofood.data.measurement.Micrograms
import ai.passio.passiosdk.passiofood.data.measurement.Milligrams
import ai.passio.passiosdk.passiofood.data.measurement.Milliliters
import ai.passio.passiosdk.passiofood.data.measurement.UnitEnergy
import ai.passio.passiosdk.passiofood.data.measurement.UnitMass
import ai.passio.passiosdk.passiofood.data.model.PassioAdvisorFoodInfo
import ai.passio.passiosdk.passiofood.data.model.PassioAdvisorResponse
import ai.passio.passiosdk.passiofood.data.model.PassioFoodAmount
import ai.passio.passiosdk.passiofood.data.model.PassioFoodItem
import ai.passio.passiosdk.passiofood.data.model.PassioFoodMetadata
import ai.passio.passiosdk.passiofood.data.model.PassioFoodOrigin
import ai.passio.passiosdk.passiofood.data.model.PassioIDEntityType
import ai.passio.passiosdk.passiofood.data.model.PassioIngredient
import ai.passio.passiosdk.passiofood.data.model.PassioNutrients
import ai.passio.passiosdk.passiofood.data.model.PassioServingSize
import ai.passio.passiosdk.passiofood.data.model.PassioServingUnit
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
        map.mapContains<Boolean>("remoteOnly") { this.remoteOnly = it }
        map.mapContainsOptional<List<String>>("filesLocalURLs") { files ->
            val uris = files?.map { Uri.parse(it) }
            this.localFiles = uris
        }
        map.mapContainsOptional<String?>("proxyUrl") { this.proxyUrl = it }
        map.mapContainsOptional<Map<String, String>?>("proxyHeaders") { this.proxyHeaders = it }
    }
}

fun mapToFoodDetectionConfiguration(map: Map<String, Any?>): FoodDetectionConfiguration {
    return FoodDetectionConfiguration().apply {
        map.mapContains<Boolean>("detectVisual") { this.detectVisual = it }
        map.mapContains<Boolean>("detectBarcodes") { this.detectBarcodes = it }
        map.mapContains<Boolean>("detectPackagedFood") { this.detectPackagedFood = it }
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

fun mapToFetchFoodItemForDataInfo(map: Map<String, Any?>): Triple<PassioFoodDataInfo, Double?, String?> {
    val foodDataInfo = map["foodDataInfo"] as Map<String, Any>
    val passioFoodDataInfo = mapToPassioFoodDataInfo(foodDataInfo)
    val servingQuantity = map["servingQuantity"] as? Double
    val servingUnit = map["servingUnit"] as? String
    return Triple(passioFoodDataInfo, servingQuantity, servingUnit)
}

fun mapToPassioFoodDataInfo(map: Map<String, Any?>): PassioFoodDataInfo {
    return PassioFoodDataInfo(
        map["refCode"] as String,
        map["foodName"] as String,
        map["brandName"] as String,
        map["iconId"] as PassioID,
        map["score"] as Double,
        map["scoredName"] as String,
        map["labelId"] as String,
        map["type"] as String,
        map["resultId"] as String,
        map["isShortName"] as Boolean,
        mapToPassioSearchNutritionPreview(map["nutritionPreview"] as Map<String, Any?>),
        map["tags"] as List<String>?,
    )
}

private fun mapToPassioSearchNutritionPreview(map: Map<String, Any?>): PassioSearchNutritionPreview {
    return PassioSearchNutritionPreview(
        map["calories"] as Int,
        map["carbs"] as Double,
        map["protein"] as Double,
        map["fat"] as Double,
        map["fiber"] as Double,
        map["servingUnit"] as String,
        map["servingQuantity"] as Double,
        map["weightUnit"] as String,
        map["weightQuantity"] as Double,
    )
}

fun mapToPassioAdvisorResponse(map: Map<String, Any?>): PassioAdvisorResponse {
    var tools: List<String>? = null
    var extractedIngredients: List<PassioAdvisorFoodInfo>? = null

    map.mapContainsOptional<List<String>?>("tools") { tool ->
        tools = tool
    }
    map.mapContainsOptional<List<PassioAdvisorFoodInfo>?>("extractedIngredients") { ingredients ->
        extractedIngredients = ingredients
    }

    return PassioAdvisorResponse(
        map["threadId"] as String,
        map["messageId"] as String,
        map["markupContent"] as String,
        map["rawContent"] as String,
        tools,
        extractedIngredients
    )
}

fun passioImageResolutionFromString(resolutionString: String): PassioImageResolution {
    return when (resolutionString) {
        "res_512" -> PassioImageResolution.RES_512
        "res_1080" -> PassioImageResolution.RES_1080
        "full" -> PassioImageResolution.FULL
        else -> throw java.lang.IllegalArgumentException("No known PassioImageResolution: $resolutionString")
    }
}

fun mapToPassioFoodItem(map: Map<String, Any?>): PassioFoodItem {
    val id = map["id"] as String
    val refCode = map["refCode"] as String
    val name = map["name"] as String
    val details = map["details"] as String
    val iconId = map["iconId"] as String
    val amount = mapToPassioFoodAmount(map["amount"] as Map<String, Any?>)

    // Ingredients
    val ingredientsInMap = map["ingredients"] as List<Map<String, Any?>>
    val ingredients = ingredientsInMap.map { mapToPassioIngredient(it) }

    return PassioFoodItem(id, refCode, name, details, iconId, amount, ingredients)
}

fun mapToPassioIngredient(map: Map<String, Any?>): PassioIngredient {
    val id = map["id"] as String
    val refCode = map["refCode"] as String
    val name = map["name"] as String
    val iconId = map["iconId"] as String
    val amount = mapToPassioFoodAmount(map["amount"] as Map<String, Any?>)
    val referenceNutrients = mapToPassioNutrients(map["referenceNutrients"] as Map<String, Any?>)
    val metadata = mapToPassioFoodMetadata(map["metadata"] as Map<String, Any?>)

    return PassioIngredient(id, refCode, name, iconId, amount, referenceNutrients, metadata)
}

fun mapToPassioFoodAmount(map: Map<String, Any?>): PassioFoodAmount {
    // servingSizes
    val servingSizesInMap = map["servingSizes"] as List<Map<String, Any?>>
    val servingSizes = servingSizesInMap.map { mapToPassioServingSize(it) }

    // servingSizes
    val servingUnitsInMap = map["servingUnits"] as List<Map<String, Any?>>
    val servingUnits = servingUnitsInMap.map { mapToPassioServingUnit(it) }

    val selectedUnit = map["selectedUnit"] as String
    val selectedQuantity = map["selectedQuantity"] as Double

    val amount = PassioFoodAmount(servingSizes, servingUnits)
    amount.selectedUnit = selectedUnit
    amount.selectedQuantity = selectedQuantity

    return amount
}

fun mapToPassioServingSize(map: Map<String, Any?>): PassioServingSize {
    val quantity = map["quantity"] as Double
    val unitName = map["unitName"] as String
    return PassioServingSize(quantity, unitName)
}

fun mapToPassioServingUnit(map: Map<String, Any?>): PassioServingUnit {
    val unitName = map["unitName"] as String
    val weight = mapToUnitMass(map["weight"] as Map<String, Any?>)!!
    return PassioServingUnit(unitName, weight)
}

fun mapToUnitMass(map: Map<String, Any?>?): UnitMass? {
    if(map == null) return null
    val value = map["value"] as Double

    val unitInString = map["unit"] as String
    val unit = unitInString.unitFromString()

    return UnitMass(unit, value)
}

fun mapToUnitEnergy(map: Map<String, Any?>?): UnitEnergy? {
    if(map == null) return null
    val value = map["value"] as Double

    val unitInString = map["unit"] as String
    val unit = unitInString.unitFromString()

    return UnitEnergy(unit, value)
}

fun mapToUnitIU(map: Map<String, Any?>?): Double? {
    if(map == null) return null
    val value = map["value"] as Double

    return  value
}

private fun String.unitFromString(): ai.passio.passiosdk.passiofood.data.measurement.Unit {
    return when (this) {
        "kilograms" -> Kilograms
        "grams" -> Grams
        "milligrams" -> Milligrams
        "micrograms" -> Micrograms
        "milliliter" -> Milliliters
        "kilocalories" -> KiloCalories
        else -> throw java.lang.IllegalArgumentException("No known unit: $this")
    }
}

fun mapToPassioNutrients(map: Map<String, Any?>): PassioNutrients {
    val weight = mapToUnitMass(map["weight"] as Map<String, Any?>)!!
    val alcohol = mapToUnitMass(map["alcohol"] as? Map<String, Any?>)
    val calcium = mapToUnitMass(map["calcium"] as? Map<String, Any?>)
    val calories = mapToUnitEnergy(map["calories"] as? Map<String, Any?>)
    val carbs = mapToUnitMass(map["carbs"] as? Map<String, Any?>)
    val cholesterol = mapToUnitMass(map["cholesterol"] as? Map<String, Any?>)
    val chromium = mapToUnitMass(map["chromium"] as? Map<String, Any?>)
    val fat = mapToUnitMass(map["fat"] as? Map<String, Any?>)
    val fibers = mapToUnitMass(map["fibers"] as? Map<String, Any?>)
    val folicAcid = mapToUnitMass(map["folicAcid"] as? Map<String, Any?>)
    val iodine = mapToUnitMass(map["iodine"] as? Map<String, Any?>)
    val iron = mapToUnitMass(map["iron"] as? Map<String, Any?>)
    val magnesium = mapToUnitMass(map["magnesium"] as? Map<String, Any?>)
    val monounsaturatedFat = mapToUnitMass(map["monounsaturatedFat"] as? Map<String, Any?>)
    val phosphorus = mapToUnitMass(map["phosphorus"] as? Map<String, Any?>)
    val polyunsaturatedFat = mapToUnitMass(map["polyunsaturatedFat"] as? Map<String, Any?>)
    val potassium = mapToUnitMass(map["potassium"] as? Map<String, Any?>)
    val proteins = mapToUnitMass(map["proteins"] as? Map<String, Any?>)
    val satFat = mapToUnitMass(map["satFat"] as? Map<String, Any?>)
    val selenium = mapToUnitMass(map["selenium"] as? Map<String, Any?>)
    val sodium = mapToUnitMass(map["sodium"] as? Map<String, Any?>)
    val sugars = mapToUnitMass(map["sugars"] as? Map<String, Any?>)
    val sugarsAdded = mapToUnitMass(map["sugarsAdded"] as? Map<String, Any?>)
    val sugarAlcohol = mapToUnitMass(map["sugarAlcohol"] as? Map<String, Any?>)
    val transFat = mapToUnitMass(map["transFat"] as? Map<String, Any?>)
    val vitaminA = mapToUnitIU(map["vitaminA"] as? Map<String, Any?>)
    val vitaminB6 = mapToUnitMass(map["vitaminB6"] as? Map<String, Any?>)
    val vitaminB12 = mapToUnitMass(map["vitaminB12"] as? Map<String, Any?>)
    val vitaminB12Added = mapToUnitMass(map["vitaminB12Added"] as? Map<String, Any?>)
    val vitaminC = mapToUnitMass(map["vitaminC"] as? Map<String, Any?>)
    val vitaminD = mapToUnitMass(map["vitaminD"] as? Map<String, Any?>)
    val vitaminE = mapToUnitMass(map["vitaminE"] as? Map<String, Any?>)
    val vitaminEAdded = mapToUnitMass(map["vitaminEAdded"] as? Map<String, Any?>)
    val vitaminKDihydrophylloquinone =
        mapToUnitMass(map["vitaminKDihydrophylloquinone"] as? Map<String, Any?>)
    val vitaminKMenaquinone4 = mapToUnitMass(map["vitaminKMenaquinone4"] as? Map<String, Any?>)
    val vitaminKPhylloquinone = mapToUnitMass(map["vitaminKPhylloquinone"] as? Map<String, Any?>)
    val vitaminARAE = mapToUnitMass(map["vitaminARAE"] as? Map<String, Any?>)
    val zinc = mapToUnitMass(map["zinc"] as? Map<String, Any?>)

    return PassioNutrients(
        weight,
        fat,
        satFat,
        monounsaturatedFat,
        polyunsaturatedFat,
        proteins,
        carbs,
        calories,
        cholesterol,
        sodium,
        fibers,
        transFat,
        sugars,
        sugarsAdded,
        alcohol,
        iron,
        vitaminC,
        vitaminD,
        vitaminB6,
        vitaminB12,
        vitaminB12Added,
        vitaminE,
        vitaminEAdded,
        iodine,
        calcium,
        potassium,
        magnesium,
        phosphorus,
        sugarAlcohol,
        vitaminA,
        vitaminARAE,
        vitaminKPhylloquinone,
        vitaminKMenaquinone4,
        vitaminKDihydrophylloquinone,
        zinc,
        chromium,
        selenium,
        folicAcid,
    )
}

fun mapToPassioFoodMetadata(map: Map<String, Any?>): PassioFoodMetadata {
    val foodOriginsInMap = map["foodOrigins"] as List<Map<String, Any?>>?
    val foodOrigins = foodOriginsInMap?.map { mapToPassioFoodOrigin(it) }

    val barcode = map["barcode"] as Barcode?
    val ingredientsDescription = map["ingredientsDescription"] as String?
    val tags = map["ingredientsDescription"] as List<String>?

    return PassioFoodMetadata(foodOrigins, barcode, ingredientsDescription, tags)
}

fun mapToPassioFoodOrigin(map: Map<String, Any?>): PassioFoodOrigin {
    val id = map["id"] as String
    val source = map["source"] as String
    val licenseCopy = map["licenseCopy"] as String?

    return PassioFoodOrigin(id, source, licenseCopy)
}