import PassioNutritionAISDK
import Flutter

class PassioEventStreamHandler: NSObject, FlutterStreamHandler {
    
    let passioSDK = PassioNutritionAI.shared
    private var eventSink: FlutterEventSink?
    
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
    
}

extension PassioEventStreamHandler: FoodRecognitionDelegate {
    
    func recognitionResults(candidates: (PassioNutritionAISDK.FoodCandidates)?,
                            image _: UIImage?,
                            nutritionFacts _: PassioNutritionAISDK.PassioNutritionFacts?){
        if let events = eventSink{
            if let candidates = candidates {
                let foodCandidates = OutputConverter().mapFromFoodCandidates(candidates: candidates)
                events(foodCandidates)
            } else {
                events(nil)
            }
        }
    }
    
    
    
}
