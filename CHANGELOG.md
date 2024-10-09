## 3.2.0+1

### Fixed

* Resolved an issue with the iOS build process that was causing build failures in certain environments.


## 3.2.0

### Added APIs

* Added function `recognizeNutritionFactsRemote` that can parse the nutrition facts table from an image and return a `PassioFoodItem` with the scanned nutrients
```dart
Future<PassioFoodItem?> recognizeNutritionFactsRemote(Uint8List bytes, {PassioImageResolution resolution = PassioImageResolution.res_1080})
```

* Added support for localized content. Using `updateLanguage` with a two digit ISO 639-1 language code will transform the food names and serving sizes in the SDK responses.
```dart
Future<bool> updateLanguage(String languageCode)
```

* Added `remoteOnly` flag to the `PassioConfiguration` class. With this flag enabled, the SDK won't download the files needed for local recognition. In this case only remote recognition is possible.
```dart
class PassioConfiguration{
  ...
  final bool remoteOnly;
}
```


### Refactored APIs

* `recognizeImageRemote` can now scan barcodes and nutrition facts. The `PassioAdvisorFoodInfo` class has been augmented to handle these responses
```dart
class PassioAdvisorFoodInfo {
  final PassioFoodDataInfo? foodDataInfo;
  final PassioFoodItem? packagedFoodItem;
  final String portionSize;
  final PassioFoodResultType resultType;
  final String recognisedName;
  final double weightGrams;
}

enum PassioFoodResultType {
  foodItem,
  barcode,
  nutritionFacts,
}
```

* Property `tags` was added to `PassioFoodDataInfo`
```dart
class PassioFoodDataInfo {
    ...
    final List<String>? tags;
}
```

* Vitamin A RAE was added to the `PassioNutrients` class.
```dart
class PassioNutrients {
  ...
  final UnitMass? _vitaminARAE;
}
```


## 3.1.4+2

* Improved scanning performance on Android

## 3.1.4+1

### Added APIs

* Added fiber value to PassioSearchNutritionPreview


## 3.1.4

### Added APIs

* With the new key comes the new pricing model using tokens. Although all token usage can be seen in the portal, the SDK itself offers a listener to count the tokens being used by the SDK.
```dart
void setAccountListener(PassioAccountListener? listener)

abstract interface class PassioAccountListener {
    void onTokenBudgetUpdate(PassioTokenBudget tokenBudget);
}

class PassioTokenBudget {
    final String apiName;
    final int budgetCap;
    final int periodUsage;
    final int tokensUsed;
}
```

* **Control Flashlight:** Manage the flashlight with:
```dart
/// [enabled] A required parameter to turn the flashlight on or off.
/// [level] An optional parameter specifying the intensity level of the flashlight, with a default value of 1. Note that the level parameter is only applicable on iOS for now.
Future<void> enableFlashlight({required bool enabled, double level = 1})
```

* **Get Camera Zoom Levels:** Retrieve the minimum and maximum zoom levels with:
```dart
Future<PassioCameraZoomLevel> getMinMaxCameraZoomLevel()

class PassioCameraZoomLevel {
  final double? minZoomLevel;
  final double? maxZoomLevel;
}
```

* **Set Camera Zoom Level:** Adjust the camera zoom level:
```dart
/// [zoomLevel] Sets the desired zoom level. Ensure it’s within the range obtained from ```getMinMaxCameraZoomLevel()```.
Future<void> setCameraZoomLevel({required double zoomLevel})
```

### Refactored APIs

* Updated the fetchFoodItemForDataInfo method to include an optional weightGrams parameter:
```dart
/// [weightGrams] An optional parameter that provides information specific to the specified weight in grams.
Future<PassioFoodItem?> fetchFoodItemForDataInfo(PassioFoodDataInfo passioFoodDataInfo,{double? weightGrams})
```

* The ```NutritionAdvisor``` no longer needs a separate key for configuration. The PassioSDK needs to be configured in order to call the NutritionAdvisor APIs. Also, any previous NutritionAdvisor keys won't work with this version, a new key needs to be obtained at https://www.passio.ai/


