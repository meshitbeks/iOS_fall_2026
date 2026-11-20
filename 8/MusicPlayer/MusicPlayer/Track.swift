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
    static let audioExtension = "mp3"

    static let tracks: [Track] = [
        Track(title: "ghostin",                      artist: "Ariana Grande", fileName: "song01", coverImageName: "cover01"),
        Track(title: "Sorry Bout That",              artist: "Yeat",          fileName: "song02", coverImageName: "cover02"),
        Track(title: "Осколки",                      artist: "Электроптицы",  fileName: "song03", coverImageName: "cover03"),
        Track(title: "cico buff",                    artist: "Calvin",        fileName: "song04", coverImageName: "cover04"),
        Track(title: "Let It Happen",                artist: "Tame Impala",   fileName: "song05", coverImageName: "cover05"),
        Track(title: "All night",                    artist: "TYRANT",        fileName: "song06", coverImageName: "cover06"),
        Track(title: "November Rain (Instrumental)", artist: "Guns N' Roses", fileName: "song07", coverImageName: "cover07"),
        Track(title: "Lemon Glow",                   artist: "Beach House",   fileName: "song08", coverImageName: "cover08"),
        Track(title: "Forever",                      artist: "CHVRCHES",      fileName: "song09", coverImageName: "cover09"),
        Track(title: "Innerbloom",                   artist: "RÜFÜS DU SOL",  fileName: "song10", coverImageName: "cover10")
    ]
}
