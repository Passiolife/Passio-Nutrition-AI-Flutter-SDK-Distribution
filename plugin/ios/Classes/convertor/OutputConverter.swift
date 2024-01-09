import PassioNutritionAISDK

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
        candidateMap["passioID"] = detectedCandidate.passioID
        candidateMap["confidence"] = detectedCandidate.confidence
        let boundingBox = detectedCandidate.boundingBox
        candidateMap["boundingBox"] = mapFromBoundingBox(boundingBox: boundingBox)
        if let amountEstimate = detectedCandidate.amountEstimate {
            candidateMap["amountEstimate"] = mapAmounteEstimage(amountEstimate: amountEstimate )
        }
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
    
    
    func mapFromPassioIDAttributes(passioIDAttributes: PassioIDAttributes) -> [String: Any?] {
        var attrMap = [String: Any?]()
        attrMap["passioID"] = passioIDAttributes.passioID
        attrMap["name"] = passioIDAttributes.name
        attrMap["entityType"] = passioIDAttributes.entityType.rawValue
        attrMap["foodItem"] = passioIDAttributes.passioFoodItemData != nil ?
        mapFromFoodItemData(itemData: passioIDAttributes.passioFoodItemData!) : nil
        attrMap["recipe"] = passioIDAttributes.recipe != nil ?
        mapFromPassioFoodRecipe(recipe: passioIDAttributes.recipe!) : nil
        attrMap["parents"] = passioIDAttributes.parents?.map { mapFromAlternatives($0) }
        attrMap["siblings"] = passioIDAttributes.siblings?.map { mapFromAlternatives($0) }
        attrMap["children"] = passioIDAttributes.children?.map { mapFromAlternatives($0) }
        return attrMap
    }
    
    func mapFromFoodItemData(itemData: PassioFoodItemData) -> [String: Any?] {
        var data = itemData
        var dataMap = [String: Any?]()
        dataMap["passioID"] = data.passioID
        dataMap["name"] = data.name
        dataMap["selectedQuantity"] = data.selectedQuantity
        dataMap["selectedUnit"] = data.selectedUnit
        dataMap["entityType"] = data.entityType.rawValue
        dataMap["servingUnits"] = data.servingUnits.map { mapFromServingUnit($0) }
        dataMap["servingSizes"] = data.servingSizes.map { mapFromServingSize($0) }
        dataMap["ingredientsDescription"] = data.ingredientsDescription
        dataMap["barcode"] = data.barcode
        dataMap["foodOrigins"] = data.foodOrigins?.map { mapFromFoodOrigin($0) } ?? []
        dataMap["parents"] = data.parents?.map { mapFromAlternatives($0) }
        dataMap["children"] = data.children?.map { mapFromAlternatives($0) }
        dataMap["siblings"] = data.siblings?.map { mapFromAlternatives($0) }
        dataMap["tags"] = data.tags?.map { $0 }
        // Map the nutrient per 100 grams
        _ = data.setFoodItemDataServingSize(unit: "gram", quantity: 100)
        dataMap["calories"] = mapFromUnitEnergy(data.totalCalories)
        dataMap["carbs"] = mapFromUnitMass(data.totalCarbs)
        dataMap["fat"] = mapFromUnitMass(data.totalFat)
        dataMap["proteins"] = mapFromUnitMass(data.totalProteins)
        dataMap["saturatedFat"] = mapFromUnitMass(data.totalSaturatedFat)
        dataMap["transFat"] = mapFromUnitMass(data.totalTransFat)
        dataMap["monounsaturatedFat"] = mapFromUnitMass(data.totalMonounsaturatedFat)
        dataMap["polyunsaturatedFat"] = mapFromUnitMass(data.totalPolyunsaturatedFat)
        dataMap["cholesterol"] = mapFromUnitMass(data.totalCholesterol)
        dataMap["sodium"] = mapFromUnitMass(data.totalSodium)
        dataMap["fibers"] = mapFromUnitMass(data.totalFibers)
        dataMap["sugars"] = mapFromUnitMass(data.totalSugars)
        dataMap["sugarsAdded"] = mapFromUnitMass(data.totalSugarsAdded)
        dataMap["vitaminD"] = mapFromUnitMass(data.totalVitaminD)
        dataMap["calcium"] = mapFromUnitMass(data.totalCalcium)
        dataMap["iron"] = mapFromUnitMass(data.totalIron)
        dataMap["potassium"] = mapFromUnitMass(data.totalPotassium)
        dataMap["vitaminA"] = mapFromUnitIU(data.totalVitaminA?.value)
        dataMap["vitaminC"] = mapFromUnitMass(data.totalVitaminC)
        dataMap["alcohol"] = mapFromUnitMass(data.totalAlcohol)
        dataMap["sugarAlcohol"] = mapFromUnitMass(data.totalSugarAlcohol)
        dataMap["vitaminB12Added"] = mapFromUnitMass(data.totalVitaminB12Added)
        dataMap["vitaminB12"] = mapFromUnitMass(data.totalVitaminB12)
        dataMap["vitaminB6"] = mapFromUnitMass(data.totalVitaminB6)
        dataMap["vitaminE"] = mapFromUnitMass(data.totalVitaminE)
        dataMap["vitaminEAdded"] = mapFromUnitMass(data.totalVitaminEAdded)
        dataMap["magnesium"] = mapFromUnitMass(data.totalMagnesium)
        dataMap["phosphorus"] = mapFromUnitMass(data.totalPhosphorus)
        dataMap["iodine"] = mapFromUnitMass(data.totalIodine)
        return dataMap
    }
    
    func mapFromPassioFoodRecipe(recipe: PassioFoodRecipe) -> [String: Any?] {
        var recipeMap = [String: Any?]()
        recipeMap["passioID"] = recipe.passioID
        recipeMap["name"] = recipe.name
        recipeMap["selectedQuantity"] = recipe.selectedQuantity
        recipeMap["selectedUnit"] = recipe.selectedUnit
        recipeMap["servingUnits"] = recipe.servingUnits.map { mapFromServingUnit($0) }
        recipeMap["servingSizes"] = recipe.servingSizes.map { mapFromServingSize($0) }
        recipeMap["foodItems"] = recipe.foodItems.map { mapFromFoodItemData(itemData: $0) }
        return recipeMap
    }
    
    func mapFromAlternatives(_ alternative: PassioAlternative) -> [String: Any?] {
        var alternativeMap = [String: Any?]()
        alternativeMap["passioID"] = alternative.passioID
        alternativeMap["name"] = alternative.name
        alternativeMap["quantity"] = alternative.quantity
        alternativeMap["unitName"] = alternative.unitName
        return alternativeMap
    }
    
    func mapFromServingSize(_ servingSize: PassioServingSize) -> [String: Any?] {
        var servingSizeMap = [String: Any?]()
        servingSizeMap["quantity"] = servingSize.quantity
        servingSizeMap["unitName"] = servingSize.unitName
        return servingSizeMap
    }
    
    func mapFromServingUnit(_ servingUnit: PassioServingUnit) -> [String: Any?] {
        var servingUnitMap = [String: Any?]()
        servingUnitMap["unitName"] = servingUnit.unitName
        servingUnitMap["weight"] = mapFromUnitMass(servingUnit.weight)
        return servingUnitMap
    }
    
    func mapFromFoodOrigin(_ origin: PassioFoodOrigin) -> [String: Any?] {
        var originMap = [String: Any?]()
        originMap["id"] = origin.id
        originMap["source"] = origin.source
        originMap["licenseCopy"] = origin.licenseCopy
        return originMap
    }
    
    func mapFromUnitEnergy(_ unitEnergy: Measurement<UnitEnergy>?) -> [String: Any?]? {
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
    
    func mapFromUnitIU(_ value: Double?) -> [String: Any?]? {
        guard let value = value else { return nil }
        var unitEnergyMap = [String: Any?]()
        unitEnergyMap["unit"] = "iu"
        unitEnergyMap["value"] = value
        return unitEnergyMap
    }
    
    func convertEnergyUnit(unitEnergy: UnitEnergy) -> String {
        unitEnergy.symbol.description == "kCal" ? "kilocalories" : unitEnergy.symbol.description
    }
    
    func convertMashUnit(unitMass: UnitMass) -> String {
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
    
    
    func mapAmounteEstimage(amountEstimate: AmountEstimate ) -> [String: Any?] {
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
    func mapFromPassioNutrient(nutrient: PassioNutrient) -> [String: Any?] {
        // Create a mutable map to store the serialized nutrient data.
        var nutrientMap = [String: Any?]()

        // Add nutrient properties to the map.
        nutrientMap["amount"] = nutrient.amount
        nutrientMap["inflammatoryEffectScore"] = nutrient.inflammatoryEffectScore
        nutrientMap["name"] = nutrient.name
        nutrientMap["unit"] = nutrient.unit

        // Return the serialized nutrient map.
        return nutrientMap
    }
}