## 3.1.1

### Added APIs

* Added ```PassioImageResolution resolution``` as a parameter of the ```recognizeImageRemote``` function. This enables the caller to set the target resolution of the image uploaded to the server. Smaller resolutions will result in faster response times, while higher resolutions should provide more accurate results.

```dart
enum PassioImageResolution {
  res_512,
  res_1080,
  full,
}
```

* Added a function to retrieve possible hidden ingredients for a given food name.
```dart
Future<PassioResult<List<PassioAdvisorFoodInfo>>> fetchHiddenIngredients(String foodName)
```

* Added a function to retrieve possible visual alternatives for a given food name.
```dart
Future<PassioResult<List<PassioAdvisorFoodInfo>>> fetchVisualAlternatives(String foodName)
```

* Added a function to retrieve possible ingredients if a more complex food for a given food name.
```dart
Future<PassioResult<List<PassioAdvisorFoodInfo>>> fetchPossibleIngredients(String foodName)
```


## 3.1.0

### New Features

#### Nutrition AI Advisor
* To access the API of the Advisor use ```NutritionAdvisor.instance```
* The method ```Future<PassioResult<PassioAdvisorResponse>> fetchIngredients(PassioAdvisorResponse response)``` works only with the response from ```sendMessage()```. It returns data if the ```PassioAdvisorResponse``` contains ```tools```.
```dart
Future<PassioResult> configure(String key)

Future<PassioResult> initConversation()

Future<PassioResult<PassioAdvisorResponse>> sendMessage(String message)

Future<PassioResult<PassioAdvisorResponse>> sendImage(Uint8List bytes)

Future<PassioResult<PassioAdvisorResponse>> fetchIngredients(PassioAdvisorResponse response)
```

#### Nutrition Facts Detection
```dart
void startNutritionFactsDetection(NutritionFactsRecognitionListener listener)

Future<void> stopNutritionFactsDetection()

abstract interface class NutritionFactsRecognitionListener {
  void onNutritionFactsRecognized(PassioNutritionFacts? nutritionFacts, String? text);
}
```

### Refactored APIs
* The ```FoodDetectionConfiguration``` object no longer has the detectNutritionFacts parameter.

### Added APIs
* Added speech recognition API that retrieves a list of recognized foods from the input text query.
```dart
Future<List<PassioSpeechRecognitionModel>> recognizeSpeechRemote(String text)
```
* Added LLM image detection, that works remotely through Passio's backend.
```dart
Future<List<PassioAdvisorFoodInfo>> recognizeImageRemote(Uint8List bytes)
```
* Added a function to retrieve a PassioFoodItem for a v2 PassioID
```dart
Future<PassioFoodItem?> fetchFoodItemLegacy(PassioID passioID)
```

## 3.0.3

### Added APIs
* Added two functions to fetch a list of meal plans and fetch a meal plan for a certain day.
```dart
Future<List<PassioMealPlan>> fetchMealPlans()
Future<List<PassioMealPlanItem>> fetchMealPlanForDay(String mealPlanLabel, int day)
```
* Added `refCode` as an attribute to the `PassioFoodItem` and `PassioIngredient` classes.
* Added method to fetch a food item using just the `refCode` attribute
```dart
Future<PassioFoodItem?> fetchFoodItemForRefCode(String refCode)
```

### Refactored APIs
* Refactored PassioSearchNutritionPreview
```dart
class PassioSearchNutritionPreview {
  final int calories;
  final double carbs;
  final double fat;
  final double protein;
  final double servingQuantity;
  final String servingUnit;
  final double weightQuantity;
  final String weightUnit;
}
```
* Renamed `PassioSearchResult` to `PassioFoodDataInfo`.
* Renamed `fetchFoodItemForSearchResult` to `fetchFoodItemForDataInfo`.
* Renamed `MealTime` to `PassioMealTime`.

### Deprecated APIs
* Removed `fetchFoodItemForSuggestion`. Now `fetchFoodItemForDataInfo` is used.

