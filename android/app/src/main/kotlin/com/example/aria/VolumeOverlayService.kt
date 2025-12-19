package com.example.aria

import android.app.Service
import android.content.Intent
import android.graphics.PixelFormat
import android.os.IBinder
import android.view.Gravity
import android.view.WindowManager

class VolumeOverlayService : Service() {

    private lateinit var windowManager: WindowManager
    private lateinit var overlayView: VolumeView

    override fun onCreate() {
        super.onCreate()

        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        overlayView = VolumeView(this)

        val params = WindowManager.LayoutParams(
            300,
            1200, // Adjusted height to accommodate 500dp + padding if needed, assuming pixels here. 500dp ≈ 1300px on xxxhdpi. Let's use WRAP_CONTENT or specific dimensions.
                  // The user provided code uses 300, 500 in LayoutParams. I'll stick to their snippet but assume pixels (which might be small on high dpi). 
                  // Android WindowManager.LayoutParams uses pixels. 300x500 pixels is very small on modern phones.
                  // I will try to convert DP to PX or just use WRAP_CONTENT if possible, but WindowManager needs explicit size or MATCH/WRAP.
                  // Let's stick to the user's snippet initially but maybe increase it or using WRAP_CONTENT if the view measures itself.
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS, // Added flags for better behavior
            PixelFormat.TRANSLUCENT
        )
        
        // Let's use WRAP_CONTENT for size to respect the XML layout
        params.width = WindowManager.LayoutParams.WRAP_CONTENT
        params.height = WindowManager.LayoutParams.WRAP_CONTENT

        params.gravity = Gravity.END or Gravity.CENTER_VERTICAL
        // Offset from edge
        params.x = 20
        
        windowManager.addView(overlayView, params)
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::overlayView.isInitialized) {
            windowManager.removeView(overlayView)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
