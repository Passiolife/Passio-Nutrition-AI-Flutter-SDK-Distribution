package ai.passio.nutrition_ai

import ai.passio.nutrition_ai.converter.entityTypeFromString
import ai.passio.nutrition_ai.converter.iconSizeFromString
import ai.passio.nutrition_ai.converter.mapFromBitmap
import ai.passio.nutrition_ai.converter.mapFromCompletedDownloadingFile
import ai.passio.nutrition_ai.converter.mapFromFoodCandidates
import ai.passio.nutrition_ai.converter.mapFromInflammatoryEffectData
import ai.passio.nutrition_ai.converter.mapFromMinMaxCameraZoomLevel
import ai.passio.nutrition_ai.converter.mapFromNutritionFactsRecognitionListener
import ai.passio.nutrition_ai.converter.mapFromPassioAdvisorFoodInfo
import ai.passio.nutrition_ai.converter.mapFromPassioFoodDataInfo
import ai.passio.nutrition_ai.converter.mapFromPassioFoodItem
import ai.passio.nutrition_ai.converter.mapFromPassioMealPlan
import ai.passio.nutrition_ai.converter.mapFromPassioMealPlanItem
import ai.passio.nutrition_ai.converter.mapFromPassioResult
import ai.passio.nutrition_ai.converter.mapFromPassioSpeechRecognitionModel
import ai.passio.nutrition_ai.converter.mapFromPassioStatus
import ai.passio.nutrition_ai.converter.mapFromPassioStatusListener
import ai.passio.nutrition_ai.converter.mapFromPassioTokenBudget
import ai.passio.nutrition_ai.converter.mapFromSearchResponse
import ai.passio.nutrition_ai.converter.mapToFetchFoodItemForDataInfo
import ai.passio.nutrition_ai.converter.mapToFoodDetectionConfiguration
import ai.passio.nutrition_ai.converter.mapToPassioConfiguration
import ai.passio.nutrition_ai.converter.mapToRectF
import ai.passio.nutrition_ai.converter.passioImageResolutionFromString
import ai.passio.passiosdk.core.config.Bridge
import ai.passio.passiosdk.core.config.PassioMode
import ai.passio.passiosdk.core.config.PassioStatus
import ai.passio.passiosdk.passiofood.FoodCandidates
import ai.passio.passiosdk.passiofood.FoodRecognitionListener
import ai.passio.passiosdk.passiofood.NutritionFactsRecognitionListener
import ai.passio.passiosdk.passiofood.PassioAccountListener
import ai.passio.passiosdk.passiofood.PassioID
import ai.passio.passiosdk.passiofood.PassioMealTime
import ai.passio.passiosdk.passiofood.PassioSDK
import ai.passio.passiosdk.passiofood.PassioStatusListener
import ai.passio.passiosdk.passiofood.data.model.PassioTokenBudget
import ai.passio.passiosdk.passiofood.nutritionfacts.PassioNutritionFacts
import android.app.Activity
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.launch
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
            "fetchFoodItemForPassioID" -> fetchFoodItemForPassioID(call.arguments as String, result)
            "searchForFood" -> searchForFood(call.arguments as String, result)
            "fetchFoodItemForDataInfo" -> fetchFoodItemForDataInfo(
                call.arguments as HashMap<String, Any>,
                result
            )

            "fetchFoodItemForProductCode" -> fetchFoodItemForProductCode(
                call.arguments as String,
                result
            )

            "detectFoodIn" -> detectFoodIn(call.arguments as HashMap<String, Any>, result)
            "fetchTagsFor" -> fetchTagsFor(call.arguments as String, result)
            "iconURLFor" -> fetchURLFor(call.arguments as HashMap<String, Any>, result)
            "transformCGRectForm" -> transformRect(call.arguments as HashMap<String, Any>, result)
            "fetchInflammatoryEffectData" -> fetchInflammatoryEffectData(
                call.arguments as String,
                result
            )

            "fetchSuggestions" -> fetchSuggestions(call.arguments as String, result)
            "fetchMealPlans" -> fetchMealPlans(result)
            "fetchMealPlanForDay" -> fetchMealPlanForDay(
                call.arguments as HashMap<String, Any>,
                result
            )

            "fetchFoodItemForRefCode" -> fetchFoodItemForRefCode(call.arguments as String, result)
            "fetchFoodItemLegacy" -> fetchFoodItemLegacy(call.arguments as String, result)
            "recognizeSpeechRemote" -> recognizeSpeechRemote(call.arguments as String, result)
            "recognizeImageRemote" -> recognizeImageRemote(
                call.arguments as HashMap<String, Any>,
                result
            )

            "fetchHiddenIngredients" -> fetchHiddenIngredients(call.arguments as String, result)
            "fetchVisualAlternatives" -> fetchVisualAlternatives(call.arguments as String, result)
            "fetchPossibleIngredients" -> fetchPossibleIngredients(call.arguments as String, result)
            "enableFlashlight" -> enableFlashlight(call.arguments as HashMap<String, Any>, result)
            "setCameraZoom" -> setCameraZoom(call.arguments as HashMap<String, Any>, result)
            "getMinMaxCameraZoomLevel" -> getMinMaxCameraZoomLevel(result)
            "recognizeNutritionFactsRemote" -> recognizeNutritionFactsRemote(call.arguments as HashMap<String, Any>, result)
            "updateLanguage" -> updateLanguage(call.arguments as String, result)
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

        PassioSDK.instance.fetchIconFor(
            activity.applicationContext,
            passioID,
            icon
        ) inner@{ drawable ->
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

        val result =
            PassioSDK.instance.lookupIconsFor(activity.applicationContext, passioID, iconSize, type)

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
            // Sets up the PassioSDK status listener.
            "setPassioStatusListener" -> setPassioStatusListener(events)
            "startNutritionFactsDetection" -> startNutritionFactsDetection(events)
            "setAccountListener" -> setAccountListener(events)
        }
    }


    @Suppress("UNCHECKED_CAST")
    override fun onCancel(arguments: Any) {
        val argMap = arguments as HashMap<String, Any>
        when (argMap["method"]) {
            "startFoodDetection" -> PassioSDK.instance.stopFoodDetection()
            // Removes the PassioSDK status listener to stop receiving status updates.
            "setPassioStatusListener" -> PassioSDK.instance.setPassioStatusListener(null)
            "startNutritionFactsDetection" -> PassioSDK.instance.stopNutritionFactsDetection()
            "setAccountListener" -> PassioSDK.instance.setAccountListener(null)
        }
    }

    private fun startFoodDetection(args: Map<String, Any>, events: EventChannel.EventSink) {
        val config = mapToFoodDetectionConfiguration(args)
        PassioSDK.instance.startFoodDetection(object : FoodRecognitionListener {
            override fun onRecognitionResults(
                candidates: FoodCandidates?,
                image: Bitmap?
            ) {
                // Use the Main dispatcher to launch a coroutine within the UI context
                CoroutineScope(Dispatchers.Main).launch {
                    // Call the detectionFlow function, passing in FoodCandidates and Bitmap image
                    detectionFlow(candidates, image).collect {
                        // Inside the collect block, which is a suspending function,
                        // Send the recognition results through the event sink
                        events.success(it)
                    }
                }
            }
        }, config)
    }

    private fun fetchFoodItemForPassioID(passioID: PassioID, callback: MethodChannel.Result) {
        PassioSDK.instance.fetchFoodItemForPassioID(passioID) { foodItem ->
            if (foodItem == null) {
                callback.success(null)
            } else {
                val foodItemMap = mapFromPassioFoodItem(foodItem)
                callback.success(foodItemMap)
            }
        }
    }

    private fun searchForFood(byText: String, callback: MethodChannel.Result) {
        PassioSDK.instance.searchForFood(byText) { searchResult, alternatives ->
            val searchMap = mapFromSearchResponse(searchResult, alternatives)
            callback.success(searchMap)
        }
    }

    private fun fetchFoodItemForDataInfo(
        args: HashMap<String, Any>,
        callback: MethodChannel.Result
    ) {
        val (foodDataInfo, weightGrams) = mapToFetchFoodItemForDataInfo(args)
        PassioSDK.instance.fetchFoodItemForDataInfo(foodDataInfo, weightGrams) { foodItem ->
            if (foodItem == null) {
                callback.success(null)
            } else {
                val foodItemMap = mapFromPassioFoodItem(foodItem)
                callback.success(foodItemMap)
            }
        }
    }

    private fun fetchFoodItemForProductCode(productCode: String, callback: MethodChannel.Result) {
        PassioSDK.instance.fetchFoodItemForProductCode(productCode) { foodItem ->
            if (foodItem == null) {
                callback.success(null)
            } else {
                val foodItemMap = mapFromPassioFoodItem(foodItem)
                callback.success(foodItemMap)
            }
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

        val url = PassioSDK.instance.iconURLFor(passioID, icon)
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

    /**
     * Fetches nutrients for a given passioID and communicates the result through the provided callback.
     *
     * @param passioID The PassioID for which inflammatory effect data is to be fetched.
     * @param callback A MethodChannel.Result used to communicate the result back to the caller.
     */
    private fun fetchInflammatoryEffectData(passioID: PassioID, callback: MethodChannel.Result) {
        // Calling PassioSDK to fetch nutrients for the given passioID
        PassioSDK.instance.fetchInflammatoryEffectData(passioID) { list ->
            // Mapping PassioNutrient objects to a new list using mapFromPassioNutrient function
            val nutrientList = list?.map { mapFromInflammatoryEffectData(it) }
            // Calling the callback's success method with the nutrientList
            callback.success(nutrientList)
        }
    }

    // Define a suspend function named detectionFlow that takes FoodCandidates and a Bitmap image as parameters
    suspend fun detectionFlow(candidates: FoodCandidates?, image: Bitmap?) = flow {

        // Creating a Map from the FoodCandidates object
        val mapCandidates = mapFromFoodCandidates(candidates)

        // Creating a Map from the image object
        val imageMap = mapFromBitmap(image)

        // Creating a mutable map to store results
        val resultMap = mutableMapOf<String, Any?>()
        // Adding the map of FoodCandidates to the resultMap
        resultMap["candidates"] = mapCandidates
        // Adding the map representing image properties to the resultMap
        resultMap["image"] = imageMap

        // Emit the resultMap as a flow item
        emit(resultMap)
    }.flowOn(Dispatchers.IO) // Specify that the flow should run on the IO dispatcher


    /**
     * Sets up the PassioSDK status listener for handling various events related to file downloads and Passio status changes.
     *
     * @param events The EventSink to send Flutter events to.
     */
    private fun setPassioStatusListener(events: EventChannel.EventSink) {
        PassioSDK.instance.setPassioStatusListener(object : PassioStatusListener {

            /**
             * Called when all files have been successfully downloaded.
             *
             * @param fileUris List of URIs for the downloaded files.
             */
            override fun onCompletedDownloadingAllFiles(fileUris: List<Uri>) {
                val files = fileUris.map(Uri::toString)
                val statusListenerMap = mapFromPassioStatusListener(
                    "completedDownloadingAllFiles",
                    files
                )
                events.success(statusListenerMap)
            }

            /**
             * Called when an individual file has been successfully downloaded.
             *
             * @param fileUri URI of the downloaded file.
             * @param filesLeft Number of files left to download.
             */
            override fun onCompletedDownloadingFile(fileUri: Uri, filesLeft: Int) {
                val downloadingMap = mapFromCompletedDownloadingFile(fileUri, filesLeft)
                val statusListenerMap =
                    mapFromPassioStatusListener("completedDownloadingFile", downloadingMap)
                events.success(statusListenerMap)
            }

            /**
             * Called when an error occurs during the download process.
             *
             * @param message Error message describing the issue.
             */
            override fun onDownloadError(message: String) {
                events.success(mapFromPassioStatusListener("downloadingError", message))
            }

            /**
             * Called when the Passio status changes.
             *
             * @param status The new PassioStatus.
             */
            override fun onPassioStatusChanged(status: PassioStatus) {
                val passioStatus = mapFromPassioStatus(status)
                val statusListenerMap =
                    mapFromPassioStatusListener("passioStatusChanged", passioStatus)
                events.success(statusListenerMap)
            }

        })
    }

    private fun fetchSuggestions(mealTimeString: String, callback: MethodChannel.Result) {
        val mealTime = PassioMealTime.valueOf(mealTimeString.uppercase())
        PassioSDK.instance.fetchSuggestions(mealTime) { searchResult ->
            val resultListMap = searchResult.map { mapFromPassioFoodDataInfo(it) }
            callback.success(resultListMap)
        }
    }

    /**
     * Fetches meal plans using PassioSDK and sends the result via callback.
     *
     * @param callback Callback to send the fetched meal plans.
     */
    private fun fetchMealPlans(callback: MethodChannel.Result) {
        PassioSDK.instance.fetchMealPlans { mealPlans ->
            // Map fetched meal plans to a list of mapped meal plan data
            val mappedMealPlans = mealPlans.map { mapFromPassioMealPlan(it) }
            // Send the mapped meal plans via callback
            callback.success(mappedMealPlans)
        }
    }

    /**
     * Fetches meal plan items for a specific day using PassioSDK and sends the result via callback.
     *
     * @param args Arguments containing meal plan label and day.
     * @param callback Callback to send the fetched meal plan items.
     */
    private fun fetchMealPlanForDay(args: Map<String, Any>, callback: MethodChannel.Result) {
        // Extract meal plan label and day from arguments
        val mealPlanLabel = args["mealPlanLabel"] as String
        val day = args["day"] as Int

        // Fetch meal plan items for the specified day using PassioSDK
        PassioSDK.instance.fetchMealPlanForDay(mealPlanLabel, day) { mealPlanItems ->
            // Map fetched meal plan items to a list of mapped meal plan item data
            val mappedMealPlanItems = mealPlanItems.map { mapFromPassioMealPlanItem(it) }
            // Send the mapped meal plan items via callback
            callback.success(mappedMealPlanItems)
        }
    }

    private fun fetchFoodItemForRefCode(refCode: String, callback: MethodChannel.Result) {
        PassioSDK.instance.fetchFoodItemForRefCode(refCode) { foodItem ->
            if (foodItem == null) {
                callback.success(null)
            } else {
                val foodItemMap = mapFromPassioFoodItem(foodItem)
                callback.success(foodItemMap)
            }
        }
    }

    /**
     * Fetches a food item using the legacy API.
     *
     * @param passioID The ID of the food item to fetch.
     * @param callback The callback to invoke with the result.
     */
    private fun fetchFoodItemLegacy(passioID: PassioID, callback: MethodChannel.Result) {
        // Call the fetchFoodItemLegacy method on the PassioSDK instance
        PassioSDK.instance.fetchFoodItemLegacy(passioID) { foodItem ->

            // If the foodItem is not null, map it to a new object and return it
            foodItem?.let {
                callback.success(mapFromPassioFoodItem(it))
            }

            // Otherwise, return null
                ?: callback.success(null)
        }
    }

    /**
     * Recognizes speech remotely using the PassioSDK.
     *
     * @param text The text to be recognized.
     * @param callback The callback to invoke with the result.
     */
    private fun recognizeSpeechRemote(text: String, callback: MethodChannel.Result) {
        // Call the recognizeSpeechRemote method on the PassioSDK instance
        PassioSDK.instance.recognizeSpeechRemote(text) { speechRecognitionModel ->

            // Map the SpeechRecognitionModel object to a new object
            val mappedResult =
                speechRecognitionModel.map { mapFromPassioSpeechRecognitionModel(it) }

            // Return the mapped result using the callback
            callback.success(mappedResult)
        }
    }

    /**
     * Recognizes an image remotely using the PassioSDK.
     *
     * @param args A map containing the byte array of the image and the desired resolution as a string.
     * @param callback The callback to return the recognition result to.
     */
    private fun recognizeImageRemote(args: Map<String, Any>, callback: MethodChannel.Result) {
        // Extract the byte array from the arguments.
        val bytes = args["bytes"] as ByteArray

        // Extract the resolution string from the arguments and convert it to the corresponding enum.
        val resolution = args["resolution"] as String
        val resolutionEnum = passioImageResolutionFromString(resolution)

        // Extract the optional message from the arguments.
        val message = args["message"] as String?

        // Decode the byte array into a bitmap.
        val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)

        // Call the recognizeImageRemote method on the PassioSDK instance.
        PassioSDK.instance.recognizeImageRemote(
            bitmap,
            resolutionEnum,
            message
        ) { imageRecognitionModel ->
            // Map the SpeechRecognitionModel object to a new object.
            val mappedResult =
                imageRecognitionModel.map { mapFromPassioAdvisorFoodInfo(it) }

            // Return the mapped result using the callback.
            callback.success(mappedResult)
        }
    }

    private fun startNutritionFactsDetection(events: EventChannel.EventSink) {
        PassioSDK.instance.startNutritionFactsDetection(
            object : NutritionFactsRecognitionListener {
                override fun onRecognitionResult(
                    nutritionFacts: PassioNutritionFacts?,
                    text: String
                ) {
                    events.success(mapFromNutritionFactsRecognitionListener(nutritionFacts, text))
                }
            },
        )
    }

    /**
     * Fetches hidden ingredients for a given food item using the PassioSDK.
     *
     * @param foodName The name of the food item for which hidden ingredients are to be fetched.
     * @param callback The callback to return the result of the fetch operation.
     */
    private fun fetchHiddenIngredients(foodName: String, callback: MethodChannel.Result) {
        // Calls the fetchHiddenIngredients method on the PassioSDK instance with the provided food name.
        PassioSDK.instance.fetchHiddenIngredients(foodName) { result ->
            // Maps the result from the PassioSDK to a new object using mapFromPassioResult.
            // Returns the mapped result using the callback.
            callback.success(mapFromPassioResult(result))
        }
    }

    /**
     * Fetches visual alternatives for a given food item using the PassioSDK.
     *
     * @param foodName The name of the food item for which visual alternatives are to be fetched.
     * @param callback The callback to return the result of the fetch operation.
     */
    private fun fetchVisualAlternatives(foodName: String, callback: MethodChannel.Result) {
        // Calls the fetchVisualAlternatives method on the PassioSDK instance with the provided food name.
        PassioSDK.instance.fetchVisualAlternatives(foodName) { result ->
            // Maps the result from the PassioSDK to a new object using mapFromPassioResult.
            // Returns the mapped result using the callback.
            callback.success(mapFromPassioResult(result))
        }
    }

    /**
     * Fetches possible ingredients for a given food item using the PassioSDK.
     *
     * @param foodName The name of the food item for which possible ingredients are to be fetched.
     * @param callback The callback to return the result of the fetch operation.
     */
    private fun fetchPossibleIngredients(foodName: String, callback: MethodChannel.Result) {
        // Calls the fetchPossibleIngredients method on the PassioSDK instance with the provided food name.
        PassioSDK.instance.fetchPossibleIngredients(foodName) { result ->
            // Maps the result from the PassioSDK to a new object using mapFromPassioResult.
            // Returns the mapped result using the callback.
            callback.success(mapFromPassioResult(result))
        }
    }

    private fun setAccountListener(events: EventChannel.EventSink) {
        // Set up an account listener with PassioSDK to handle token budget updates
        PassioSDK.instance.setAccountListener(
            object : PassioAccountListener {
                override fun onTokenBudgetUpdate(tokenBudget: PassioTokenBudget) {
                    // Convert the PassioTokenBudget object to a map and send it through the event channel
                    events.success(mapFromPassioTokenBudget(tokenBudget))
                }
            },
        )
    }

    private fun enableFlashlight(args: HashMap<String, Any>, callback: MethodChannel.Result) {
        val enabled = args["enabled"] as Boolean

        // Call the PassioSDK to enable or disable the flashlight
        PassioSDK.instance.enableFlashlight(enabled)

        // Send a success result back to the Dart side
        callback.success(null)
    }

    private fun setCameraZoom(args: HashMap<String, Any>, callback: MethodChannel.Result) {
        val zoomLevel = (args["zoomLevel"] as Double).toFloat()

        // Call the PassioSDK to enable or disable the flashlight
        PassioSDK.instance.setCameraZoomLevel(zoomLevel)

        // Send a success result back to the Dart side
        callback.success(null)
    }

    private fun getMinMaxCameraZoomLevel(callback: MethodChannel.Result) {
        val result = PassioSDK.instance.getMinMaxCameraZoomLevel()
        callback.success(mapFromMinMaxCameraZoomLevel(result))
    }

    private fun recognizeNutritionFactsRemote(
        args: Map<String, Any>,
        callback: MethodChannel.Result
    ) {
        // Extract the byte array from the arguments.
        val bytes = args["bytes"] as ByteArray

        // Extract the resolution string from the arguments and convert it to the corresponding enum.
        val resolution = args["resolution"] as String
        val resolutionEnum = passioImageResolutionFromString(resolution)

        // Decode the byte array into a bitmap.
        val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)

        // Call the recognizeNutritionFactsRemote method on the PassioSDK instance.
        PassioSDK.instance.recognizeNutritionFactsRemote(
            bitmap,
            resolutionEnum,
        ) { foodItem ->
            if (foodItem == null) {
                callback.success(null)
            } else {
                val foodItemMap = mapFromPassioFoodItem(foodItem)
                callback.success(foodItemMap)
            }
        }
    }

    private fun updateLanguage(
        languageCode: String,
        callback: MethodChannel.Result
    ) {
        callback.success(PassioSDK.instance.updateLanguage(languageCode))
    }

}