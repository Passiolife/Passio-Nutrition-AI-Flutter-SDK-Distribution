package ai.passio.nutrition_ai.utils

import android.graphics.Bitmap
import java.io.ByteArrayOutputStream

fun Bitmap?.toByteArray(): ByteArray? {
    return this?.let {
        // Creating a ByteArrayOutputStream to compress the Bitmap to PNG format
        val stream = ByteArrayOutputStream()
        it.compress(Bitmap.CompressFormat.JPEG, 100, stream)

        // Converting the compressed image to a ByteArray
        stream.toByteArray()
    }
}