package ai.passio.nutrition_ai.converter

import ai.passio.nutrition_ai.utils.toByteArray
import ai.passio.passiosdk.core.config.PassioMode
import ai.passio.passiosdk.core.config.PassioSDKError
import ai.passio.passiosdk.core.config.PassioStatus
import ai.passio.passiosdk.passiofood.BarcodeCandidate
import ai.passio.passiosdk.passiofood.DetectedCandidate
import ai.passio.passiosdk.passiofood.FoodCandidates
import ai.passio.passiosdk.passiofood.InflammatoryEffectData
import ai.passio.passiosdk.passiofood.PackagedFoodCandidate
import ai.passio.passiosdk.passiofood.PassioSearchNutritionPreview
import ai.passio.passiosdk.passiofood.PassioSearchResult
import ai.passio.passiosdk.passiofood.data.measurement.Grams
import ai.passio.passiosdk.passiofood.data.measurement.KiloCalories
import ai.passio.passiosdk.passiofood.data.measurement.Kilograms
import ai.passio.passiosdk.passiofood.data.measurement.Micrograms
import ai.passio.passiosdk.passiofood.data.measurement.Milligrams
import ai.passio.passiosdk.passiofood.data.measurement.Milliliters
import ai.passio.passiosdk.passiofood.data.measurement.Unit
import ai.passio.passiosdk.passiofood.data.measurement.UnitEnergy
import ai.passio.passiosdk.passiofood.data.measurement.UnitMass
import ai.passio.passiosdk.passiofood.data.model.PassioFoodAmount
import ai.passio.passiosdk.passiofood.data.model.PassioFoodItem
import ai.passio.passiosdk.passiofood.data.model.PassioFoodMetadata
import ai.passio.passiosdk.passiofood.data.model.PassioFoodOrigin
import ai.passio.passiosdk.passiofood.data.model.PassioIngredient
import ai.passio.passiosdk.passiofood.data.model.PassioNutrients
import ai.passio.passiosdk.passiofood.data.model.PassioServingSize
import ai.passio.passiosdk.passiofood.data.model.PassioServingUnit
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

