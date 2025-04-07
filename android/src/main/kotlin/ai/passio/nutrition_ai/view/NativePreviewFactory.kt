package ai.passio.nutrition_ai.view

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativePreviewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private var nativePreviewView: NativePreviewView? = null

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as? Map<String?, Any?>?
        nativePreviewView = NativePreviewView(context, viewId, creationParams)
        return nativePreviewView!!
    }

    // This function exposes a way to start the camera externally.
    fun startCamera() {
        nativePreviewView?.startCamera()
    }

    // You can add more methods to control other aspects of NativePreviewView if needed.
    fun stopCamera() {
        nativePreviewView?.stopCamera()
    }
}