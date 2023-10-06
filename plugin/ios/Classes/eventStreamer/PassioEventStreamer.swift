//
//  PassioEventStreamer.swift
//  Runner
//
//  Created by Zvika on 7/25/23.
//  Copyright © 2023 Passio Inc. All rights reserved.
//

import Foundation

import Flutter

class PassioEventStreamer: NSObject, FlutterStreamHandler {
    
    private var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?,
                  eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    func sendEvent(data: Any) {
        if let eventSink = self.eventSink {
            eventSink(data)
        }
    }
}
