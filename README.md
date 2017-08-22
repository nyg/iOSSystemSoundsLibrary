# iOSSystemSoundsLibrary
## Description

- Lists all system sounds available in iOS.
- Runs only on an iOS device, Simulator will not find any sounds.
- Allows for sounds to be searched

## Basics
```swift
var soundId: SystemSoundID = 0
if kAudioServicesNoError == AudioServicesCreateSystemSoundID(url as NSURL, &soundId) {
	AudioServicesPlaySystemSound(soundId)
}
```

## Screenshot

![screenshot](http://i.imgur.com/5MqOzDS.png)