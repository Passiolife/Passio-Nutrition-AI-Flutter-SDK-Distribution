import PassioNutritionAISDK
import Flutter

struct OutputConverter {

 func mapFromFoodCandidates(candidates: FoodCandidates) -> [String: Any?] {
        var candidatesMap: [String: Any?] = [:]
        
        let detectedCandidates = candidates.detectedCandidates
        let mappedCandidates = detectedCandidates.map {
            mapFromDetectedCandidate(detectedCandidate: $0)
        }
        candidatesMap["detectedCandidate"] = mappedCandidates
        
        if let barcodeCandidates = candidates.barcodeCandidates {
            let mappedCandidates = barcodeCandidates.map {
                mapFromBarcodeCandidate(barcodeCandidate: $0)
            }
            candidatesMap["barcodeCandidates"] = mappedCandidates
        }
        
        if let packagedFoodCandidates = candidates.packagedFoodCandidates {
            let mappedCandidates = packagedFoodCandidates.map {
                mapFromPackagedFoodCandidate(packagedFoodCandidate: $0)
            }
            candidatesMap["packagedFoodCandidates"] = mappedCandidates
        }
        return candidatesMap
    }
    
    func mapFromDetectedCandidate(detectedCandidate: DetectedCandidate) -> [String: Any?] {
        var candidateMap: [String: Any?] = [:]
        candidateMap["alternatives"] = detectedCandidate.alternatives.map{ mapFromDetectedCandidate(detectedCandidate: $0)}
        if let amountEstimate = detectedCandidate.amountEstimate {
            candidateMap["amountEstimate"] = mapAmounteEstimage(amountEstimate: amountEstimate )
        }
        candidateMap["boundingBox"] = mapFromBoundingBox(boundingBox: detectedCandidate.boundingBox)
        candidateMap["confidence"] = detectedCandidate.confidence
        candidateMap["croppedImage"] = mapFromImage(detectedCandidate.croppedImage)
        candidateMap["foodName"] = detectedCandidate.name
        candidateMap["passioID"] = detectedCandidate.passioID
        
        return candidateMap
    }
    
    func mapFromBarcodeCandidate(barcodeCandidate: BarcodeCandidate) -> [String: Any?] {
        var candidateMap: [String: Any?] = [:]
        candidateMap["value"] = barcodeCandidate.value
        let boundingBox = barcodeCandidate.boundingBox
        candidateMap["boundingBox"] = mapFromBoundingBox(boundingBox: boundingBox)
        return candidateMap
    }
    
    func mapFromBoundingBox(boundingBox: CGRect) -> [Double] { 
    return [
            boundingBox.origin.x,
            boundingBox.origin.y,
            boundingBox.width,
            boundingBox.height,
        ]
    }

    func mapFromPackagedFoodCandidate(packagedFoodCandidate: PackagedFoodCandidate) -> [String: Any?] {
        var candidateMap: [String: Any?] = [:]
        candidateMap["packagedFoodCode"] = packagedFoodCandidate.packagedFoodCode
        candidateMap["confidence"] = packagedFoodCandidate.confidence
        return candidateMap
    }
    
    private func mapFromServingSize(_ servingSize: PassioServingSize) -> [String: Any?] {
        var servingSizeMap = [String: Any?]()
        servingSizeMap["quantity"] = servingSize.quantity
        servingSizeMap["unitName"] = servingSize.unitName
        return servingSizeMap
    }
    
    private func mapFromServingUnit(_ servingUnit: PassioServingUnit) -> [String: Any?] {
        var servingUnitMap = [String: Any?]()
        servingUnitMap["unitName"] = servingUnit.unitName
        servingUnitMap["weight"] = mapFromUnitMass(servingUnit.weight)
        return servingUnitMap
    }
    
    private func mapFromFoodOrigin(_ origin: PassioFoodOrigin) -> [String: Any?] {
        var originMap = [String: Any?]()
        originMap["id"] = origin.id
        originMap["source"] = origin.source
        originMap["licenseCopy"] = origin.licenseCopy
        return originMap
    }
    
