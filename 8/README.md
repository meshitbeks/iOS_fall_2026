# Lab 8 · Music Player

A single-screen music player in UIKit: cover, title, artist and Previous / Play-Pause / Next controls that play audio files bundled with the app.

## Layout

All layout is in `Main.storyboard`, no layout code:

- **Root Stack** (vertical, spacing 24): Cover, Labels Stack, Controls Stack
- **Labels Stack** (vertical, spacing 4): title and artist
- **Controls Stack** (horizontal, Fill Equally, spacing 16): Previous, Play/Pause, Next

Constraints are only used to place the root stack (20 pt leading/trailing to the Safe Area, vertically centered) and to keep the cover square (1:1 aspect ratio).

## Playback

- 10 tracks described by a `Track` struct and stored in one place, `TrackLibrary`
- Audio is loaded with `Bundle.main.url(forResource:withExtension:)` and played with `AVAudioPlayer`
- Next / Previous wrap around and keep the play state
- When a track finishes, the next one starts (`audioPlayerDidFinishPlaying`)
- A missing or broken file is reported with `print` and never crashes the app

Music and covers are original, generated for this project, so they are free to use.

## Screenshots

| iPhone SE (3rd generation) | iPhone 18 Pro Max |
|---|---|
| ![iPhone SE](screenshots/iphonese.png) | ![iPhone 18 Pro Max](screenshots/iphone18promax.png) |

iPhone 18 Pro Max is used instead of iPhone 16 Pro Max, which is not available in the iOS 27 simulator.

## Demo

[Screen recording](screenshots/demo.mov): play, pause, next, previous and wrap around.
