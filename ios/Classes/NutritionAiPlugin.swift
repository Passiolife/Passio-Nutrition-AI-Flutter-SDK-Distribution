//  Copyright © 2023 Passio Inc. All rights reserved.

import Flutter
import PassioNutritionAISDK
import UIKit

public class NutritionAiPlugin: NSObject, FlutterPlugin {
    
    let passioSDK = PassioNutritionAI.shared
    let inputConverter = InputConverter()
    let outputConverter = OutputConverter()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = NutritionAiPlugin()
        // Get the binary messenger from the Flutter registrar.
        let binaryMessenger = registrar.messenger()
        let channel = FlutterMethodChannel(name: "nutrition_ai/method",
                                           binaryMessenger: binaryMessenger)
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let nutritionAdvisorHandler = NutritionAdvisorHandler()
        let advisorChannel = FlutterMethodChannel(name: "nutrition_advisor/method",
                                           binaryMessenger: binaryMessenger)
        registrar.addMethodCallDelegate(nutritionAdvisorHandler, channel: advisorChannel)
        
        // Initialize a PassioEventStreamHandler for handling events.
        let passioEventStreamHandler = PassioEventStreamHandler()
        
        let eventChannel = FlutterEventChannel(name: "nutrition_ai/event/detection",
                                               binaryMessenger: binaryMessenger)
        eventChannel.setStreamHandler(passioEventStreamHandler)
        
        // Created a FlutterEventChannel named "nutrition_ai/event/status" with the provided binaryMessenger.
        let statusChannel = FlutterEventChannel(name: "nutrition_ai/event/status",
                                               binaryMessenger: binaryMessenger)
        // Set PassioEventStreamHandler as the stream handler for the statusEventChannel.
        statusChannel.setStreamHandler(passioEventStreamHandler)
        
        let nutritionFactChannel = FlutterEventChannel(name: "nutrition_ai/event/nutritionFact",
                                               binaryMessenger: binaryMessenger)
        nutritionFactChannel.setStreamHandler(passioEventStreamHandler)
    
        let accountChannel = FlutterEventChannel(name: "nutrition_ai/event/account",
                                               binaryMessenger: binaryMessenger)
        accountChannel.setStreamHandler(passioEventStreamHandler)
    
