package ai.passio.nutrition_ai.view

import ai.passio.passiosdk.core.camera.PassioCameraConfigurator
import ai.passio.passiosdk.core.camera.PassioCameraViewProvider
import ai.passio.passiosdk.passiofood.PassioSDK
import android.app.Activity
import android.content.Context
import android.content.ContextWrapper
import android.view.View
import androidx.camera.core.AspectRatio
import androidx.camera.core.CameraSelector
import androidx.camera.core.Preview
import androidx.camera.view.PreviewView
import androidx.lifecycle.LifecycleOwner
import io.flutter.plugin.platform.PlatformView

internal class NativePreviewView(
    context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?
) : PlatformView {

    private val previewView: PreviewView

    init {
        previewView = PreviewView(context)

        val activity = getActivity(previewView)!!
        val cameraViewProvider = object : PassioCameraViewProvider {
            override fun requestCameraLifecycleOwner(): LifecycleOwner = activity as LifecycleOwner
            override fun requestPreviewView(): PreviewView = previewView
        }
        val cameraConfigurator = object : PassioCameraConfigurator {

            override fun cameraFacing(): Int = CameraSelector.LENS_FACING_BACK

            override fun preview(): Preview = Preview.Builder().apply {
                setTargetAspectRatio(AspectRatio.RATIO_16_9)
            }.build().also {
                previewView.implementationMode = PreviewView.ImplementationMode.COMPATIBLE
                it.setSurfaceProvider(previewView.surfaceProvider)
            }
        }
        PassioSDK.instance.startCamera(cameraViewProvider, cameraConfigurator)
    }

    override fun getView(): View = previewView

    override fun dispose() {
        PassioSDK.instance.stopCamera()
    }

    override fun onFlutterViewAttached(flutterView: View) {
        super.onFlutterViewAttached(flutterView)
    }

    override fun onFlutterViewDetached() {
        super.onFlutterViewDetached()
        PassioSDK.instance.stopCamera()
    }

    private fun getActivity(view: View): Activity? {
        var context: Context = view.context
        while (context is ContextWrapper) {
            if (context is Activity) {
                return context
            }
            context = context.baseContext
        }
        return null
    }
}