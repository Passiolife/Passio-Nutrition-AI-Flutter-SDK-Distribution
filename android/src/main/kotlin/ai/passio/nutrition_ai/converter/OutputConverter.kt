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
import ai.passio.passiosdk.passiofood.PassioFoodDataInfo
import ai.passio.passiosdk.passiofood.PassioSearchNutritionPreview
import ai.passio.passiosdk.passiofood.data.measurement.Grams
import ai.passio.passiosdk.passiofood.data.measurement.KiloCalories
import ai.passio.passiosdk.passiofood.data.measurement.Kilograms
import ai.passio.passiosdk.passiofood.data.measurement.Micrograms
import ai.passio.passiosdk.passiofood.data.measurement.Milligrams
import ai.passio.passiosdk.passiofood.data.measurement.Milliliters
import ai.passio.passiosdk.passiofood.data.measurement.Unit
import ai.passio.passiosdk.passiofood.data.measurement.UnitEnergy
import ai.passio.passiosdk.passiofood.data.measurement.UnitMass
import ai.passio.passiosdk.passiofood.data.model.PassioAdvisorFoodInfo
import ai.passio.passiosdk.passiofood.data.model.PassioAdvisorResponse
import ai.passio.passiosdk.passiofood.data.model.PassioFoodAmount
import ai.passio.passiosdk.passiofood.data.model.PassioFoodItem
import ai.passio.passiosdk.passiofood.data.model.PassioFoodMetadata
import ai.passio.passiosdk.passiofood.data.model.PassioFoodOrigin
import ai.passio.passiosdk.passiofood.data.model.PassioFoodResultType
import ai.passio.passiosdk.passiofood.data.model.PassioIngredient
import ai.passio.passiosdk.passiofood.data.model.PassioMealPlan
import ai.passio.passiosdk.passiofood.data.model.PassioMealPlanItem
import ai.passio.passiosdk.passiofood.data.model.PassioNutrients
import ai.passio.passiosdk.passiofood.data.model.PassioResult
import ai.passio.passiosdk.passiofood.data.model.PassioServingSize
import ai.passio.passiosdk.passiofood.data.model.PassioServingUnit
import ai.passio.passiosdk.passiofood.data.model.PassioSpeechRecognitionModel
import ai.passio.passiosdk.passiofood.data.model.PassioTokenBudget
import ai.passio.passiosdk.passiofood.data.model.PassioUPFRating
import ai.passio.passiosdk.passiofood.nutritionfacts.PassioNutritionFacts
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
        PassioSDKError.NETWORK_ERROR -> "networkError"
        PassioSDKError.NO_MODELS_FILES_FOUND -> "noModelsFilesFound"
        PassioSDKError.NOT_LICENSED_FOR_THIS_PROJECT -> "notLicensedForThisProject"
        PassioSDKError.MISSING_DEPENDENCY -> "missingDependency"
        PassioSDKError.METADATA_ERROR -> "metadataError"
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
    // Add the refCode property to the map
    foodItemMap["refCode"] = foodItem.refCode

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
    ingredientMap["refCode"] = ingredient.refCode
    ingredientMap["referenceNutrients"] = mapFromPassioNutrients(ingredient.referenceNutrients)

    return ingredientMap
}

private fun mapFromPassioFoodMetadata(metadata: PassioFoodMetadata): Map<String, Any?> {
    val metaDataMap = mutableMapOf<String, Any?>()

    metaDataMap["barcode"] = metadata.barcode
    metaDataMap["foodOrigins"] = metadata.foodOrigins?.map { mapFromFoodOrigin(it) }
    metaDataMap["ingredientsDescription"] = metadata.ingredientsDescription
    metaDataMap["tags"] = metadata.tags
    metaDataMap["concerns"] = metadata.concerns

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
    nutrientsMap["zinc"] = mapFromUnitMass(nutrients.zinc())
    nutrientsMap["selenium"] = mapFromUnitMass(nutrients.selenium())
    nutrientsMap["folicAcid"] = mapFromUnitMass(nutrients.folicAcid())
    nutrientsMap["chromium"] = mapFromUnitMass(nutrients.chromium())
    nutrientsMap["vitaminKPhylloquinone"] = mapFromUnitMass(nutrients.vitaminKPhylloquinone())
    nutrientsMap["vitaminKMenaquinone4"] = mapFromUnitMass(nutrients.vitaminKMenaquinone4())
    nutrientsMap["vitaminKDihydrophylloquinone"] =
        mapFromUnitMass(nutrients.vitaminKDihydrophylloquinone())
    nutrientsMap["vitaminARAE"] =
        mapFromUnitMass(nutrients.vitaminARAE())

    return nutrientsMap
}