    private func mapFromUnitEnergy(_ unitEnergy: Measurement<UnitEnergy>?) -> [String: Any?]? {
        guard let unitEnergy = unitEnergy else { return nil }
        var unitEnergyMap = [String: Any?]()
        unitEnergyMap["unit"] = convertEnergyUnit(unitEnergy: unitEnergy.unit)
        unitEnergyMap["value"] = unitEnergy.value
        return unitEnergyMap
    }
    
    private func mapFromUnitMass(_ unitMass: Measurement<UnitMass>?) -> [String: Any?]? {
        guard let unitMass = unitMass else { return nil }
        var unitMassMap = [String: Any?]()
        let unit = convertMashUnit(unitMass: unitMass.unit)
        unitMassMap["unit"] = unit
        unitMassMap["value"] = unitMass.value
        return unitMassMap
    }
    
    private func mapFromUnitIU(_ value: Double?) -> [String: Any?]? {
        guard let value = value else { return nil }
        var unitEnergyMap = [String: Any?]()
        unitEnergyMap["unit"] = "iu"
        unitEnergyMap["value"] = value
        return unitEnergyMap
    }
    
    private func convertEnergyUnit(unitEnergy: UnitEnergy) -> String {
        unitEnergy.symbol.description == "kCal" ? "kilocalories" : unitEnergy.symbol.description
    }
    
    private func convertMashUnit(unitMass: UnitMass) -> String {
        switch unitMass.symbol.description {
        case "g","gr","ml":
            return "grams"
        case "kg":
            return "kilograms"
        case "mg":
            return "milligrams"
        case "µg":
            return "micrograms"
        default:
            return "grams"
        }
    }
    
    
    private func mapAmounteEstimage(amountEstimate: AmountEstimate ) -> [String: Any?] {
        var mapEstimate = [String: Any?]()
        if let volumeEstimate = amountEstimate.volumeEstimate {
            mapEstimate["volumeEstimate"] = volumeEstimate
        }
        if let weightEstimate = amountEstimate.weightEstimate {
            mapEstimate["weightEstimate"] = weightEstimate
        }
        if let estimationQuality = amountEstimate.estimationQuality?.rawValue {
            mapEstimate["estimationQuality"] = estimationQuality
        }
        if let moveDevice = amountEstimate.moveDevice?.rawValue {
            mapEstimate["moveDevice"] = moveDevice
        }
        if let viewingAngle = amountEstimate.viewingAngle {
            mapEstimate["viewingAngle"] = viewingAngle
        }
        return mapEstimate
    }

    // MARK: - PassioStatus Mapping
    // This method maps PassioStatus properties to a dictionary for event reporting.
    func mapFromPassioStatus(passioStatus: PassioStatus) -> [String: Any?] {
        // Initialize an empty dictionary to store the mapped status information.
        var statusMap = [String: Any?]()
        // Map PassioStatus properties to corresponding dictionary keys.
        statusMap["mode"] = "\(passioStatus.mode)"
        statusMap["missingFiles"] = passioStatus.missingFiles
        statusMap["debugMessage"] = passioStatus.debugMessage
        statusMap["error"] = passioStatus.error != nil ? "\(passioStatus.error!)" : nil
        statusMap["activeModels"] = passioStatus.activeModels
        // Return the dictionary containing the mapped PassioStatus information.
        return statusMap
    }

    // MARK: - Completed Downloading File Mapping
    // This method maps completed downloading file details to a dictionary for event reporting.
    func mapFromCompletedDownloadingFile(fileUri: FileLocalURL, filesLeft: Int) -> [String: Any?] {
        // Initialize an empty dictionary to store the mapped download information.
        var downloadMap = [String: Any?]()
        // Map completed downloading file details to corresponding dictionary keys.
        downloadMap["fileUri"] = fileUri.absoluteString
        downloadMap["filesLeft"] = filesLeft
        // Return the dictionary containing the mapped download information.
        return downloadMap
    }

