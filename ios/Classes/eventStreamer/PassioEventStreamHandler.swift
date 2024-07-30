import PassioNutritionAISDK
import Flutter

class PassioEventStreamHandler: NSObject, FlutterStreamHandler {
    
    let passioSDK = PassioNutritionAI.shared
    private var eventSink: FlutterEventSink?
    private let outputConverter = OutputConverter()

    func onListen(withArguments arguments: Any?,
                  eventSink events: @escaping FlutterEventSink) -> FlutterError?
    {
        eventSink = events
        guard let argMap = arguments as? [String: Any],
              let method = argMap["method"] as? String
        else {
            return FlutterError(code: "On Listen", message: "no method", details: nil)
        }
        
        switch method {
        case "startFoodDetection":
            startFoodDetection(args: argMap)
        case "setPassioStatusListener":
            passioSDK.statusDelegate = self
        case "startNutritionFactsDetection":
            passioSDK.startNutritionFactsDetection(nutritionfactsDelegate: self) { value in }
        case "setAccountListener":
            passioSDK.accountDelegate = self
        default:
            return FlutterError(code: "method", message: "no method in switch", details: nil)
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        guard let argMap = arguments as? [String: Any],
              let method = argMap["method"] as? String else {
            return FlutterError(code: "onCancel", message: "no method", details: nil)
        }
        switch method {
        case "startFoodDetection":
            passioSDK.stopFoodDetection()
        case "setPassioStatusListener":
            passioSDK.statusDelegate = nil
        case "startNutritionFactsDetection":
            passioSDK.stopFoodDetection()
        case "setAccountListener":
            passioSDK.accountDelegate = nil
        default:
            return FlutterError(code: "onCancel", message: "no method in switch", details: nil)
        }
        eventSink = nil
        return nil
    }
    
    func sendEvent(data: Any) {
        if let eventSink = eventSink {
            eventSink(data)
        }
    }
    
    private func startFoodDetection(args: [String: Any]) {
        var config = FoodDetectionConfiguration()
        if let map = args["args"] as? [String: Any]  {
            config = InputConverter().mapToFoodDetectionConfiguration(map: map)
        }        
        passioSDK.startFoodDetection(detectionConfig: config,
                                     foodRecognitionDelegate: self){ ready in
        }
    }

//    private func getFoodImageData(img: UIImage) -> [String: Any?] {
//
//        var imageMap = [String: Any]()
//
//        if let imageData = img.pngData() {
//            imageMap["width"] = Int(img.size.width)
//            imageMap["height"] = Int(img.size.height)
//            imageMap["pixels"] = FlutterStandardTypedData(bytes: imageData)
//        }
//        return imageMap
//    }
}

extension PassioEventStreamHandler: FoodRecognitionDelegate {

    func recognitionResults(candidates: (PassioNutritionAISDK.FoodCandidates)?,
                            image : UIImage?) {

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in

            guard let self else { return }

            if let events = eventSink {
                if let candidates = candidates,
                   let img = image {
                    var finalEvents = [String: Any]()

                    let foodCandidates = self.outputConverter.mapFromFoodCandidates(candidates: candidates)
                    let foodImg = self.outputConverter.mapFromImage(img)

                    finalEvents["candidates"] = foodCandidates
                    finalEvents["image"] = foodImg

                    DispatchQueue.main.async {
                        events(finalEvents)
                    }

                } else {
                    DispatchQueue.main.async {
                        events(nil)
                    }
                }
            }
        }
    }
}

// MARK: - PassioStatusDelegate Methods
extension PassioEventStreamHandler: PassioStatusDelegate {