        let factory = PassioPreviewFactory(messenger: binaryMessenger)
        registrar.register(factory, withId: "PassioPreviewViewType")
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getSDKVersion":
            result(passioSDK.version)
        case "configureSDK":
            configureSDK(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "startFoodDetection":
         break
        case "detectFoodIn":
            detectFoodIn(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "lookupIconsFor":
            lookupIconsFor(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "fetchIconFor":
            fetchIconFor(arguments: call.arguments) {flutterResult in
                result(flutterResult)
            }
        case "iconURLFor":
            iconURLFor(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "fetchFoodItemForPassioID":
            fetchFoodItemForPassioID(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "fetchFoodItemForProductCode":
            fetchFoodItemForProductCode(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "searchForFood":
            searchForFood(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "fetchFoodItemForDataInfo":
            fetchFoodItemForDataInfo(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "fetchTagsFor":
            fetchTagsFor(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "transformCGRectForm":
            transformCGRectForm(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "fetchInflammatoryEffectData":
            fetchInflammatoryEffectData(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "fetchSuggestions":
            fetchSuggestions(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "fetchMealPlans":
            fetchMealPlans(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "fetchMealPlanForDay":
            fetchMealPlanForDay(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "fetchFoodItemForRefCode":
            fetchFoodItemForRefCode(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "fetchFoodItemLegacy":
            fetchFoodItemLegacy(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "recognizeSpeechRemote":
            recognizeSpeechRemote(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "recognizeImageRemote":
            recognizeImageRemote(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "fetchHiddenIngredients":
            fetchHiddenIngredients(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "fetchVisualAlternatives":
            fetchVisualAlternatives(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "fetchPossibleIngredients":
            fetchPossibleIngredients(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "enableFlashlight":
            enableFlashlight(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "setCameraZoom":
            setCameraZoom(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "getMinMaxCameraZoomLevel":
            getMinMaxCameraZoomLevel(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "recognizeNutritionFactsRemote":
            recognizeNutritionFactsRemote(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "updateLanguage":
            updateLanguage(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        default:
            print("call.method = \(call.method) not in the list")
            result(FlutterMethodNotImplemented)
        }
    }
    
    func configureSDK(arguments: Any?, result: @escaping FlutterResult) {
        guard let arguments = arguments as? [String: Any],
              let passioKey = arguments["key"] as? String else {
            result("Fail to configure no arguments")
            return
        }
       
        var passioConfig = PassioConfiguration(key: passioKey)
        passioConfig.bridge = .flutter
        

        if let sdkDownloadsModels = arguments["sdkDownloadsModels"] as? Bool {
            passioConfig.sdkDownloadsModels = sdkDownloadsModels
        }
        
        if let allowInternetConnection = arguments["allowInternetConnection"] as? Bool {
            passioConfig.allowInternetConnection = allowInternetConnection
        }
        
        if let filesLocalURLs = arguments["filesLocalURLs"] as? [FileLocalURL] {
            passioConfig.filesLocalURLs = filesLocalURLs
        }
        
        if let remoteOnly = arguments["remoteOnly"] as? Bool {
            passioConfig.remoteOnly = remoteOnly
        }
//        if let overrideInstalledVersion = arguments["overrideInstalledVersion"] as? Bool {
//            // not exposed in iOS Nutrition AI
//        }
        
        if let debugMode = arguments["debugMode"] as? Int {
            passioConfig.debugMode = debugMode
        }
        
        let passioSDK = PassioNutritionAI.shared
        passioSDK.configure(passioConfiguration: passioConfig) { status in
            if status.mode == .isReadyForDetection ||
                status.mode == .failedToConfigure {
                let resultStatus = self.outputConverter.mapFromPassioStatus(passioStatus: status)
                result(resultStatus)
            }
        }
    }
    
    func detectFoodIn(arguments: Any?, result: @escaping FlutterResult) {
        
        guard let arguments = arguments as? [String: Any],
              let bytes = arguments["bytes"] as? FlutterStandardTypedData,
              let configMap = arguments["config"] as? [String: Any] else {
            result("Fail to configure no arguments")
            return
        }
        let config = inputConverter.mapToFoodDetectionConfiguration(map: configMap)
        guard let image = UIImage(data: bytes.data) else {
            result("Can't convert the image to UIImage")
            return
        }
        passioSDK.detectFoodIn(image: image , detectionConfig: config) { candidates in
            if let candidates = candidates {
                let foodCandidates = self.outputConverter.mapFromFoodCandidates(candidates: candidates)
                result(foodCandidates)
            } else {
                result(nil)
            }
        }
    }
    
    func lookupIconsFor(arguments: Any?, result: @escaping FlutterResult) {
        guard  let configMap = arguments as? [String: Any],
               let passioID = configMap["passioID"] as? String,
               let iconSizeString = configMap["iconSize"] as? String,
               let typeString = configMap["type"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
            return
        }
        let iconSize = inputConverter.iconSizeFromString(iconSizeString)
        let entityType = inputConverter.entityTypeFromString(typeString)
        let (placeHolderIcon,icon) = passioSDK.lookupIconsFor(passioID: passioID,
                                                              size: iconSize,
                                                              entityType: entityType)

        var placeHolderIconMap = [String: Any]()
        if let placeHolderData = placeHolderIcon.pngData() {
            placeHolderIconMap["width"] = Int(placeHolderIcon.size.width)
            placeHolderIconMap["height"] = Int(placeHolderIcon.size.height)
            placeHolderIconMap["pixels"] = FlutterStandardTypedData(bytes: placeHolderData)
        }
        
        var iconMap: [String: Any]?
        if let icon = icon, let iconMapdata = icon.pngData() {
            iconMap = [:]
            iconMap?["width"] = Int(icon.size.width)
            iconMap?["height"] = Int(icon.size.height)
            iconMap?["pixels"] = FlutterStandardTypedData(bytes: iconMapdata)
        }
        
        var resultMap = [String: Any]()
        resultMap["defaultIcon"] = placeHolderIconMap
        resultMap["cachedIcon"] = iconMap
        result(resultMap)
    }
    
    func fetchIconFor(arguments: Any?, result: @escaping FlutterResult) {
        guard  let configMap = arguments as? [String: Any],
               let passioID = configMap["passioID"] as? String,
               let iconSizeString = configMap["iconSize"] as? String else {
            result (nil)
            return
        }
        let size = inputConverter.iconSizeFromString(iconSizeString)
        passioSDK.fetchIconFor(passioID: passioID, size: size) { image in
            guard let image = image else {
                result (nil)
                return
            }
            guard let data = image.pngData() else {
                result (nil)
                return
            }
            var imageMap = [String: Any]()
            imageMap["width"] = Int(image.size.width)
            imageMap["height"] = Int(image.size.height)
            imageMap["pixels"] = FlutterStandardTypedData(bytes: data)
            result(imageMap)
        }
    }
    
    func iconURLFor(arguments: Any?, result: @escaping FlutterResult) {
        guard  let configMap = arguments as? [String: Any],
               let passioID = configMap["passioID"] as? String,
               let iconSizeString = configMap["iconSize"] as? String
                else {
            result ("")
            return
        }
        let iconSize = inputConverter.iconSizeFromString(iconSizeString)
        let urlString = passioSDK.iconURLFor(passioID: passioID, size: iconSize)?.absoluteString ?? ""
        result(urlString)
    }
    
    func fetchFoodItemForPassioID(arguments: Any?, result: @escaping FlutterResult) {
        if let passioID = arguments as? PassioID {
            passioSDK.fetchFoodItemFor(passioID: passioID) { passioFoodItem in
                let passioFoodItemMap = self.outputConverter.mapFromPassioFoodItem(foodItem: passioFoodItem)
                result(passioFoodItemMap)
            }
        } else {
            result(nil)
        }
    }
    
    func fetchFoodItemForProductCode(arguments: Any?, result: @escaping FlutterResult) {
        if let productCode = arguments as? String {
            passioSDK.fetchFoodItemFor(productCode: productCode) { passioFoodItem in
                let passioFoodItemMap = self.outputConverter.mapFromPassioFoodItem(foodItem: passioFoodItem)
                result(passioFoodItemMap)
            }
        } else {
            result(nil)
        }
    }
    
    func searchForFood(arguments: Any?, result: @escaping FlutterResult) {
        if let byText = arguments as? String {
            passioSDK.searchForFood(byText: byText) { searchResponse in
                var searchMap: [String: Any?] = [:]
                searchMap["results"] = (searchResponse?.results.map{ self.outputConverter.mapFromPassioFoodDataInfo(passioFoodDataInfo: $0) } ?? [] ).compactMap({$0})
                searchMap["alternateNames"] = searchResponse?.alternateNames ?? []
                result(searchMap)
            }
        } else {
            result(nil)
        }
    }
    
    func fetchFoodItemForDataInfo(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any] else {
            result(nil)
            return
        }
        let foodDataInfo = inputConverter.mapToFetchFoodItemForDataInfo(map: args)
        if let foodItem = foodDataInfo.foodDataInfo {
            passioSDK.fetchFoodItemFor(foodItem: foodItem, weightGrams: foodDataInfo.weightGrams) { passioFoodItem in
                let passioFoodItemMap = self.outputConverter.mapFromPassioFoodItem(foodItem: passioFoodItem)
                result(passioFoodItemMap)
            }
        } else {
            result(nil)
        }
    }

    func fetchTagsFor(arguments: Any?, result: @escaping FlutterResult) {
        if let passioID = arguments as? PassioID {
            passioSDK.fetchTagsFor(passioID: passioID) { tags in
                result(tags)
            }
        } else {
            result(nil)
        }
    }
    
    
    func transformCGRectForm(arguments: Any?, result: @escaping FlutterResult) {
     
        guard  let configMap = arguments as? [String: Any],
               let mBoundingBox = configMap["boundingBox"] as? [String: Any],
               let boundingBox = inputConverter.mapToBoundingBox(box: mBoundingBox),
               let mToRect = configMap["toRect"] as? [String: Any],
               let toRect = inputConverter.mapToBoundingBox(box: mToRect)
                else {
            result (FlutterError())
            return
        }
        let newBoundingBox = passioSDK.transformCGRectForm(boundingBox: boundingBox, toRect: toRect)
        let fResult = outputConverter.mapFromBoundingBox(boundingBox: newBoundingBox)
        result(fResult)
    }
    
    /**
     Fetches nutrients for a given PassioID.

     - Parameters:
        - arguments: Flutter method call arguments.
        - result: Closure to report the result back to Flutter.

     - Note: Intended to be called from Flutter using platform channels.
     */
    func fetchInflammatoryEffectData(arguments: Any?, result: @escaping FlutterResult) {
        // Check if the provided argument is a PassioID
        if let passioID = arguments as? PassioID {
            // Call PassioSDK to fetch nutrients for the given passioID
            passioSDK.fetchInflammatoryEffectData(passioID: passioID) { inflammatoryData in
                // Check if nutrients is not nil
                if let inflammatoryEffectData = inflammatoryData {
                    // Map PassioNutrient objects to a new list using mapFromPassioNutrient function
                    let resultList = inflammatoryEffectData.map { self.outputConverter.mapFromInflammatoryEffectData(inflammatoryEffectData: $0) }
                    // Call the FlutterResult with the resultList
                    result(resultList)
                } else {
                    // Call the FlutterResult with nil if nutrients is nil
                    result(nil)
                }
            }
        } else {
            // Call the FlutterResult with nil if the argument is not a PassioID
            result(nil)
        }
    }
    
    func fetchSuggestions(arguments: Any?, result: @escaping FlutterResult) {
        // Check if the provided argument is a PassioID
        if let mealTimeString = arguments as? String, let mealTime = PassioMealTime(rawValue: mealTimeString) {
            passioSDK.fetchSuggestions(mealTime: mealTime) { suggestions in
                let resultList = suggestions.map {
                    self.outputConverter.mapFromPassioFoodDataInfo(passioFoodDataInfo: $0)
                }
                result(resultList)
            }
        } else {
            // Call the FlutterResult with empty list if the argument is not a mealTime
            result([])
        }
    }
    
    func fetchMealPlans(arguments: Any?, result: @escaping FlutterResult) {
        passioSDK.fetchMealPlans() { mealPlans in
            let resultList = mealPlans.map {
                self.outputConverter.mapFromPassioMealPlan(passioMealPlan: $0)
            }
            result(resultList)
        }
    }
    
    func fetchMealPlanForDay(arguments: Any?, result: @escaping FlutterResult) {
        
        guard let args = arguments as? [String: Any],
              let mealPlanLabel = args["mealPlanLabel"] as? String,
              let day = args["day"] as? Int
                else {
            result([])
            return
        }
        passioSDK.fetchMealPlanForDay(mealPlanLabel: mealPlanLabel, day: day) { mealPlanItems in
            let resultList = mealPlanItems.map {
                self.outputConverter.mapFromPassioMealPlanItem(passioMealPlanItem: $0)
            }
            result(resultList)
        }
    }
    
    func fetchFoodItemForRefCode(arguments: Any?, result: @escaping FlutterResult) {
        if let refCode = arguments as? String {
            passioSDK.fetchFoodItemFor(refCode: refCode) { passioFoodItem in
                let passioFoodItemMap = self.outputConverter.mapFromPassioFoodItem(foodItem: passioFoodItem)
                result(passioFoodItemMap)
            }
        } else {
            result(nil)
        }
    }
    
    func fetchFoodItemLegacy(arguments: Any?, result: @escaping FlutterResult) {
        if let passioID = arguments as? PassioID {
            passioSDK.fetchFoodItemLegacy(from: passioID) { passioFoodItem in
                let passioFoodItemMap = self.outputConverter.mapFromPassioFoodItem(foodItem: passioFoodItem)
                result(passioFoodItemMap)
            }
        } else {
            result(nil)
        }
    }
    
    func recognizeSpeechRemote(arguments: Any?, result: @escaping FlutterResult) {
        if let text = arguments as? String {
            passioSDK.recognizeSpeechRemote(from: text) { speechRecognitionModel in
                let resultList = speechRecognitionModel.map {
                    self.outputConverter.mapFromPassioSpeechRecognitionModel(passioSpeechRecognitionModel: $0)
                }
                result(resultList)
            }
        } else {
            result(nil)
        }
    }
    
    func recognizeImageRemote(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let bytes = args["bytes"] as? FlutterStandardTypedData,
              let resolution = args["resolution"] as? String else {
            result(nil)
            return
        }
        let message = args["message"] as? String
        let resolutionEnum = getPassioImageResolution(res: resolution)
        guard let image = UIImage(data: bytes.data) else {
            result(nil)
            return
        }
        passioSDK.recognizeImageRemote(image: image, resolution: resolutionEnum, message: message) { imageRecognitionModel in
            let resultList = imageRecognitionModel.map {
                self.outputConverter.mapFromPassioAdvisorFoodInfo(passioAdvisorFoodInfo: $0)
            }
            result(resultList)
        }
    }
    
    private func fetchHiddenIngredients(arguments: Any?, result: @escaping FlutterResult) {
        guard let foodName = arguments as? String else {
            result(FlutterError(code: "ERRRO", message: "foodName must not be null or empty.", details: nil))
            return
        }
    
        passioSDK.fetchHiddenIngredients(foodName: foodName) { callback in
            result(self.outputConverter.mapFromPassioResult(nutritionAdvisorStatus: callback))
        }
    }
    
    private func fetchVisualAlternatives(arguments: Any?, result: @escaping FlutterResult) {
        guard let foodName = arguments as? String else {
            result(FlutterError(code: "ERRRO", message: "foodName must not be null or empty.", details: nil))
            return
        }
    
        passioSDK.fetchVisualAlternatives(foodName: foodName) { callback in
            result(self.outputConverter.mapFromPassioResult(nutritionAdvisorStatus: callback))
        }
    }
    
    private func fetchPossibleIngredients(arguments: Any?, result: @escaping FlutterResult) {
        guard let foodName = arguments as? String else {
            result(FlutterError(code: "ERRRO", message: "foodName must not be null or empty.", details: nil))
            return
        }
    
        passioSDK.fetchPossibleIngredients(foodName: foodName) { callback in
            result(self.outputConverter.mapFromPassioResult(nutritionAdvisorStatus: callback))
        }
    }
    
    private func enableFlashlight(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let enabled = args["enabled"] as? Bool,
              let levelDouble = args["level"] as? Double else {
            result(nil)
            return
        }
        let level = Float(levelDouble)
        passioSDK.enableFlashlight(enabled: enabled, level: level)
        result(nil)
    }
    
    private func setCameraZoom(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let zoomDouble = args["zoomLevel"] as? Double else {
            result(nil)
            return
        }
        let zoomLevel = CGFloat(zoomDouble)
        passioSDK.setCamera(toVideoZoomFactor: zoomLevel)
        result(nil)
    }
    
    private func getMinMaxCameraZoomLevel(arguments: Any?, result: @escaping FlutterResult) {
        let callback = passioSDK.getMinMaxCameraZoomLevel
        let mappedResult = self.outputConverter.mapFromMinMaxCameraZoomLevel(minMax: callback)
        result(mappedResult)
    }
    
    private func recognizeNutritionFactsRemote(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let bytes = args["bytes"] as? FlutterStandardTypedData,
              let resolution = args["resolution"] as? String else {
            result(nil)
            return
        }
        let resolutionEnum = getPassioImageResolution(res: resolution)
        guard let image = UIImage(data: bytes.data) else {
            result(nil)
            return
        }
        passioSDK.recognizeNutritionFactsRemote(image: image, resolution: resolutionEnum) { passioFoodItem in
            if let foodItem = passioFoodItem {
                let passioFoodItemMap = self.outputConverter.mapFromPassioFoodItem(foodItem: foodItem)
                result(passioFoodItemMap)
            } else {
                result(nil)
            }
        }
    }
    
    private func updateLanguage(arguments: Any?, result: @escaping FlutterResult) {
        guard let languageCode = arguments as? String else {
            result(false)
            return
        }
        result(passioSDK.updateLanguage(languageCode: languageCode))
    }
    
    private func getPassioImageResolution(res: String) -> PassioImageResolution {
        return switch res {
        case "full": .full
        case "res_1080": .res_1080
        case "res_512": .res_512
        default: .res_512
        }
    }
}
