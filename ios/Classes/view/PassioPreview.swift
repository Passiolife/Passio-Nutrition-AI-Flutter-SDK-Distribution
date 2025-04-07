//  Copyright © 2023 Passio Inc. All rights reserved.

import AVFoundation
import PassioNutritionAISDK
import UIKit
import Flutter


class PassioPreview: NSObject, FlutterPlatformView {
    
    private var _view: UIView

    init(frame : CGRect,
        viewIdentifier : Int64,
        binaryMessenger : FlutterBinaryMessenger?) {
        _view = UIView(frame: frame)
        super.init()
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view: UIView) {
        setupPreviewLayer(view: view)
    }

    private func setupPreviewLayer(view: UIView) {
        let passioSDK = PassioNutritionAI.shared
        if let videoLayer = passioSDK.getPreviewLayer() {
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