    // MARK: passioStatusChanged Method
    func passioStatusChanged(status: PassioNutritionAISDK.PassioStatus) {
        // Check if the eventSink is available
        if let events = eventSink {
            // Convert PassioStatus to a map
            let statusMap = outputConverter.mapFromPassioStatus(passioStatus: status)
            // Convert the map to a PassioStatusListener map with the event name
            let statusListenerMap = outputConverter.mapFromPassioStatusListener(event: "passioStatusChanged", data: statusMap)
            // Dispatch the UI-related operations on the main thread to ensure UI updates happen promptly.
            DispatchQueue.main.async {
                // Send the PassioStatusListener map through the eventSink
                events(statusListenerMap)
            }

        }
    }

    // MARK: passioProcessing Method
    func passioProcessing(filesLeft: Int) {
        // Check if the eventSink is available
        if let events = eventSink {
            // Dispatch the UI-related operations on the main thread to ensure UI updates happen promptly.
            DispatchQueue.main.async {
                // Convert filesLeft to a PassioStatusListener map with the event name
                events(self.outputConverter.mapFromPassioStatusListener(event: "passioProcessing", data: filesLeft))
            }
        }
    }

    // MARK: completedDownloadingAllFiles Method
    func completedDownloadingAllFiles(filesLocalURLs: [PassioNutritionAISDK.FileLocalURL]) {
        // Check if the eventSink is available
        if let events = eventSink {
            // Convert FileLocalURLs to an array of file URLs as strings
            let filesMap = filesLocalURLs.map { $0.absoluteString }
            // Convert the array of file URLs to a PassioStatusListener map with the event name
            let statusListenerMap = outputConverter.mapFromPassioStatusListener(event: "completedDownloadingAllFiles", data: filesMap)
            // Dispatch the UI-related operations on the main thread to ensure UI updates happen promptly.
            DispatchQueue.main.async {
                // Send the PassioStatusListener map through the eventSink
                events(statusListenerMap)
            }
        }
    }

    // MARK: completedDownloadingFile Method
    func completedDownloadingFile(fileLocalURL: PassioNutritionAISDK.FileLocalURL, filesLeft: Int) {
        // Check if the eventSink is available
        if let events = eventSink {
            // Convert the completed downloading file details to a PassioStatusListener map with the event name
            let downloadingMap = outputConverter.mapFromCompletedDownloadingFile(fileUri: fileLocalURL, filesLeft: filesLeft)
            let statusListenerMap = outputConverter.mapFromPassioStatusListener(event: "completedDownloadingFile", data: downloadingMap)
            // Dispatch the UI-related operations on the main thread to ensure UI updates happen promptly.
            DispatchQueue.main.async {
                // Send the PassioStatusListener map through the eventSink
                events(statusListenerMap)
            }
        }
    }

    // MARK: downloadingError Method
    func downloadingError(message: String) {
        // Check if the eventSink is available
        if let events = eventSink {
            // Dispatch the UI-related operations on the main thread to ensure UI updates happen promptly.
            DispatchQueue.main.async {
                // Convert the error message to a PassioStatusListener map with the event name
                events(self.outputConverter.mapFromPassioStatusListener(event: "downloadingError", data: message))
            }

        }
    }
}

extension PassioEventStreamHandler: NutritionFactsDelegate {
    func recognitionResults(nutritionFacts: PassioNutritionFacts?, text: String?) {
        if let events = eventSink {
            DispatchQueue.main.async {
                events(self.outputConverter.mapFromNutritionFactsRecognitionListener(nutritionFacts: nutritionFacts, text: text))
            }
        }
    }
}

// MARK: - PassioAccountDelegate Extension
extension PassioEventStreamHandler: PassioAccountDelegate {
    /// Called when the token budget is updated.
    ///
    /// - Parameter tokenBudget: The updated token budget information.
    func tokenBudgetUpdated(tokenBudget: PassioTokenBudget) {
        if let events = eventSink {
            // Dispatch the token budget update to the main thread
            DispatchQueue.main.async {
                // Convert the PassioTokenBudget object to a map and send it through the eventSink
                events(self.outputConverter.mapFromPassioTokenBudget(tokenBudget: tokenBudget))
            }
        }
    }
}