fun mapFromFoodCandidates(candidates: FoodCandidates?): Map<String, Any?>? {
    if (candidates == null) return null

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
    candidateMap["alternatives"] = candidate.alternatives.map { mapFromDetectedCandidate(it) }
    candidateMap["boundingBox"] = arrayListOf(
        candidate.boundingBox.left,
        candidate.boundingBox.top,
        candidate.boundingBox.width(),
        candidate.boundingBox.height(),
    )
    candidateMap["confidence"] = candidate.confidence
    candidateMap["croppedImage"] = mapFromBitmap(candidate.croppedImage)
    candidateMap["foodName"] = candidate.foodName
    candidateMap["passioID"] = candidate.passioID
    return candidateMap
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
    val unitIUMap = mutableMapOf<String, Any?>()
    unitIUMap["unit"] = "iu"
    unitIUMap["value"] = value
    return unitIUMap
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
 * Maps a [InflammatoryEffectData] object to a [Map] for serialization.
 *
 * @param inflammatoryData The [InflammatoryEffectData] object to be mapped.
 * @return A [Map] containing the serialized representation of the [InflammatoryEffectData].
 */
fun mapFromInflammatoryEffectData(inflammatoryData: InflammatoryEffectData): Map<String, Any?> {
    // Create a mutable map to store the serialized Inflammatory effect data.
    val inflammatoryMap = mutableMapOf<String, Any?>()

    // Add Inflammatory effect properties to the map.
    inflammatoryMap["amount"] = inflammatoryData.amount
    inflammatoryMap["inflammatoryEffectScore"] = inflammatoryData.inflammatoryEffectScore
    inflammatoryMap["nutrient"] = inflammatoryData.nutrient
    inflammatoryMap["unit"] = inflammatoryData.unit

    // Return the serialized inflammatory map.
    return inflammatoryMap
}

/**
 * Converts a PassioFoodItem object to a Map<String, Any?>.
 *
 * @param foodItem The PassioFoodItem object to convert.
 * @return A Map<String, Any?> representing the properties of the PassioFoodItem.
 */
fun mapFromPassioFoodItem(foodItem: PassioFoodItem): Map<String, Any?> {
    // Create a mutable map to store the properties of the PassioFoodItem
    val foodItemMap = mutableMapOf<String, Any?>()

    // Add the amount property to the map
    foodItemMap["amount"] = mapFromPassioFoodAmount(foodItem.amount)
    // Add the details property to the map
    foodItemMap["details"] = foodItem.details
    // Add the iconId property to the map
    foodItemMap["iconId"] = foodItem.iconId
    // Add the id property to the map
    foodItemMap["id"] = foodItem.id
    // Add the ingredients property to the map
    foodItemMap["ingredients"] = foodItem.ingredients.map { mapFromPassioIngredient(it) }
    // Add the name property to the map
    foodItemMap["name"] = foodItem.name

    // Return the populated map
    return foodItemMap
}

/**
 * Converts a PassioFoodAmount object to a Map<String, Any?>.
 *
 * @param amount The PassioFoodAmount object to convert.
 * @return A Map<String, Any?> representing the properties of the PassioFoodAmount.
 */
private fun mapFromPassioFoodAmount(amount: PassioFoodAmount): Map<String, Any?> {
    // Create a mutable map to store the properties of the PassioFoodAmount
    val amountMap = mutableMapOf<String, Any?>()

    // Add the selectedQuantity property to the map
    amountMap["selectedQuantity"] = amount.selectedQuantity
    // Add the selectedUnit property to the map
    amountMap["selectedUnit"] = amount.selectedUnit
    // Convert each serving size to a map and add it to the servingSizes property
    amountMap["servingSizes"] = amount.servingSizes.map { mapFromServingSize(it) }
    // Convert each serving unit to a map and add it to the servingUnits property
    amountMap["servingUnits"] = amount.servingUnits.map { mapFromServingUnit(it) }

    // Return the populated map
    return amountMap
}

fun mapFromPassioIngredient(ingredient: PassioIngredient): Map<String, Any?> {
    val ingredientMap = mutableMapOf<String, Any?>()

    ingredientMap["amount"] = mapFromPassioFoodAmount(ingredient.amount)
    ingredientMap["iconId"] = ingredient.iconId
    ingredientMap["id"] = ingredient.id
    ingredientMap["metadata"] = mapFromPassioFoodMetadata(ingredient.metadata)
    ingredientMap["name"] = ingredient.name
    ingredientMap["referenceNutrients"] = mapFromPassioNutrients(ingredient.referenceNutrients)

    return ingredientMap
}

private fun mapFromPassioFoodMetadata(metadata: PassioFoodMetadata): Map<String, Any?> {
    val metaDataMap = mutableMapOf<String, Any?>()

    metaDataMap["barcode"] = metadata.barcode
    metaDataMap["foodOrigins"] = metadata.foodOrigins?.map { mapFromFoodOrigin(it) }
    metaDataMap["ingredientsDescription"] = metadata.ingredientsDescription
    metaDataMap["tags"] = metadata.tags

    return metaDataMap
}

private fun mapFromPassioNutrients(nutrients: PassioNutrients): Map<String, Any?> {
    val nutrientsMap = mutableMapOf<String, Any?>()

    nutrientsMap["weight"] = mapFromUnitMass(nutrients.weight)
    nutrientsMap["referenceWeight"] = mapFromUnitMass(nutrients.referenceWeight)

    nutrientsMap["calories"] = mapFromUnitEnergy(nutrients.calories())
    nutrientsMap["carbs"] = mapFromUnitMass(nutrients.carbs())
    nutrientsMap["fat"] = mapFromUnitMass(nutrients.fat())
    nutrientsMap["proteins"] = mapFromUnitMass(nutrients.protein())
    nutrientsMap["satFat"] = mapFromUnitMass(nutrients.satFat())
    nutrientsMap["transFat"] = mapFromUnitMass(nutrients.transFat())
    nutrientsMap["monounsaturatedFat"] = mapFromUnitMass(nutrients.monounsaturatedFat())
    nutrientsMap["polyunsaturatedFat"] = mapFromUnitMass(nutrients.polyunsaturatedFat())
    nutrientsMap["cholesterol"] = mapFromUnitMass(nutrients.cholesterol())
    nutrientsMap["sodium"] = mapFromUnitMass(nutrients.sodium())
    nutrientsMap["fibers"] = mapFromUnitMass(nutrients.fibers())
    nutrientsMap["sugars"] = mapFromUnitMass(nutrients.sugars())
    nutrientsMap["sugarsAdded"] = mapFromUnitMass(nutrients.sugarsAdded())
    nutrientsMap["vitaminD"] = mapFromUnitMass(nutrients.vitaminD())
    nutrientsMap["calcium"] = mapFromUnitMass(nutrients.calcium())
    nutrientsMap["iron"] = mapFromUnitMass(nutrients.iron())
    nutrientsMap["potassium"] = mapFromUnitMass(nutrients.potassium())
    nutrientsMap["vitaminA"] = mapFromUnitIU(nutrients.vitaminA())
    nutrientsMap["vitaminC"] = mapFromUnitMass(nutrients.vitaminC())
    nutrientsMap["alcohol"] = mapFromUnitMass(nutrients.alcohol())
    nutrientsMap["sugarAlcohol"] = mapFromUnitMass(nutrients.sugarAlcohol())
    nutrientsMap["vitaminB12Added"] = mapFromUnitMass(nutrients.vitaminB12Added())
    nutrientsMap["vitaminB12"] = mapFromUnitMass(nutrients.vitaminB12())
    nutrientsMap["vitaminB6"] = mapFromUnitMass(nutrients.vitaminB6())
    nutrientsMap["vitaminE"] = mapFromUnitMass(nutrients.vitaminE())
    nutrientsMap["vitaminEAdded"] = mapFromUnitMass(nutrients.vitaminEAdded())
    nutrientsMap["magnesium"] = mapFromUnitMass(nutrients.magnesium())
    nutrientsMap["phosphorus"] = mapFromUnitMass(nutrients.phosphorus())
    nutrientsMap["iodine"] = mapFromUnitMass(nutrients.iodine())

    return nutrientsMap
}

fun mapFromSearchResponse(
    searchResult: List<PassioSearchResult>,
    alternative: List<String>
): Map<String, Any?> {
    val searchMap = mutableMapOf<String, Any?>()
    searchMap["results"] = searchResult.map { mapFromPassioSearchResult(it) }
    searchMap["alternateNames"] = alternative
    return searchMap
}

private fun mapFromPassioSearchResult(passioSearchResult: PassioSearchResult): Map<String, Any?> {
    val searchResult = mutableMapOf<String, Any?>()
    searchResult["brandName"] = passioSearchResult.brandName
    searchResult["foodName"] = passioSearchResult.foodName
    searchResult["iconID"] = passioSearchResult.iconID
    searchResult["labelId"] = passioSearchResult.labelId
    searchResult["nutritionPreview"] =
        mapFromPassioSearchNutritionPreview(passioSearchResult.nutritionPreview)
    searchResult["resultId"] = passioSearchResult.resultId
    searchResult["score"] = passioSearchResult.score
    searchResult["scoredName"] = passioSearchResult.scoredName
    searchResult["type"] = passioSearchResult.type
    return searchResult
}

private fun mapFromPassioSearchNutritionPreview(nutritionPreview: PassioSearchNutritionPreview): Map<String, Any?> {
    val previewMap = mutableMapOf<String, Any?>()
    previewMap["calories"] = nutritionPreview.calories
    previewMap["servingQuantity"] = nutritionPreview.servingQuantity
    previewMap["servingUnit"] = nutritionPreview.servingUnit
    previewMap["servingWeight"] = nutritionPreview.servingWeight
    return previewMap
}