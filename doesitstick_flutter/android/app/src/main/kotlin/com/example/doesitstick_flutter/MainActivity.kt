package com.example.doesitstick_flutter

import android.graphics.Color
import android.os.Build
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    // Some phones (seen on Oppo/ColorOS) ignore a navigation bar color set
    // before the window is shown and fall back to black, so the white bar
    // from main.dart is applied again once the window has focus.
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus && Build.VERSION.SDK_INT < Build.VERSION_CODES.VANILLA_ICE_CREAM) {
            @Suppress("DEPRECATION")
            window.navigationBarColor = Color.WHITE
            WindowCompat.getInsetsController(window, window.decorView)
                .isAppearanceLightNavigationBars = true
        }
    }
}
