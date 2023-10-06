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
        let channel = FlutterMethodChannel(name: "nutrition_ai/method",
                                           binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventChannel = FlutterEventChannel(name: "nutrition_ai/event/detection",
                                               binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(PassioEventStreamHandler())
        let factory = PassioPreviewFactory(messenger: registrar.messenger())
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
        case "searchForFood":
            searchForFood(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "lookupPassioAttributesFor":
            lookupPassioAttributesFor(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "fetchAttributesForBarcode":
            fetchAttributesForBarcode(arguments: call.arguments) { flutterResult in
                result(flutterResult)
            }
        case "fetchAttributesForPackagedFoodCode":
            fetchAttributesForPackagedFoodCode(arguments: call.arguments) { flutterResult in
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
                let resultStatus: [String: Any?] = [
                    "mode": "\(status.mode)",
                    "missingFiles": status.missingFiles,
                    "debugMessage": status.debugMessage,
                    "error": status.error != nil ? "\(status.error!)" : nil,
                    "activeModels": status.activeModels,
                ]
                result(resultStatus)
            }
        }
    }
    
    func detectFoodIn(arguments: Any?, result: @escaping FlutterResult) {
        
        guard let arguments = arguments as? [String: Any],
              let bytes = arguments["bytes"] as? FlutterStandardTypedData,
              //              let _ = arguments["extension"] as? String,
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
    
    func searchForFood(arguments: Any?, result: @escaping FlutterResult) {
        if let byText = arguments as? String {
            passioSDK.searchForFood(byText: byText) { passioIDAndNames in
                var resultList: [[String: String]] = []
                for passioIDAndName in passioIDAndNames {
                    let resultItem: [String: String] = [
                        "passioID": passioIDAndName.passioID,
                        "name": passioIDAndName.name,
                    ]
                    resultList.append(resultItem)
                }
                result(resultList)
            }
        } else {
            result("Fail to searchForFood")
        }
    }
    
    func lookupPassioAttributesFor(arguments: Any?, result: @escaping FlutterResult) {
        if let passioID = arguments as? PassioID,
           let pidATT = passioSDK.lookupPassioIDAttributesFor(passioID: passioID) {
            let attrMap = outputConverter.mapFromPassioIDAttributes(passioIDAttributes: pidATT)
            result(attrMap)
        } else {
            result(nil)
        }
    }
    
    func fetchAttributesForBarcode(arguments: Any?, result: @escaping FlutterResult) {
        if let barcode = arguments as? Barcode{
            passioSDK.fetchPassioIDAttributesFor(barcode: barcode){ pidATT in
                if let pidATT = pidATT {
                    let attrMap = self.outputConverter.mapFromPassioIDAttributes(passioIDAttributes: pidATT)
                    result(attrMap)
                } else {
                    result(nil)
                }
            }
        } else {
            result(nil)
        }
    }
    
    func fetchAttributesForPackagedFoodCode(arguments: Any?, result: @escaping FlutterResult) {
        if let packagedFoodCode = arguments as? PackagedFoodCode{
            passioSDK.fetchPassioIDAttributesFor(packagedFoodCode: packagedFoodCode) { pidATT in
                if let pidATT = pidATT {
                    let attrMap = self.outputConverter.mapFromPassioIDAttributes(passioIDAttributes: pidATT)
                    result(attrMap)
                } else {
                    result(nil)
                }
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
    
    
}


