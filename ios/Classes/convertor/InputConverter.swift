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
    
    func mapToFetchFoodItemForDataInfo(map: [String: Any?]) -> (foodDataInfo: PassioFoodDataInfo?, servingQuantity: Double?, servingUnit: String?) {
        if let foodDataInfo = map["foodDataInfo"] as? [String: Any] {
            let passioFoodDataInfo = mapToPassioFoodDataInfo(map: foodDataInfo)
            let servingQuantity = map["servingQuantity"] as? Double
            let servingUnit = map["servingUnit"] as? String
            return (passioFoodDataInfo, servingQuantity, servingUnit)
        } else {
            return (nil, nil, nil)
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
        let tags = map["tags"] as? [String]
        return PassioFoodDataInfo(foodName: foodName, brandName: brandName, iconID: iconId, score: score, scoredName: scoredName, labelId: labelId, type: type, resultId: resultId, nutritionPreview: nutritionPreview, isShortName: isShortName, tags: tags)
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
    
    func mapToPassioFoodItem(map :[String: Any?]?) -> PassioFoodItem? {
        guard let map = map else {
            return nil
        }
        let id = map["id"] as! String
        let scannedId = map["scannedId"] as! PassioNutritionAISDK.PassioID
        let name = map["name"] as! String
        let details = map["details"] as! String
        let iconId = map["iconId"] as! String
        let licenseCopy = ""
        let amount = mapToPassioFoodAmount(map: map["amount"] as! [String : Any?])
        
        let ingredientsInMap = map["ingredients"] as! [[String: Any?]]
        let ingredients = ingredientsInMap.map { mapToPassioIngredient(map: $0) }
        
        let refCode = (map["refCode"] as? String) ?? ""
        
        let tags = map["tags"] as? [String]
        
        return PassioFoodItem(id: id, scannedId: scannedId, name: name, details: details, iconId: iconId, licenseCopy: licenseCopy, amount: amount, ingredients: ingredients, refCode: refCode, tags: tags)
    }
    
    func mapToPassioFoodAmount(map :[String: Any?]) -> PassioFoodAmount {
        let servingSizesMap = map["servingSizes"] as! [[String: Any?]]
        let servingSizes = servingSizesMap.map { mapToPassioServingSize(map: $0)}
        
        let servingUnitsMap = map["servingUnits"] as! [[String: Any?]]
        let servingUnits = servingUnitsMap.map { mapToPassioServingUnit(map: $0)}
        
        let selectedUnit = map["selectedUnit"] as! String
        let selectedQuantity = map["selectedQuantity"] as! Double
        
        var amount = PassioFoodAmount(servingSizes: servingSizes, servingUnits: servingUnits)
        amount.selectedUnit = selectedUnit
        amount.selectedQuantity = selectedQuantity
        
        return amount
    }
    
    func mapToPassioServingSize(map :[String: Any?]) -> PassioServingSize {
        let quantity = map["quantity"] as! Double
        let unitName = map["unitName"] as! String
        
        return PassioServingSize(quantity: quantity, unitName: unitName)
    }
    
    func mapToPassioServingUnit(map :[String: Any?]) -> PassioServingUnit {
        let unitName = map["unitName"] as! String
        let weightInMap = map["weight"] as! [String: Any?]
        let weight = mapToMeasurementUnitMass(map: weightInMap)!
        
        return PassioServingUnit(unitName: unitName, weight: weight)
    }
    
    func mapToMeasurementUnitMass(map :[String: Any?]?) -> Measurement<UnitMass>? {
        guard let map = map else {
            return nil
        }
        let value = map["value"] as! Double
        let unitInString = map["unit"] as! String
        let unit = mapToUnitMass(unit: unitInString)
        
        return Measurement(value: value, unit: unit)
    }
    
    func mapToMeasurementUnitEnergy(map :[String: Any?]?) -> Measurement<UnitEnergy>? {
        guard let map = map else {
            return nil
        }
        let value = map["value"] as! Double
        let unitInString = map["unit"] as! String
        let unit = mapToUnitEnergy(unit: unitInString)
        
        return Measurement(value: value, unit: unit)
    }
    
    func mapToMeasurementUnitIU(map :[String: Any?]?) -> Double? {
        guard let map = map else {
            return nil
        }
        let value = map["value"] as! Double
            
        return value
    }
    
    func mapToUnitMass(unit: String) -> UnitMass {
        switch unit {
        case "kilograms":
            return UnitMass.kilograms
        case "milligrams":
            return UnitMass.milligrams
        case "micrograms":
            return UnitMass.micrograms
        case "milliliter":
            return UnitMass.grams
        default:
            return UnitMass.grams
        }
    }
    
    func mapToUnitEnergy(unit: String) -> UnitEnergy {
        return UnitEnergy.kilocalories
    }
    
    func mapToPassioIngredient(map: [String: Any?]) -> PassioIngredient {
        let id = map["id"] as! String
        let name = map["name"] as! String
        let iconId = map["iconId"] as! String
        let amount = mapToPassioFoodAmount(map: map["amount"] as! [String : Any?])
        let referenceNutrients = mapToPassioNutrients(map: map["referenceNutrients"] as! [String : Any?])
        let metadata = mapToPassioFoodMetadata(map: map["metadata"] as! [String : Any?])
        let refCode = map["refCode"] as! String
        let tags = map["tags"] as? [String]
        
        return PassioIngredient(id: id, name: name, iconId: iconId, amount: amount, referenceNutrients: referenceNutrients, metadata: metadata, refCode: refCode, tags: tags)
    }
    
    func mapToPassioNutrients(map: [String: Any?]) -> PassioNutrients {
        let weight = mapToMeasurementUnitMass(map: map["weight"] as? [String : Any?])!
        let alcohol = mapToMeasurementUnitMass(map: map["alcohol"] as? [String : Any?])
        let calcium = mapToMeasurementUnitMass(map: map["calcium"] as? [String : Any?])
        let calories = mapToMeasurementUnitEnergy(map: map["calories"] as? [String : Any?])
        let carbs = mapToMeasurementUnitMass(map: map["carbs"] as? [String : Any?])
        let cholesterol = mapToMeasurementUnitMass(map: map["cholesterol"] as? [String : Any?])
        let chromium = mapToMeasurementUnitMass(map: map["chromium"] as? [String : Any?])
        let fat = mapToMeasurementUnitMass(map: map["fat"] as? [String : Any?])
        let fibers = mapToMeasurementUnitMass(map: map["fibers"] as? [String : Any?])
        let folicAcid = mapToMeasurementUnitMass(map: map["folicAcid"] as? [String : Any?])
        let iodine = mapToMeasurementUnitMass(map: map["iodine"] as? [String : Any?])
        let iron = mapToMeasurementUnitMass(map: map["iron"] as? [String : Any?])
        let magnesium = mapToMeasurementUnitMass(map: map["magnesium"] as? [String : Any?])
        let monounsaturatedFat = mapToMeasurementUnitMass(map: map["monounsaturatedFat"] as? [String : Any?])
        let phosphorus = mapToMeasurementUnitMass(map: map["phosphorus"] as? [String : Any?])
        let polyunsaturatedFat = mapToMeasurementUnitMass(map: map["polyunsaturatedFat"] as? [String : Any?])
        let potassium = mapToMeasurementUnitMass(map: map["potassium"] as? [String : Any?])
        let proteins = mapToMeasurementUnitMass(map: map["proteins"] as? [String : Any?])
        let satFat = mapToMeasurementUnitMass(map: map["satFat"] as? [String : Any?])
        let selenium = mapToMeasurementUnitMass(map: map["selenium"] as? [String : Any?])
        let sodium = mapToMeasurementUnitMass(map: map["sodium"] as? [String : Any?])
        let sugars = mapToMeasurementUnitMass(map: map["sugars"] as? [String : Any?])
        let sugarsAdded = mapToMeasurementUnitMass(map: map["sugarsAdded"] as? [String : Any?])
        let sugarAlcohol = mapToMeasurementUnitMass(map: map["sugarAlcohol"] as? [String : Any?])
        let transFat = mapToMeasurementUnitMass(map: map["transFat"] as? [String : Any?])
        let vitaminA = mapToMeasurementUnitIU(map: map["vitaminA"] as? [String : Any?])
        let vitaminB6 = mapToMeasurementUnitMass(map: map["vitaminB6"] as? [String : Any?])
        let vitaminB12 = mapToMeasurementUnitMass(map: map["vitaminB12"] as? [String : Any?])
        let vitaminB12Added = mapToMeasurementUnitMass(map: map["vitaminB12Added"] as? [String : Any?])
        let vitaminC = mapToMeasurementUnitMass(map: map["vitaminC"] as? [String : Any?])
        let vitaminD = mapToMeasurementUnitMass(map: map["vitaminD"] as? [String : Any?])
        let vitaminE = mapToMeasurementUnitMass(map: map["vitaminE"] as? [String : Any?])
        let vitaminEAdded = mapToMeasurementUnitMass(map: map["vitaminEAdded"] as? [String : Any?])
        let vitaminKDihydrophylloquinone = mapToMeasurementUnitMass(map: map["vitaminKDihydrophylloquinone"] as? [String : Any?])
        let vitaminKMenaquinone4 = mapToMeasurementUnitMass(map: map["vitaminKMenaquinone4"] as? [String : Any?])
        let vitaminKPhylloquinone = mapToMeasurementUnitMass(map: map["vitaminKPhylloquinone"] as? [String : Any?])
        let vitaminARAE = mapToMeasurementUnitMass(map: map["vitaminARAE"] as? [String : Any?])
        let zinc = mapToMeasurementUnitMass(map: map["zinc"] as? [String : Any?])
        
        return PassioNutrients(fat: fat, satFat: satFat, monounsaturatedFat: monounsaturatedFat, polyunsaturatedFat: polyunsaturatedFat, proteins: proteins, carbs: carbs, calories: calories, cholesterol: cholesterol, sodium: sodium, fibers: fibers, transFat: transFat, sugars: sugars, sugarsAdded: sugarsAdded, alcohol: alcohol, iron: iron, vitaminC: vitaminC, vitaminA: vitaminA, vitaminA_RAE: vitaminARAE, vitaminD: vitaminD, vitaminB6: vitaminB6, vitaminB12: vitaminB12, vitaminB12Added: vitaminB12Added, vitaminE: vitaminE, vitaminEAdded: vitaminEAdded, iodine: iodine, calcium: calcium, potassium: potassium, magnesium: magnesium, phosphorus: phosphorus, sugarAlcohol: sugarAlcohol, zinc: zinc, selenium: selenium, folicAcid: folicAcid, chromium: chromium, vitaminKPhylloquinone: vitaminKPhylloquinone, vitaminKMenaquinone4: vitaminKMenaquinone4, vitaminKDihydrophylloquinone: vitaminKDihydrophylloquinone, weight: weight)
    }
    
    func mapToPassioFoodMetadata(map: [String: Any?]) -> PassioFoodMetadata {
        let foodOriginsInMap = map["foodOrigins"] as? [[String: Any?]]
        let foodOrigins = foodOriginsInMap?.map { mapToPassioFoodOrigin(map: $0)! }
        
        let barcode = map["barcode"] as? Barcode
        let ingredientsDescription = map["ingredientsDescription"] as? String
        let tags = map["tags"] as? [String]
        
        return PassioFoodMetadata(foodOrigins: foodOrigins, barcode: barcode, ingredientsDescription: ingredientsDescription, tags: tags)
    }
    
    func mapToPassioFoodOrigin(map: [String: Any?]) -> PassioFoodOrigin? {
        let id = map["id"] as! String
        let source = map["source"] as! String
        let licenseCopy = map["licenseCopy"] as? String
        
        return PassioFoodOrigin(id: id, source: source, licenseCopy: licenseCopy)
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
