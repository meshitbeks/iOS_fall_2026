import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    // All player state lives here; the screen is refreshed from it after every tap.
    private let tracks = TrackLibrary.tracks
    private var currentIndex = 0
    private var isPlaying = false

    // Stored as a property so the player lives as long as the screen.
    private var player: AVAudioPlayer?

    private let symbolConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
    private let bigSymbolConfig = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)

    override func viewDidLoad() {
        super.viewDidLoad()
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        setUpButtons()
        loadTrack(at: currentIndex)
        updateUI()
    }

    // MARK: - Actions

    @IBAction func playPauseTapped(_ sender: UIButton) {
        isPlaying.toggle()
        applyPlayState()
        updateUI()
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        switchTrack(by: 1)
    }

    @IBAction func previousTapped(_ sender: UIButton) {
        switchTrack(by: -1)
    }

    // MARK: - AVAudioPlayerDelegate

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        switchTrack(by: 1)   // isPlaying is still true, so the next track starts
    }

    // MARK: - Player logic

    /// Moves forward (+1) or back (-1) and wraps around the ends of the list.
    private func switchTrack(by offset: Int) {
        currentIndex = (currentIndex + offset + tracks.count) % tracks.count
        loadTrack(at: currentIndex)
        applyPlayState()     // keeps the play state: playing stays playing
        updateUI()
    }

    /// Creates a new AVAudioPlayer for the track. A missing or broken file never crashes the app.
    private func loadTrack(at index: Int) {
        player?.stop()
        player = nil

        let track = tracks[index]
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: TrackLibrary.audioExtension) else {
            print("Audio file not found in the bundle: \(track.fileName).\(TrackLibrary.audioExtension)")
            return
        }

        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.delegate = self
            newPlayer.prepareToPlay()
            player = newPlayer
        } catch {
            print("Could not play \(track.fileName): \(error.localizedDescription)")
        }
    }

    /// Makes the real player match isPlaying.
    private func applyPlayState() {
        guard let player else {
            isPlaying = false   // nothing to play (file missing or broken)
            return
        }
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }

    // MARK: - UI

    private func setUpButtons() {
        previousButton.setTitle(nil, for: .normal)
        nextButton.setTitle(nil, for: .normal)
        playPauseButton.setTitle(nil, for: .normal)
        previousButton.setImage(UIImage(systemName: "backward.fill", withConfiguration: symbolConfig), for: .normal)
        nextButton.setImage(UIImage(systemName: "forward.fill", withConfiguration: symbolConfig), for: .normal)
    }

    /// Refreshes the whole screen from the current state.
    private func updateUI() {
        let track = tracks[currentIndex]
        coverImageView.image = UIImage(named: track.coverImageName)
        titleLabel.text = track.title
        artistLabel.text = track.artist

        let symbolName = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: symbolName, withConfiguration: bigSymbolConfig), for: .normal)
    }
}
