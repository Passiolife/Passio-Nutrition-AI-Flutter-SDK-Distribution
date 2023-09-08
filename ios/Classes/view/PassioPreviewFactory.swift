//  Copyright © 2023 Passio Inc. All rights reserved.

import UIKit
import Flutter
import PassioNutritionAISDK


class PassioPreviewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(withFrame frame: CGRect,
                viewIdentifier viewId: Int64,
                arguments args: Any?) -> FlutterPlatformView {
        var newFrame = frame
        var volumeDetectionMode = VolumeDetectionMode.none
        if let params = args as? [String: Any] {
            if let width = params["width"] as? Double,
               let height = params["height"] as? Double {
                newFrame = CGRect(x: 0, y: 0, width: width, height: height)
            }
            if let volumeString = params["volumeDetectionMode"] as? String {
                volumeDetectionMode = InputConverter().mapToVolumeDetectionMode(fromSting: volumeString)
            }
        }
        let view = PassioPreview(frame: newFrame,
                                 viewIdentifier: viewId,
                                 volumeDetectionMode: volumeDetectionMode,
                                 binaryMessenger: messenger )
        return view
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
