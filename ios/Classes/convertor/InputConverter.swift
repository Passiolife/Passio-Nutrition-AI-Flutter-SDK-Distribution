import PassioNutritionAISDK

struct InputConverter {
    
    func iconSizeFromString(_ iconString: String?) -> IconSize {
        guard let iconString = iconString,
              let iconSize = IconSize(rawValue: iconString) else {
            return .px90
        }
        return iconSize
    }
    
    func entityTypeFromString(_ typeString: String) -> PassioIDEntityType {
        guard let entityType = PassioIDEntityType(rawValue: typeString) else {
            return .item
        }
        return entityType
    }
    
    func mapToFoodDetectionConfigurationWithArgs(args: [String: Any]) -> FoodDetectionConfiguration {
        if let map = args["args"] as? [String: Any]  {
            return mapToFoodDetectionConfiguration(map: map)
        } else {
            return FoodDetectionConfiguration()
        }
    }
    
    func mapToVolumeDetectionMode(fromSting: String) -> VolumeDetectionMode {
        switch fromSting {
        case "auto":
            return .auto
        case "builtInDualWideCamera":
            return .dualWideCamera
        case "none":
            return .none
        default:
            return .none
        }
    }
    
    func mapToFoodDetectionConfiguration(map: [String: Any]) -> FoodDetectionConfiguration {
        
        func mapToFPS(fromString: String) -> PassioNutritionAI.FramesPerSecond {
            switch fromString {
            case "one":
                return .one
            case "two":
                return .two
            case "three", "four", "max":
                return .three
            default:
                return .two
            }
        }
        
        
        var configuration = FoodDetectionConfiguration()
        if let detectVisual = map["detectVisual"] as? Int {
            configuration.detectVisual = detectVisual  == 1 ? true : false
        }
        if let detectBarcodes = map["detectBarcodes"] as? Int {
            configuration.detectBarcodes = detectBarcodes == 1 ? true : false
        }
        if let detectPackagedFood = map["detectPackagedFood"] as? Int {
            configuration.detectPackagedFood = detectPackagedFood == 1 ? true : false
        }
        if let framesPerSecondString = map["framesPerSecond"] as? String {
            configuration.framesPerSecond = mapToFPS(fromString: framesPerSecondString)
        }
        if let volumeString = map ["volumeDetectionMode"] as? String {
            configuration.volumeDetectionMode = mapToVolumeDetectionMode(fromSting: volumeString)
        }
        return configuration
    }
    
    func mapToBoundingBox(box :[String: Any]) -> CGRect? {
        guard let x = box["left"] as? Double,
              let y = box["top"] as? Double,
              let width = box["width"] as? Double,
              let height = box["height"] as? Double else {
            return nil
        }
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func mapToFetchFoodItemForDataInfo(map: [String: Any?]) -> (foodDataInfo: PassioFoodDataInfo?, weightGrams: Double?) {
        if let foodDataInfo = map["foodDataInfo"] as? [String: Any] {
            let passioFoodDataInfo = mapToPassioFoodDataInfo(map: foodDataInfo)
            let weightGrams = map["weightGrams"] as? Double
            return (passioFoodDataInfo, weightGrams)
        } else {
            return (nil, nil)
        }
    }
    
    func mapToPassioFoodDataInfo(map: [String: Any?]) -> PassioFoodDataInfo? {
        guard let type = map["type"] as? String,
              let foodName = map["foodName"] as? String,
              let score = map["score"] as? Double,
              let brandName = map["brandName"] as? String,
              let iconId = map["iconId"] as? PassioID,
              let labelId = map["labelId"] as? String,
              let scoredName = map["scoredName"] as? String,
              let resultId = map["resultId"] as? String,
              let isShortName = map["isShortName"] as? Bool,
              let nutritionPreview = mapToPassioSearchNutritionPreview(map: map["nutritionPreview"] as? [String : Any]) else {
            return nil;
        }
        return PassioFoodDataInfo(foodName: foodName, brandName: brandName, iconID: iconId, score: score, scoredName: scoredName, labelId: labelId, type: type, resultId: resultId, nutritionPreview: nutritionPreview, isShortName: isShortName)
    }
    
    private func mapToPassioSearchNutritionPreview(map :[String: Any?]?) -> PassioSearchNutritionPreview? {
        guard let map = map,
              let calories = map["calories"] as? Int,
              let carbs = map["carbs"] as? Double,
              let fat = map["fat"] as? Double,
              let fiber = map["fiber"] as? Double,
              let protein = map["protein"] as? Double,
              let servingUnit = map["servingUnit"] as? String,
              let servingQuantity = map["servingQuantity"] as? Double,
              let weightQuantity = map["weightQuantity"] as? Double,
              let weightUnit = map["weightUnit"] as? String else {
            return nil
        }
        return PassioSearchNutritionPreview(calories: calories, carbs: carbs, fat: fat, protein: protein, fiber: fiber, servingUnit: servingUnit, servingQuantity: servingQuantity, weightUnit: weightUnit, weightQuantity: weightQuantity)
    }
}

extension Dictionary {
    
    var toJSON: String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Unable to convert to json strin:- \(error.localizedDescription)")
        }
        return nil
    }

}
