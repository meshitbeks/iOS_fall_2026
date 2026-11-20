import Foundation

/// One song in the player.
struct Track {
    let title: String
    let artist: String
    let fileName: String        // audio file name without extension, e.g. "track01"
    let coverImageName: String  // image name in Assets, e.g. "cover01"
}

/// The whole track list, defined in one place.
/// All tracks are original phonk beats made for this project (royalty-free).
enum TrackLibrary {
    static let audioExtension = "m4a"

    static let tracks: [Track] = [
        Track(title: "Night Drift",    artist: "Steppe Phonk",       fileName: "track01", coverImageName: "cover01"),
        Track(title: "Cowbell Rush",   artist: "Almaty Underground", fileName: "track02", coverImageName: "cover02"),
        Track(title: "Neon Highway",   artist: "Drift Kazakh",       fileName: "track03", coverImageName: "cover03"),
        Track(title: "Smoke Ritual",   artist: "Steppe Phonk",       fileName: "track04", coverImageName: "cover04"),
        Track(title: "Black Mustang",  artist: "Drift Kazakh",       fileName: "track05", coverImageName: "cover05"),
        Track(title: "Midnight Turbo", artist: "Almaty Underground", fileName: "track06", coverImageName: "cover06"),
        Track(title: "Phantom Lane",   artist: "Steppe Phonk",       fileName: "track07", coverImageName: "cover07"),
        Track(title: "Redline 808",    artist: "Drift Kazakh",       fileName: "track08", coverImageName: "cover08"),
        Track(title: "Ghost Garage",   artist: "Almaty Underground", fileName: "track09", coverImageName: "cover09"),
        Track(title: "Last Lap",       artist: "Steppe Phonk",       fileName: "track10", coverImageName: "cover10")
    ]
}
