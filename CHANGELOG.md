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
