package ai.passio.nutrition_ai.converter

import ai.passio.nutrition_ai.R
import ai.passio.nutrition_ai.utils.toByteArray
import ai.passio.passiosdk.core.config.PassioMode
import ai.passio.passiosdk.core.config.PassioSDKError
import ai.passio.passiosdk.core.config.PassioStatus
import ai.passio.passiosdk.passiofood.BarcodeCandidate
import ai.passio.passiosdk.passiofood.DetectedCandidate
import ai.passio.passiosdk.passiofood.FoodCandidates
import ai.passio.passiosdk.passiofood.PackagedFoodCandidate
import ai.passio.passiosdk.passiofood.PassioID
import ai.passio.passiosdk.passiofood.PassioNutrient
import ai.passio.passiosdk.passiofood.data.measurement.Grams
import ai.passio.passiosdk.passiofood.data.measurement.KiloCalories
import ai.passio.passiosdk.passiofood.data.measurement.Kilograms
import ai.passio.passiosdk.passiofood.data.measurement.Micrograms
import ai.passio.passiosdk.passiofood.data.measurement.Milligrams
import ai.passio.passiosdk.passiofood.data.measurement.Milliliters
import ai.passio.passiosdk.passiofood.data.measurement.Unit
import ai.passio.passiosdk.passiofood.data.measurement.UnitEnergy
import ai.passio.passiosdk.passiofood.data.measurement.UnitMass
import ai.passio.passiosdk.passiofood.data.model.PassioAlternative
import ai.passio.passiosdk.passiofood.data.model.PassioFoodItemData
import ai.passio.passiosdk.passiofood.data.model.PassioFoodOrigin
import ai.passio.passiosdk.passiofood.data.model.PassioFoodRecipe
import ai.passio.passiosdk.passiofood.data.model.PassioIDAttributes
import ai.passio.passiosdk.passiofood.data.model.PassioIDEntityType
import ai.passio.passiosdk.passiofood.data.model.PassioServingSize
import ai.passio.passiosdk.passiofood.data.model.PassioServingUnit
import android.content.Context
import android.graphics.Bitmap
import android.net.Uri

fun mapFromPassioStatus(status: PassioStatus): Map<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map["debugMessage"] = status.debugMessage
    map["activeModels"] = status.activeModels
    map["missingFiles"] = status.missingFiles
    map["mode"] = status.mode.toPlatformString()
    map["error"] = status.error?.toPlatformString()
    return map
}

private fun PassioMode.toPlatformString(): String {
    return when (this) {
        PassioMode.NOT_READY -> "notReady"
        PassioMode.FAILED_TO_CONFIGURE -> "failedToConfigure"
        PassioMode.IS_BEING_CONFIGURED -> "isBeingConfigured"
        PassioMode.IS_DOWNLOADING_MODELS -> "isDownloadingModels"
        PassioMode.IS_READY_FOR_DETECTION -> "isReadyForDetection"
    }
}

private fun PassioSDKError.toPlatformString(): String {
    return when (this) {
        PassioSDKError.MIN_SDK_VERSION -> "minSDKVersion"
        PassioSDKError.KEY_NOT_VALID -> "keyNotValid"
        PassioSDKError.MODELS_NOT_VALID -> "modelsNotValid"
        PassioSDKError.LICENSE_KEY_HAS_EXPIRED -> "licensedKeyHasExpired"
        PassioSDKError.LICENSE_DECODING_ERROR -> "licenseDecodingError"
        PassioSDKError.MODELS_DOWNLOAD_FAILED -> "modelsDownloadFailed"
        PassioSDKError.NO_INTERNET_CONNECTION -> "noInternetConnection"
        PassioSDKError.NO_MODELS_FILES_FOUND -> "noModelsFilesFound"
        PassioSDKError.NOT_LICENSED_FOR_THIS_PROJECT -> "notLicensedForThisProject"
        PassioSDKError.MISSING_DEPENDENCY -> "missingDependency"
    }
}