fun mapFromSearchResponse(
    searchResult: List<PassioFoodDataInfo>,
    alternative: List<String>
): Map<String, Any?> {
    val searchMap = mutableMapOf<String, Any?>()
    searchMap["results"] = searchResult.map { mapFromPassioFoodDataInfo(it) }
    searchMap["alternateNames"] = alternative
    return searchMap
}

fun mapFromPassioFoodDataInfo(passioFoodDataInfo: PassioFoodDataInfo): Map<String, Any?> {
    val searchResult = mutableMapOf<String, Any?>()
    searchResult["brandName"] = passioFoodDataInfo.brandName
    searchResult["foodName"] = passioFoodDataInfo.foodName
    searchResult["iconID"] = passioFoodDataInfo.iconID
    searchResult["labelId"] = passioFoodDataInfo.labelId
    searchResult["nutritionPreview"] =
        mapFromPassioSearchNutritionPreview(passioFoodDataInfo.nutritionPreview)
    searchResult["refCode"] = passioFoodDataInfo.refCode
    searchResult["resultId"] = passioFoodDataInfo.resultId
    searchResult["score"] = passioFoodDataInfo.score
    searchResult["scoredName"] = passioFoodDataInfo.scoredName
    searchResult["type"] = passioFoodDataInfo.type
    searchResult["isShortName"] = passioFoodDataInfo.isShortName
    searchResult["tags"] = passioFoodDataInfo.tags
    return searchResult
}

private fun mapFromPassioSearchNutritionPreview(nutritionPreview: PassioSearchNutritionPreview): Map<String, Any?> {
    val previewMap = mutableMapOf<String, Any?>()
    previewMap["calories"] = nutritionPreview.calories
    previewMap["carbs"] = nutritionPreview.carbs
    previewMap["fat"] = nutritionPreview.fat
    previewMap["protein"] = nutritionPreview.protein
    previewMap["fiber"] = nutritionPreview.fiber
    previewMap["servingQuantity"] = nutritionPreview.servingQuantity
    previewMap["servingUnit"] = nutritionPreview.servingUnit
    previewMap["weightUnit"] = nutritionPreview.weightUnit
    previewMap["weightQuantity"] = nutritionPreview.weightQuantity
    return previewMap
}

/**
 * Maps data from a PassioMealPlan object to a map with String keys and nullable Any values.
 *
 * @param passioMealPlan The PassioMealPlan object to map from.
 * @return A map containing mapped data.
 */
fun mapFromPassioMealPlan(passioMealPlan: PassioMealPlan): Map<String, Any?> {
    // Create a mutable map to store mapped data
    val map = mutableMapOf<String, Any?>()

    // Map individual properties from PassioMealPlan object
    map["carbTarget"] = passioMealPlan.carbTarget
    map["fatTarget"] = passioMealPlan.fatTarget
    map["mealPlanLabel"] = passioMealPlan.mealPlanLabel
    map["mealPlanTitle"] = passioMealPlan.mealPlanTitle
    map["proteinTarget"] = passioMealPlan.proteinTarget

    // Return the mapped data
    return map
}

/**
 * Maps data from a PassioMealPlanItem object to a map with String keys and nullable Any values.
 *
 * @param passioMealPlanItem The PassioMealPlanItem object to map from.
 * @return A map containing mapped data.
 */