## 3.0.2

### Added APIs

* Added API to fetch suggestion for a certain meal time. To fetch the full nutritional data for a suggestion item use `fetchFoodItemForSuggestion`.
```dart
enum MealTime {
  breakfast,
  lunch,
  dinner,
  snack,
}

Future<List<PassioSearchResult>> fetchSuggestions(MealTime mealTime)

Future<PassioFoodItem?> fetchFoodItemForSuggestion(PassioSearchResult suggestion)
```

### Added Micronutrients:

* Zinc
* Selenium
* Folic acid
* Chromium
* Vitamin-K Phylloquinone
* Vitamin-K Menaquinone4
* Vitamin-K Dihydrophylloquinone

### Refactored APIs

* Renamed ```fetchSearchResult``` to ```fetchFoodItemForSearchResult```.

## 3.0.1

* Version 3 of the Passio SDK introduces major changes to the nutritional data class and the search functionality. The SDK no longer supports offline work, there is no more local database.

### Deprecated APIs
* `lookupPassioAttributesFor` has been removed because it was querying the local database.
* PassioIDAttributes, PassioFoodItemData and PassioFoodRecipe have been removed. The new data model that will handle nutritional data is called PassioFoodItem
### Refactored APIs
* `searchForFood` now returns PassioSearchResponse. In PassioSearchResponse you will get list of PassioSearchResult and a list of search options. The PassioSearchResult represent a specific food item associated with the search term.
* `fetchPassioIDAttributesForBarcode` and `fetchPassioIDAttributesForPackagedFood` have been replaced with `fetchFoodItemForProductCode` than now returns a PassioFoodItem result
* `DetectedCandidate` now has an attribute called foodName
* `FoodRecognitionListener` method `onRecognitionResults` can now return nullable FoodCandidates
* `fetchNutrientsFor` has been renamed to `fetchInflammatoryEffectData`, and PassioNutrient has been renamed to InflammatoryEffectData
### Added APIs
* `fetchSearchResult` returns a PassioFoodItem object for a given PassioSearchResult
* `fetchFoodItemForPassioID` returns a PassioFoodItem object for a given passioID corresponding to a result from the visual detection
* Added class PassioSearchResult that represents a result from the searchForFood function
* Added class PassioFoodItem that represent a food item from the Passio Nutritional database. It has a list of PassioIngredients, with their respective PassioFoodAmounts and PassioNutrients

## 2.3.15

* Added `fetchNutrientsFor` method to retrieve a map of nutrients for a 100 grams of a specific food item.

## 0.0.10

* No API changes

## 0.0.9

* Add `PlatformImage` parameter to the `recognitionResults` of the `FoodRecognitionListener`. It represents the image that was analyzed by the camera recognition system.

## 0.0.8

* Fixed iOS camera not stopping issue

## 0.0.7

* Fixed Android camera not stopping issue

## 0.0.6

* Removed app bar from `PassioPreview`
* Fixed issue with food items that don't have an origin
* Fixed Android issue with caching `PassioFoodItemData`

## 0.0.5

* Clean up of the example app code
* Added distribution github repository with the source code and issue tracker

## 0.0.4

* Fix issue with PassioSDKError

## 0.0.3

* Add `detectFoodIn` to run detection from a single image.
* Add `fetchTagsFor` to fetch the list of tags for a food item.
* Add `iconURLFor` to get the url for downloading an icon for a food item.
* Add `transformCGRectForm` to calculate the bouding box of scanned food item.
* Add volume detection using `VolumeDetectionMode`
* Add `android:required="false"` to camera manifest features in Android.
* Refactor `lookupIconsFor` to return a list of `PassioFoodIcons` objects.
* Refactor `PassioPreview` widget to remove all unnecessary widgets. 

## 0.0.2

* Add missing .aar dependency

## 0.0.1

* Alpha release of the Nutrition AI SDK for Flutter.
* Visual, barcode and packaged food detection using the camera of the device.
* Fetching nutritional data of the scanned food.
* Searching by food name.
* Fetching the icon for the food item.