    // MARK: - PassioStatusListener Mapping
    // This method maps an event and associated data to a dictionary for event reporting.
    func mapFromPassioStatusListener(event: String, data: Any?) -> [String: Any?] {
        // Initialize an empty dictionary to store the mapped event and data.
        var statusListenerMap = [String: Any?]()
        // Map event and data to corresponding dictionary keys.
        statusListenerMap["event"] = event
        statusListenerMap["data"] = data
        // Return the dictionary containing the mapped event and data.
        return statusListenerMap
    }
    
    /**
     MARK: - Data Mapping

     Converts a PassioNutrient object into a dictionary.
     */
    func mapFromInflammatoryEffectData(inflammatoryEffectData: InflammatoryEffectData) -> [String: Any?] {
        // Create a mutable map to store the serialized nutrient data.
        var inflammatoryMap = [String: Any?]()

        // Add nutrient properties to the map.
        inflammatoryMap["amount"] = inflammatoryEffectData.amount
        inflammatoryMap["inflammatoryEffectScore"] = inflammatoryEffectData.inflammatoryEffectScore
        inflammatoryMap["nutrient"] = inflammatoryEffectData.name
        inflammatoryMap["unit"] = inflammatoryEffectData.unit

        // Return the serialized nutrient map.
        return inflammatoryMap
    }
    
    func mapFromPassioFoodItem(foodItem: PassioFoodItem?) -> [String: Any?]? {
        guard let foodItem else { return nil }
        
        var dataMap = [String: Any?]()
        dataMap["amount"] = mapFromPassioFoodAmount(foodItem.amount)
        dataMap["details"] = foodItem.details
        dataMap["foodItemName"] = foodItem.foodItemName
        dataMap["iconId"] = foodItem.iconId
        dataMap["id"] = foodItem.id
        dataMap["ingredients"] = foodItem.ingredients.map { mapFromPassioIngredient($0) }
        dataMap["licenseCopy"] = foodItem.licenseCopy
        dataMap["name"] = foodItem.name
        dataMap["refCode"] = foodItem.refCode ?? ""
        dataMap["scannedId"] = foodItem.scannedId
        return dataMap
    }
    
    /// Maps a `PassioFoodAmount` object to a dictionary with optional values.
    ///
    /// - Parameters:
    ///   - amount: The `PassioFoodAmount` object to map.
    /// - Returns: A dictionary containing the mapped values.
    private func mapFromPassioFoodAmount(_ amount: PassioFoodAmount) -> [String: Any?] {
        // Initialize an empty dictionary to hold the mapped values
        var amountMap = [String: Any?]()
        // Map selected quantity to the dictionary
        amountMap["selectedQuantity"] = amount.selectedQuantity
        // Map selected unit to the dictionary
        amountMap["selectedUnit"] = amount.selectedUnit
        // Map serving sizes to the dictionary, converting each serving size object to a dictionary using `mapFromServingSize` function
        amountMap["servingSizes"] = amount.servingSizes.map { mapFromServingSize($0) }
        // Map serving units to the dictionary, converting each serving unit object to a dictionary using `mapFromServingUnit` function
        amountMap["servingUnits"] = amount.servingUnits.map { mapFromServingUnit($0) }
        // Return the mapped dictionary
        return amountMap
    }
    
    private func mapFromPassioIngredient(_ ingredient: PassioIngredient) -> [String: Any?] {
        var ingredientMap = [String: Any?]()
        ingredientMap["amount"] = mapFromPassioFoodAmount(ingredient.amount)
        ingredientMap["iconId"] = ingredient.iconId
        ingredientMap["id"] = ingredient.id
        ingredientMap["metadata"] = mapFromPassioFoodMetadata(ingredient.metadata)
        ingredientMap["name"] = ingredient.name
        ingredientMap["refCode"] = ingredient.refCode ?? ""
        ingredientMap["referenceNutrients"] = mapFromPassioNutrients(ingredient.referenceNutrients)
        return ingredientMap
    }
    