fun mapFromPassioMealPlanItem(passioMealPlanItem: PassioMealPlanItem): Map<String, Any?> {
    // Create a mutable map to store mapped data
    val map = mutableMapOf<String, Any?>()

    // Map individual properties from PassioMealPlanItem object
    map["dayNumber"] = passioMealPlanItem.dayNumber
    map["dayTitle"] = passioMealPlanItem.dayTitle
    map["meal"] = mapFromPassioFoodDataInfo(passioMealPlanItem.meal)
    map["mealTime"] = passioMealPlanItem.mealTime.mealName

    // Return the mapped data
    return map
}

/**
 * Maps a PassioSpeechRecognitionModel object to a Map<String, Any?>.
 *
 * @param passioSpeechRecognitionModel The PassioSpeechRecognitionModel object to map.
 * @return A Map<String, Any?> representation of the PassioSpeechRecognitionModel object.
 */
fun mapFromPassioSpeechRecognitionModel(passioSpeechRecognitionModel: PassioSpeechRecognitionModel): Map<String, Any?> {
    return with(passioSpeechRecognitionModel) {
        mapOf(
            "action" to action?.name?.lowercase(),
            "advisorInfo" to mapFromPassioAdvisorFoodInfo(advisorInfo),
            "date" to date,
            "mealTime" to mealTime?.mealName
        )
    }
}

/**
 * Maps a PassioAdvisorFoodInfo object to a Map<String, Any?>.
 *
 * @param passioAdvisorFoodInfo The PassioAdvisorFoodInfo object to map.
 * @return A Map<String, Any?> containing the mapped data.
 */
fun mapFromPassioAdvisorFoodInfo(passioAdvisorFoodInfo: PassioAdvisorFoodInfo): Map<String, Any?> {
    return with(passioAdvisorFoodInfo) {
        mapOf(
            // Map the foodDataInfo property, handling the case where it is null.
            "foodDataInfo" to foodDataInfo?.let { mapFromPassioFoodDataInfo(it) },
            // Map the remaining properties directly.
            "packagedFoodItem" to packagedFoodItem?.let { mapFromPassioFoodItem(it) },
            "portionSize" to portionSize,
            "productCode" to productCode,
            "resultType" to stringToPassioFoodResultType(resultType),
            "recognisedName" to recognisedName,
            "weightGrams" to weightGrams
        )
    }
}

/**
 * Maps the result of a nutrition facts recognition operation to a map.
 *
 * @param nutritionFacts The recognized nutrition facts, or null if none were found.
 * @param text The text that was recognized.
 * @return A map containing the nutrition facts and the recognized text
 */
fun mapFromNutritionFactsRecognitionListener(
    nutritionFacts: PassioNutritionFacts?,
    text: String
): Map<String, Any?> {
    return mapOf("nutritionFacts" to mapFromPassioNutritionFacts(nutritionFacts), "text" to text)
}

/**
 * Maps a PassioNutritionFacts object to a map of key-value pairs.
 *
 * @param nutritionFacts The PassioNutritionFacts object to map.
 * @return A map of key-value pairs representing the nutrition facts, or an empty map if nutritionFacts is null.
 */
fun mapFromPassioNutritionFacts(nutritionFacts: PassioNutritionFacts?): Map<String, Any?>? {
    return nutritionFacts?.let {
        mapOf(
            "addedSugar" to null,
            "calcium" to null,
            "calories" to it.calories,
            "carbs" to it.carbs,
            "cholesterol" to it.cholesterol,
            "dietaryFiber" to null,
            "fat" to it.fat,
            "iron" to null,
            "ingredients" to null,
            "potassium" to null,
            "protein" to it.protein,
            "saturatedFat" to it.saturatedFat,
            "servingUnit" to it.servingUnit,
            "servingQuantity" to it.servingQuantity,
            "weightUnit" to it.weightUnit,
            "weightQuantity" to it.weightQuantity,
            "sodium" to null,
            "sugarAlcohol" to it.sugarAlcohol,
            "sugars" to it.sugars,
            "totalSugars" to null,
            "transFat" to it.transFat,
            "vitaminD" to null,
        )
    }
}

