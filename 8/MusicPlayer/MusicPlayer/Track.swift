import Foundation

/// One song in the player.
struct Track {
    let title: String
    let artist: String
    let fileName: String        // audio file name without extension, e.g. "track01"
    let coverImageName: String  // image name in Assets, e.g. "cover01"
}

/// The whole track list, defined in one place.
enum TrackLibrary {
    static let audioExtension = "m4a"

    static let tracks: [Track] = [
        Track(title: "Morning Steps",   artist: "Almaty Synth Club", fileName: "track01", coverImageName: "cover01"),
        Track(title: "Rainy Window",    artist: "Lo-Fi Nomad",       fileName: "track02", coverImageName: "cover02"),
        Track(title: "Neon Run",        artist: "Pixel Riders",      fileName: "track03", coverImageName: "cover03"),
        Track(title: "Mountain Bells",  artist: "Tien Shan Echo",    fileName: "track04", coverImageName: "cover04"),
        Track(title: "Night Drive",     artist: "Steppe Wave",       fileName: "track05", coverImageName: "cover05"),
        Track(title: "Slow Snow",       artist: "Lo-Fi Nomad",       fileName: "track06", coverImageName: "cover06"),
        Track(title: "Sunny Market",    artist: "Almaty Synth Club", fileName: "track07", coverImageName: "cover07"),
        Track(title: "Old Tram",        artist: "Tien Shan Echo",    fileName: "track08", coverImageName: "cover08"),
        Track(title: "Arcade Heart",    artist: "Pixel Riders",      fileName: "track09", coverImageName: "cover09"),
        Track(title: "Last Train Home", artist: "Steppe Wave",       fileName: "track10", coverImageName: "cover10")
    ]
}
