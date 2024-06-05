import Flutter
import UIKit
import PassioNutritionAISDK

public class NutritionAdvisorHandler: NSObject, FlutterPlugin {
  
    let inputConverter = InputConverter()
    let outputConverter = OutputConverter()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "configure":
            configure(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "initConversation":
            initConversation() { FlutterResult in
                result(FlutterResult)
            }
        case "sendMessage":
            sendMessage(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "sendImage":
            sendImage(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        case "fetchIngredients":
            fetchIngredients(arguments: call.arguments) { FlutterResult in
                result(FlutterResult)
            }
        default:
            print("call.method = \(call.method) not in the list")
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func configure(arguments: Any?, result: @escaping FlutterResult) {
        if let key = arguments as? String {
            NutritionAdvisor.shared.configure(licenceKey: key) { status in
                result(self.outputConverter.mapFromPassioResult(nutritionAdvisorStatus: status))
            }
        } else {
            result(FlutterError(code: "ERRRO", message: "Key must not be null", details: nil))
        }
    }
    
    private func initConversation(result: @escaping FlutterResult) {
        NutritionAdvisor.shared.initConversation { callback in
            result(self.outputConverter.mapFromPassioResult(nutritionAdvisorStatus: callback))
        }
    }
    
    private func sendMessage(arguments: Any?, result: @escaping FlutterResult) {
        if let message  = arguments as? String {
            NutritionAdvisor.shared.sendMessage(message: message) { callback in
                result(self.outputConverter.mapFromPassioResult(nutritionAdvisorStatus: callback))
            }
        } else {
            result(FlutterError(code: "ERRRO", message: "Message must not be null", details: nil))
        }
    }
    
    private func sendImage(arguments: Any?, result: @escaping FlutterResult) {
        guard let bytes = arguments as? FlutterStandardTypedData,
              let image = UIImage(data: bytes.data) else {
            result(FlutterError(code: "ERRRO", message: "Image must not be null", details: nil))
            return
        }
        
        NutritionAdvisor.shared.sendImage(image: image) { callback in
            result(self.outputConverter.mapFromPassioResult(nutritionAdvisorStatus: callback))
        }
    }
    
    private func fetchIngredients(arguments: Any?, result: @escaping FlutterResult) {
        guard let advisorResponseDict = arguments as? [String: Any],
              let advisorResponse = advisorResponseDict.getDecodableFrom(type: PassioAdvisorResponse.self) else {
            result(nil)
            return
        }

        NutritionAdvisor.shared.fetchIngridients(from: advisorResponse) { callback in
            result(self.outputConverter.mapFromPassioResult(nutritionAdvisorStatus: callback))
        }
    }
}