fun mapFromFoodCandidates(candidates: FoodCandidates): Map<String, Any?> {
    val candidatesMap = mutableMapOf<String, Any?>()
    candidatesMap["detectedCandidate"] = candidates.detectedCandidates?.map {
        mapFromDetectedCandidate(it)
    }
    candidatesMap["barcodeCandidates"] = candidates.barcodeCandidates?.map {
        mapFromBarcodeCandidate(it)
    }
    candidatesMap["packagedFoodCandidates"] = candidates.packagedFoodCandidates?.map {
        mapFromPackagedFoodCode(it)
    }
    return candidatesMap
}

fun mapFromPackagedFoodCode(candidate: PackagedFoodCandidate): Map<String, Any?> {
    val candidateMap = mutableMapOf<String, Any?>()
    candidateMap["packagedFoodCode"] = candidate.packagedFoodCode
    candidateMap["confidence"] = candidate.confidence
    return candidateMap
}

fun mapFromBarcodeCandidate(candidate: BarcodeCandidate): Map<String, Any?> {
    val candidateMap = mutableMapOf<String, Any?>()
    candidateMap["value"] = candidate.barcode
    candidateMap["boundingBox"] = arrayListOf(
        candidate.boundingBox.left,
        candidate.boundingBox.top,
        candidate.boundingBox.width(),
        candidate.boundingBox.height(),
    )
    return candidateMap
}

private fun mapFromDetectedCandidate(candidate: DetectedCandidate): Map<String, Any?> {
    val candidateMap = mutableMapOf<String, Any?>()
    candidateMap["passioID"] = candidate.passioID
    candidateMap["confidence"] = candidate.confidence
    candidateMap["boundingBox"] = arrayListOf(
        candidate.boundingBox.left,
        candidate.boundingBox.top,
        candidate.boundingBox.width(),
        candidate.boundingBox.height(),
    )
    return candidateMap
}

fun mapFromAlternatives(alternative: PassioAlternative): Map<String, Any?> {
    val alternativeMap = mutableMapOf<String, Any?>()
    alternativeMap["passioID"] = alternative.passioID
    alternativeMap["name"] = alternative.name
    alternativeMap["quantity"] = alternative.number
    alternativeMap["unitName"] = alternative.unit
    return alternativeMap
}

fun mapFromServingSize(servingSize: PassioServingSize): Map<String, Any?> {
    val servingSizeMap = mutableMapOf<String, Any?>()
    servingSizeMap["quantity"] = servingSize.quantity
    servingSizeMap["unitName"] = servingSize.unitName
    return servingSizeMap
}

fun mapFromServingUnit(servingUnit: PassioServingUnit): Map<String, Any?> {
    val servingUnitMap = mutableMapOf<String, Any?>()
    servingUnitMap["unitName"] = servingUnit.unitName
    servingUnitMap["weight"] = mapFromUnitMass(servingUnit.weight)
    return servingUnitMap
}

private fun mapFromUnitMass(unitMass: UnitMass?): Map<String, Any?>? {
    if (unitMass == null) return null
    val unitMassMap = mutableMapOf<String, Any?>()
    unitMassMap["unit"] = unitMass.unit.unitString()
    unitMassMap["value"] = unitMass.value
    return unitMassMap
}

private fun mapFromUnitEnergy(unitEnergy: UnitEnergy?): Map<String, Any?>? {
    if (unitEnergy == null) return null
    val unitEnergyMap = mutableMapOf<String, Any?>()
    unitEnergyMap["unit"] = unitEnergy.unit.unitString()
    unitEnergyMap["value"] = unitEnergy.value
    return unitEnergyMap
}

private fun mapFromUnitIU(value: Double?): Map<String, Any?>? {
    if (value == null) return null
    val unitEnergyMap = mutableMapOf<String, Any?>()
    unitEnergyMap["unit"] = "iu"
    unitEnergyMap["value"] = value
    return unitEnergyMap
}

private fun Unit.unitString(): String {
    return when (this) {
        is Kilograms -> "kilograms"
        is Grams -> "grams"
        is Milligrams -> "milligrams"
        is Micrograms -> "micrograms"
        is KiloCalories -> "kilocalories"
        is Milliliters -> "grams"
        else -> throw java.lang.IllegalArgumentException("No known unit: $this")
    }
}

fun mapFromFoodOrigin(origin: PassioFoodOrigin): Map<String, Any?> {
    val originMap = mutableMapOf<String, Any?>()
    originMap["id"] = origin.id
    originMap["source"] = origin.source
    originMap["licenseCopy"] = origin.licenseCopy
    return originMap
}

