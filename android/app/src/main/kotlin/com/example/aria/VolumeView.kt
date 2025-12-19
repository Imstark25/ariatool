package com.example.aria

import android.app.Service
import android.content.Context
import android.media.AudioManager
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import android.widget.SeekBar
import android.widget.TextView

class VolumeView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : FrameLayout(context, attrs, defStyleAttr) {

    private val audioManager =
        context.getSystemService(Context.AUDIO_SERVICE) as AudioManager

    init {
        LayoutInflater.from(context).inflate(R.layout.volume_overlay, this, true)

        val slider = findViewById<SeekBar>(R.id.volumeSlider)
        val ghostText = findViewById<TextView>(R.id.ghost)
        
        val max = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        val current = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)

        slider.max = max
        slider.progress = current
        ghostText.text = "${(current * 100 / max)}%"

        slider.setOnSeekBarChangeListener(object : SeekBar.OnSeekBarChangeListener {

            override fun onProgressChanged(
                seekBar: SeekBar?, progress: Int, fromUser: Boolean
            ) {
                audioManager.setStreamVolume(
                    AudioManager.STREAM_MUSIC,
                    progress,
                    0
                )
                // Update ghost text (percentage approximately)
                if (max > 0) {
                     ghostText.text = "${(progress * 100 / max)}%"
                }
            }

            override fun onStartTrackingTouch(seekBar: SeekBar?) {}
            override fun onStopTrackingTouch(seekBar: SeekBar?) {}
        })

        // Touch outside -> close
        // Since FrameLayout wraps the content, touching "this" means touching the view itself.
        // However, the window is WRAP_CONTENT, so you might not be able to touch "outside" within this view.
        // But if the layout has padding and you tap it, maybe close?
        // Actually, to simulate "Touch outside -> close", usually the Window is MATCH_PARENT with a transparent background.
        // But the user requested "Opens exactly where the bubble is... No jitter... System-level performance".
        // And "Touch anywhere -> close".
        // If I make the window MATCH_PARENT, it blocks interaction with the rest of the screen.
        // The user's snippet uses WRAP_CONTENT/specific size and `setOnClickListener { stopSelf() }`.
        // This implies touching the view *itself* closes it? That seems wrong for a volume control (you want to touch slider).
        // Maybe they meant touching the background?
        // I will implement a close button or rely on the user tapping the "background" area of the frame if defined.
        
        val background = findViewById<FrameLayout>(R.id.rootLayout)
        background?.setOnClickListener {
             // If they click the background (glass), should it close? 
             // Maybe better to have a close button or auto-hide.
             // For now I'll follow the snippet: View itself (FrameLayout) has listener.
             // But SeekBar consumes touch. So clicking space around seekbar closes it.
             (context as Service).stopSelf()
        }
    }
}
