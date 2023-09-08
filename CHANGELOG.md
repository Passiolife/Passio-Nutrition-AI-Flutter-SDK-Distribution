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
* Fetcing the icon for the food item.