    private func mapFromPassioFoodMetadata(_ metadata: PassioFoodMetadata) -> [String: Any?] {
        var metadataMap = [String: Any?]()
        metadataMap["barcode"] = metadata.barcode
        metadataMap["foodOrigins"] = metadata.foodOrigins?.map { mapFromFoodOrigin($0) } ?? []
        metadataMap["ingredientsDescription"] = metadata.ingredientsDescription
        metadataMap["tags"] = metadata.tags?.map { $0 }
        return metadataMap
    }
    
    private func mapFromPassioNutrients(_ nutrients: PassioNutrients) -> [String: Any?] {
        var nutrientsMap = [String: Any?]()
        nutrientsMap["weight"] = mapFromUnitMass(nutrients.weight)
    
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
        nutrientsMap["vitaminKDihydrophylloquinone"] = mapFromUnitMass(nutrients.vitaminKDihydrophylloquinone())
        nutrientsMap["vitaminARAE"] = mapFromUnitMass(nutrients.vitaminA_RAE())
        return nutrientsMap
    }
    
    func mapFromImage(_ image: UIImage?) -> [String: Any?]? {
        guard let image else { return nil }
        
        var imageMap = [String: Any]()

        if let imageData = image.pngData() {
            imageMap["width"] = Int(image.size.width)
            imageMap["height"] = Int(image.size.height)
            imageMap["pixels"] = FlutterStandardTypedData(bytes: imageData)
        }
        return imageMap
    }
    
    // Search related
    func mapFromPassioFoodDataInfo(passioFoodDataInfo: PassioFoodDataInfo) -> [String: Any?]? {
        if let nutritionPreview = passioFoodDataInfo.nutritionPreview {
            var searchResultMap = [String: Any?]()
            searchResultMap["brandName"] = passioFoodDataInfo.brandName
            searchResultMap["foodName"] = passioFoodDataInfo.foodName
            searchResultMap["iconID"] = passioFoodDataInfo.iconID
            searchResultMap["labelId"] = passioFoodDataInfo.labelId
            searchResultMap["nutritionPreview"] = mapFromPassioSearchNutritionPreview(nutritionPreview)
            searchResultMap["resultId"] = passioFoodDataInfo.resultId
            searchResultMap["score"] = passioFoodDataInfo.score
            searchResultMap["scoredName"] = passioFoodDataInfo.scoredName
            searchResultMap["type"] = passioFoodDataInfo.type
            searchResultMap["isShortName"] = passioFoodDataInfo.isShortName
            searchResultMap["tags"] = passioFoodDataInfo.tags
            return searchResultMap
        }
        return nil
    }
    
    private func mapFromPassioSearchNutritionPreview(_ nutritionPreview: PassioSearchNutritionPreview) -> [String: Any?] {
        var nutritionPreviewMap = [String: Any?]()
        nutritionPreviewMap["calories"] = nutritionPreview.calories
        nutritionPreviewMap["carbs"] = nutritionPreview.carbs
        nutritionPreviewMap["fat"] = nutritionPreview.fat
        nutritionPreviewMap["protein"] = nutritionPreview.protein
        nutritionPreviewMap["fiber"] = nutritionPreview.fiber
        nutritionPreviewMap["servingUnit"] = nutritionPreview.servingUnit
        nutritionPreviewMap["servingQuantity"] = nutritionPreview.servingQuantity
        nutritionPreviewMap["weightQuantity"] = nutritionPreview.weightQuantity
        nutritionPreviewMap["weightUnit"] = nutritionPreview.weightUnit
        return nutritionPreviewMap
    }
    