fun mapFromFoodItemData(data: PassioFoodItemData): Map<String, Any?> {
    val dataMap = mutableMapOf<String, Any?>()
    val originalQuantity = data.selectedQuantity
    val originalUnit = data.selectedUnit
    dataMap["passioID"] = data.passioID
    dataMap["name"] = data.name
    dataMap["selectedQuantity"] = data.selectedQuantity
    dataMap["selectedUnit"] = data.selectedUnit
    dataMap["entityType"] = data.entityType.name
    dataMap["servingUnits"] = data.servingUnits.map { mapFromServingUnit(it) }
    dataMap["servingSizes"] = data.servingSizes.map { mapFromServingSize(it) }
    dataMap["ingredientsDescription"] = data.ingredientsDescription
    dataMap["barcode"] = data.barcode
    dataMap["foodOrigins"] = data.foodOrigins?.map { mapFromFoodOrigin(it) }
    dataMap["referenceWeight"] = mapFromUnitMass(data.referenceWeight)
    dataMap["parents"] = data.parents?.map { mapFromAlternatives(it) }
    dataMap["children"] = data.children?.map { mapFromAlternatives(it) }
    dataMap["siblings"] = data.siblings?.map { mapFromAlternatives(it) }
    dataMap["tags"] = data.tags
    // Map the nutrient per 100 grams
    data.setServingSize("gram", 100.0)
    dataMap["calories"] = mapFromUnitEnergy(data.totalCalories())
    dataMap["carbs"] = mapFromUnitMass(data.totalCarbs())
    dataMap["fat"] = mapFromUnitMass(data.totalFat())
    dataMap["proteins"] = mapFromUnitMass(data.totalProtein())
    dataMap["saturatedFat"] = mapFromUnitMass(data.totalSatFat())
    dataMap["transFat"] = mapFromUnitMass(data.totalTransFat())
    dataMap["monounsaturatedFat"] = mapFromUnitMass(data.totalMonounsaturatedFat())
    dataMap["polyunsaturatedFat"] = mapFromUnitMass(data.totalPolyunsaturatedFat())
    dataMap["cholesterol"] = mapFromUnitMass(data.totalCholesterol())
    dataMap["sodium"] = mapFromUnitMass(data.totalSodium())
    dataMap["fibers"] = mapFromUnitMass(data.totalFibers())
    dataMap["sugars"] = mapFromUnitMass(data.totalSugars())
    dataMap["sugarsAdded"] = mapFromUnitMass(data.totalSugarsAdded())
    dataMap["vitaminD"] = mapFromUnitMass(data.totalVitaminD())
    dataMap["calcium"] = mapFromUnitMass(data.totalCalcium())
    dataMap["iron"] = mapFromUnitMass(data.totalIron())
    dataMap["potassium"] = mapFromUnitMass(data.totalPotassium())
    dataMap["vitaminA"] = mapFromUnitIU(data.totalVitaminA())
    dataMap["vitaminC"] = mapFromUnitMass(data.totalVitaminC())
    dataMap["alcohol"] = mapFromUnitMass(data.totalAlcohol())
    dataMap["sugarAlcohol"] = mapFromUnitMass(data.totalSugarAlcohol())
    dataMap["vitaminB12Added"] = mapFromUnitMass(data.totalVitaminB12Added())
    dataMap["vitaminB12"] = mapFromUnitMass(data.totalVitaminB12())
    dataMap["vitaminB6"] = mapFromUnitMass(data.totalVitaminB6())
    dataMap["vitaminE"] = mapFromUnitMass(data.totalVitaminE())
    dataMap["vitaminEAdded"] = mapFromUnitMass(data.totalVitaminEAdded())
    dataMap["magnesium"] = mapFromUnitMass(data.totalMagnesium())
    dataMap["phosphorus"] = mapFromUnitMass(data.totalPhosphorus())
    dataMap["iodine"] = mapFromUnitMass(data.totalIodine())
    data.setServingSize(originalUnit, originalQuantity)
    return dataMap
}

