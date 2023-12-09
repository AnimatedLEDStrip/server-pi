package animatedledstrip.server.example

import animatedledstrip.leds.stripmanagement.NativeLEDStrip
import animatedledstrip.leds.stripmanagement.StripInfo
import com.github.mbelling.ws281x.LedStripType
import com.github.mbelling.ws281x.Ws281xLedStrip

/**
 * Allows running of RGB WS2811 LEDs
 */
class WS2811Compat(stripInfo: StripInfo) : Ws281xLedStrip(
    stripInfo.numLEDs,
    stripInfo.pin ?: 12,
    800000,
    10,
    stripInfo.brightness,
    0,
    false,
    LedStripType.WS2811_STRIP_RGB,
    false,
), NativeLEDStrip {

    override val numLEDs: Int = stripInfo.numLEDs

    override fun close() {}

    override fun setPixelColor(pixel: Int, color: Int) =
        setPixel(
            pixel,
            color shr 16 and 0xFF,
            color shr 8 and 0xFF,
            color and 0xFF,
        )
}