fun mapFromPassioResult(callback: PassioResult<Any>): Map<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    when (callback) {
        is PassioResult.Success -> {
            var resultType: String? = null
            val result: Any? = when (
                callback.value) {
                // If the value is of type PassioAdvisorResponse, map it using mapFromPassioAdvisorResponse.
                is PassioAdvisorResponse -> {
                    resultType = "PassioAdvisorResponse"
                    mapFromPassioAdvisorResponse(callback.value as PassioAdvisorResponse)
                }

                // If the value is a List, further check the type of the first element to determine if it is a List<PassioAdvisorFoodInfo>.
                is List<*> -> {
                    val list = callback.value as List<*>
                    if (list.isNotEmpty() && list[0] is PassioAdvisorFoodInfo) {
                        resultType = "PassioAdvisorFoodInfo"
                        @Suppress("UNCHECKED_CAST")
                        (list as List<PassioAdvisorFoodInfo>).map { mapFromPassioAdvisorFoodInfo(it) }
                    } else {
                        null
                    }
                }

                is Boolean -> {
                    resultType = "bool"
                    callback.value as Boolean
                }

                // If the value does not match any expected type, return null.
                else -> {
                    null
                }
            }
            map["status"] = "success"
            map["message"] = null
            map["value"] = result
            map["valueType"] = resultType
        }

        is PassioResult.Error -> {
            map["status"] = "error"
            map["message"] = callback.message
            map["value"] = null
            map["valueType"] = null
        }
    }
    return map
}

fun mapFromPassioAdvisorResponse(passioAdvisorResponse: PassioAdvisorResponse): Map<String, Any?> {
    return with(passioAdvisorResponse) {
        mapOf(
            "extractedIngredients" to extractedIngredients?.map { mapFromPassioAdvisorFoodInfo(it) },
            "markupContent" to markupContent,
            "messageId" to messageId,
            "rawContent" to rawContent,
            "threadId" to threadId,
            "tools" to tools,
        )
    }
}

fun mapFromPassioTokenBudget(tokenBudget: PassioTokenBudget): Map<String, Any?> {
    return mapOf(
        "apiName" to tokenBudget.apiName,
        "budgetCap" to tokenBudget.budgetCap,
        "periodUsage" to tokenBudget.periodUsage,
        "tokensUsed" to tokenBudget.tokensUsed,
    )
}

fun mapFromMinMaxCameraZoomLevel(minMax: Pair<Float?, Float?>): Map<String, Any?> {
    return mapOf(
        "minZoomLevel" to minMax.first,
        "maxZoomLevel" to minMax.second,
    )
}

fun mapFromPassioUPFRatingResult(result: PassioResult<PassioUPFRating>) : Map<String, Any?> {
    return mapFromPassioResultType(result) { value ->
        mapFromPassioUPFRating(value)
    }
}

fun mapFromPassioUPFRating(rating: PassioUPFRating) : Map<String, Any?> {
    return mapOf(
        "chainOfThought" to rating.chainOfThought,
        "highlightedIngredients" to rating.highlightedIngredients,
        "rating" to rating.rating,
    )
}

fun <T> mapFromPassioResultType(callback: PassioResult<T>, onSuccess: (T) -> Map<String, Any?>): Map<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    when (callback) {
        is PassioResult.Success -> {
            map["status"] = "success"
            map["message"] = null
            map["value"] = onSuccess(callback.value)
        }

        is PassioResult.Error -> {
            map["status"] = "error"
            map["message"] = callback.message
            map["value"] = null
        }
    }
    return map
}


fun stringToPassioFoodResultType(value: PassioFoodResultType): String {
    return when (value) {
        PassioFoodResultType.FOOD_ITEM -> "foodItem"
        PassioFoodResultType.BARCODE -> "barcode"
        PassioFoodResultType.NUTRITION_FACTS -> "nutritionFacts"
    }
}