//  Copyright © 2023 Passio Inc. All rights reserved.

import AVFoundation
import PassioNutritionAISDK
import UIKit
import Flutter


class PassioPreview: NSObject, FlutterPlatformView {
    
    private var _view: UIView

    init(frame : CGRect,
        viewIdentifier : Int64,
        volumeDetectionMode: VolumeDetectionMode,
        binaryMessenger : FlutterBinaryMessenger?) {
        _view = UIView(frame: frame)
        super.init()
        createNativeView(view: _view, volumeDetectionMode: volumeDetectionMode)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view: UIView, volumeDetectionMode: VolumeDetectionMode) {
        setupPreviewLayer(view: view, volumeDetectionMode: volumeDetectionMode)
    }

    private func setupPreviewLayer(view: UIView, volumeDetectionMode: VolumeDetectionMode ) {
        let passioSDK = PassioNutritionAI.shared
        if volumeDetectionMode != .none,
            let videoLayer = passioSDK.getPreviewLayerWithGravity(volumeDetectionMode: volumeDetectionMode) {
            videoLayer.frame = view.frame
            view.layer.insertSublayer(videoLayer, at: 0)
        }
        else if let videoLayer = passioSDK.getPreviewLayer() {
            videoLayer.frame = view.frame
            view.layer.insertSublayer(videoLayer, at: 0)
        } else {
            print("Something went wrong in setupPreviewLayer UIView")
        }
    }
    
    deinit {
        PassioNutritionAI.shared.removeVideoLayer()
    }

}