fun mapFromPassioIDAttributes(attrs: PassioIDAttributes): Map<String, Any?> {
    val attrMap = mutableMapOf<String, Any?>()
    attrMap["passioID"] = attrs.passioID
    attrMap["name"] = attrs.name
    attrMap["entityType"] = attrs.entityType.name
    attrMap["foodItem"] = if (attrs.passioFoodItemData != null) mapFromFoodItemData(attrs.passioFoodItemData!!) else null
    attrMap["recipe"] = if (attrs.passioFoodRecipe != null) mapFromPassioFoodRecipe(attrs.passioFoodRecipe!!) else null
    attrMap["parents"] = attrs.parents?.map { mapFromAlternatives(it) }
    attrMap["siblings"] = attrs.siblings?.map { mapFromAlternatives(it) }
    attrMap["children"] = attrs.children?.map { mapFromAlternatives(it) }
    return attrMap
}

fun mapFromPassioFoodRecipe(recipe: PassioFoodRecipe): Map<String, Any?> {
    val recipeMap = mutableMapOf<String, Any?>()
    recipeMap["passioID"] = recipe.passioID
    recipeMap["name"] = recipe.name
    recipeMap["selectedQuantity"] = recipe.selectedQuantity
    recipeMap["selectedUnit"] = recipe.selectedUnit
    recipeMap["servingUnits"] = recipe.servingUnits.map { mapFromServingUnit(it) }
    recipeMap["servingSizes"] = recipe.servingSizes.map { mapFromServingSize(it) }
    recipeMap["foodItems"] = recipe.foodItems.map { mapFromFoodItemData(it) }
    return recipeMap
}

fun mapFromSearchResult(result: Pair<PassioID, String>): Map<String, Any?> {
    val searchMap = mutableMapOf<String, Any?>()
    searchMap["passioID"] = result.first
    searchMap["name"] = result.second
    return searchMap
}

fun mapFromBitmap(image: Bitmap?): MutableMap<String, Any?>? {
    // Checking if the 'image' is not null before performing operations
    val byteArray: ByteArray? = image?.toByteArray()

    // Creating a map from image and byteArray properties if 'image' is not null
    return image?.let {
        // Initializing a mutable map to store image properties
        val map = mutableMapOf<String, Any?>()

        // Adding width, height, and pixel data to the map
        map["width"] = it.width
        map["height"] = it.height
        map["pixels"] = byteArray!!

        // The resulting map containing image properties
        map
    }
}

/// Maps the information from a completed downloading file to a [Map].
///
/// Parameters:
/// - [fileUri]: The URI of the completed file.
/// - [filesLeft]: The number of files left to download.
///
/// Returns a [Map] containing the mapped information.
fun mapFromCompletedDownloadingFile(fileUri: Uri, filesLeft: Int): Map<String, Any?> {
    val downloadMap = mutableMapOf<String, Any?>()
    downloadMap["fileUri"] = fileUri.path
    downloadMap["filesLeft"] = filesLeft
    return downloadMap
}

/**
 * This function takes an `event` and `data` as parameters and maps them into a
 * `Map` representing the structure of PassioStatusListener events.
 *
 * @param event The type of event (e.g., "onPassioStatusChanged").
 * @param data The data associated with the event. It can be of any type.
 * @return A `Map` containing the event type and associated data.
 */
fun mapFromPassioStatusListener(event: String, data: Any?): Map<String, Any?> {
    val statusMap = mutableMapOf<String, Any?>()
    statusMap["event"] = event
    statusMap["data"] = data
    return statusMap
}

/**
 * Maps a [PassioNutrient] object to a [Map] for serialization.
 *
 * @param nutrient The [PassioNutrient] object to be mapped.
 * @return A [Map] containing the serialized representation of the [PassioNutrient].
 */
fun mapFromPassioNutrient(nutrient: PassioNutrient): Map<String, Any?> {
    // Create a mutable map to store the serialized nutrient data.
    val nutrientMap = mutableMapOf<String, Any?>()

    // Add nutrient properties to the map.
    nutrientMap["amount"] = nutrient.amount
    nutrientMap["inflammatoryEffectScore"] = nutrient.inflammatoryEffectScore
    nutrientMap["name"] = nutrient.name
    nutrientMap["unit"] = nutrient.unit

    // Return the serialized nutrient map.
    return nutrientMap
}