    func mapFromPassioMealPlan(passioMealPlan: PassioMealPlan) -> [String: Any?] {
        var map = [String: Any?]()
        map["carbTarget"] = passioMealPlan.carbsTarget
        map["fatTarget"] = passioMealPlan.fatTarget
        map["mealPlanLabel"] = passioMealPlan.mealPlanLabel
        map["mealPlanTitle"] = passioMealPlan.mealPlanTitle
        map["proteinTarget"] = passioMealPlan.proteinTarget
        return map
    }
    
    func mapFromPassioMealPlanItem(passioMealPlanItem: PassioMealPlanItem) -> [String: Any?] {
        var map = [String: Any?]()
        map["dayNumber"] = passioMealPlanItem.dayNumber
        map["dayTitle"] = passioMealPlanItem.dayTitle
        if let meal = passioMealPlanItem.meal {
            map["meal"] = mapFromPassioFoodDataInfo(passioFoodDataInfo: meal)
        }
        map["mealTime"] = passioMealPlanItem.mealTime?.rawValue
        return map
    }
    
    func mapFromPassioSpeechRecognitionModel(passioSpeechRecognitionModel: PassioSpeechRecognitionModel) -> [String: Any?] {
        var map = [String: Any?]()
        map["action"] = passioSpeechRecognitionModel.action?.rawValue
        map["advisorInfo"] = mapFromPassioAdvisorFoodInfo(passioAdvisorFoodInfo: passioSpeechRecognitionModel.advisorFoodInfo)
        map["date"] = passioSpeechRecognitionModel.date
        map["mealTime"] = passioSpeechRecognitionModel.meal?.rawValue
        return map
    }
    
    func mapFromPassioAdvisorFoodInfo(passioAdvisorFoodInfo: PassioAdvisorFoodInfo) -> [String: Any?] {
        var map = [String: Any?]()
        map["foodDataInfo"] = passioAdvisorFoodInfo.foodDataInfo.map { mapFromPassioFoodDataInfo(passioFoodDataInfo: $0) }
        map["portionSize"] = passioAdvisorFoodInfo.portionSize
        map["recognisedName"] = passioAdvisorFoodInfo.recognisedName
        map["weightGrams"] = passioAdvisorFoodInfo.weightGrams
        map["packagedFoodItem"] = mapFromPassioFoodItem(foodItem: passioAdvisorFoodInfo.packagedFoodItem)
        map["resultType"] = passioAdvisorFoodInfo.resultType?.rawValue
        return map
    }
    
    func mapFromNutritionFactsRecognitionListener(nutritionFacts: PassioNutritionFacts?, text: String?) -> [String: Any?] {
        var map = [String: Any?]()
        map["nutritionFacts"] = mapFromPassioNutritionFacts(nutritionFacts: nutritionFacts)
        map["text"] = text
        return map
    }
    
    func mapFromPassioNutritionFacts(nutritionFacts: PassioNutritionFacts?) -> [String: Any?]? {
        guard let nutritionFacts else  { return nil }
        
        var map = [String: Any?]()
        map["addedSugar"] = nutritionFacts.addedSugar
        map["calcium"] = nutritionFacts.calcium
        map["calories"] = nutritionFacts.calories
        map["carbs"] = nutritionFacts.carbs
        map["cholesterol"] = nutritionFacts.cholesterol
        map["dietaryFiber"] = nutritionFacts.dietaryFiber
        map["fat"] = nutritionFacts.fat
        map["ingredients"] = nutritionFacts.ingredients
        map["iron"] = nutritionFacts.iron
        map["potassium"] = nutritionFacts.potassium
        map["protein"] = nutritionFacts.protein
        map["saturatedFat"] = nutritionFacts.saturatedFat
        map["servingSize"] = nutritionFacts.servingSizeText
        map["servingSizeQuantity"] = nutritionFacts.servingSizeQuantity
        map["servingSizeUnitName"] = nutritionFacts.servingSizeUnitName
        map["sodium"] = nutritionFacts.sodium
        map["sugarAlcohol"] = nutritionFacts.sugarAlcohol
        map["sugars"] = nutritionFacts.sugars
        map["transFat"] = nutritionFacts.transFat
        map["vitaminD"] = nutritionFacts.vitaminD
        return map
    }

