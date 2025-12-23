package com.example.aria

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
                if (max > 0) {
                     ghostText.text = "${(progress * 100 / max)}%"
                }
            }

            override fun onStartTrackingTouch(seekBar: SeekBar?) {}
            override fun onStopTrackingTouch(seekBar: SeekBar?) {}
        })

        // Touch outside -> close overlay (return to button)
        val background = findViewById<FrameLayout>(R.id.rootLayout)
        background?.setOnClickListener {
             // Logic to switch back to floating button
             if (context is VolumeOverlayService) {
                 (context as VolumeOverlayService).showFloatingButton()
             }
        }
    }
}
