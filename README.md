# audio-degapinator

The poor developer's "[Smart Speed](http://overcast.fm)"

`AVAudioPlayer` offers features for audio level metering:

```swift
/* metering */
    
open var isMeteringEnabled: Bool /* turns level metering on or off. default is off. */

open func updateMeters() /* call to refresh meter values */

open func peakPower(forChannel channelNumber: Int) -> Float /* returns peak power in decibels for a given channel */

open func averagePower(forChannel channelNumber: Int) -> Float /* returns average power in decibels for a given channel */
```

And for adjusting playback, including:

```swift
open var rate: Float /* See enableRate. The playback rate for the sound. 1.0 is normal, 0.5 is half speed, 2.0 is double speed. */
```

This code:

* turns metering on
* updates meters with a timer
* checks if there is currently silence playing using averagePower
    * increases the playback rate 2x until the silence ends

I tested using [episode 220 of ATP](http://atp.fm/episodes/220) and [Debug episode 49](http://www.imore.com/debug-49-siracusa-round-2). In both cases the silences were noticeably reduced and, to my ear, sounded completely natural. I listened to the entire episode of Debug and it had shaved off a little over 3 minutes by the end.