    func mapFromPassioResult<T: Any>(nutritionAdvisorStatus: Result<T, PassioNutritionAISDK.NetworkError>) -> [String: Any?] {
        var map = [String: Any?]()
        switch nutritionAdvisorStatus {
        case .success(let success):
            var valueType: String? = nil
            var value: Any? = nil
            
            if success is PassioAdvisorResponse {
                valueType = "PassioAdvisorResponse"
                value = mapFromPassioAdvisorResponse(passioAdvisorResponse: success as! PassioAdvisorResponse)
            } else if success is [PassioAdvisorFoodInfo] {
                valueType = "PassioAdvisorFoodInfo"
                value = (success as! [PassioAdvisorFoodInfo]).map { mapFromPassioAdvisorFoodInfo(passioAdvisorFoodInfo: $0) }
            }
            
            map["status"] = "success"
            map["message"] = nil
            map["value"] = value
            map["valueType"] = valueType
            break
        case .failure(let error):
            map["status"] = "error"
            map["message"] = error.errorMessage
            map["value"] = nil
            map["valueType"] = nil
            break
        }
        return map
    }
    
    func mapFromPassioAdvisorResponse(passioAdvisorResponse: PassioAdvisorResponse) -> [String: Any?] {
        var map = [String: Any?]()
        map["extractedIngredients"] = passioAdvisorResponse.extractedIngredients?.map { mapFromPassioAdvisorFoodInfo(passioAdvisorFoodInfo: $0) }
        map["markupContent"] = passioAdvisorResponse.markupContent
        map["messageId"] = passioAdvisorResponse.messageId
        map["rawContent"] = passioAdvisorResponse.rawContent
        map["threadId"] = ""
        map["tools"] = passioAdvisorResponse.tools
        return map
    }
    
    func mapFromPassioTokenBudget(tokenBudget: PassioTokenBudget) -> [String: Any?] {
        var map = [String: Any?]()
        map["apiName"] = tokenBudget.apiName
        map["budgetCap"] = tokenBudget.budgetCap
        map["periodUsage"] = tokenBudget.periodUsage
        map["tokensUsed"] = tokenBudget.requestUsage
        return map
    }
    
    func mapFromMinMaxCameraZoomLevel(minMax: (minLevel: CGFloat?, maxLevel: CGFloat?)) -> [String: Any?] {
        var map = [String: Any?]()
        map["minZoomLevel"] = minMax.minLevel
        map["maxZoomLevel"] = minMax.maxLevel
        return map
    }
}

extension Encodable {
    
    /// Converting object to postable dictionary
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) -> [String: Any?] {
        
        var map = [String: Any?]()
        do {
            let data = try encoder.encode(self)
            let object = try JSONSerialization.jsonObject(with: data)
            if let json = object as? [String: Any?]  {
                map = json
            }
        } catch {
            print("Error:- \(error.localizedDescription)")
        }
        return map
    }
    
    func toJSON() -> String? {
        
        var jsonString: String?
        do {
            let jsonData = try JSONEncoder().encode(self)
            if let string = String(data: jsonData, encoding: .utf8) {
                jsonString = string
            }
        } catch {
            print("Unable to convert to json strin:- \(error.localizedDescription)")
        }
        return jsonString
    }
}

extension Dictionary {
    
    func getDecodableFrom<T>(type: T.Type) -> T? where T : Decodable {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                
                if let jsonData = jsonString.data(using: .utf8) {
                    do {
                        // Decode the JSON data into PassioAdvisorResponse
                        let response = try JSONDecoder().decode(type.self, from: jsonData)
                        return response
                    } catch {
                        return nil
                    }
                } else {
                    return nil
                }
            }
        } catch {
            print("Unable to convert to json strin:- \(error.localizedDescription)")
        }
        return nil
    }
}
