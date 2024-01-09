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
