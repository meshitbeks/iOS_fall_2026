import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var spinButton: UIButton!

    let favorites: [Favorite] = [
        Favorite(title: "10 Things I Hate About You", description: "A rebellious girl and a mysterious boy fall for each other at school.", imageName: "10thingsihate"),
        Favorite(title: "Failure to Launch", description: "A man in his thirties still lives with his parents until he meets Paula.", imageName: "failuretolaunch"),
        Favorite(title: "A Family Affair", description: "A young woman finds out her mother is dating her movie-star boss.", imageName: "familyaffair"),
        Favorite(title: "Holidate", description: "Two strangers agree to be each other's date for every holiday.", imageName: "holidate"),
        Favorite(title: "How to Lose a Guy in 10 Days", description: "A journalist tries to push a man away while he tries to win her heart.", imageName: "howtoloseaguy"),
        Favorite(title: "La La Land", description: "A jazz pianist and an actress chase their dreams in Los Angeles.", imageName: "lalalend"),
        Favorite(title: "Love, Rosie", description: "Two best friends keep missing their chance to be together.", imageName: "loverosie"),
        Favorite(title: "Me Before You", description: "A cheerful caregiver changes the life of a man after an accident.", imageName: "mebeforeyou"),
        Favorite(title: "People We Meet on Vacation", description: "Two best friends take one last summer trip to fix their friendship.", imageName: "peoplewemeet"),
        Favorite(title: "The Holiday", description: "Two women swap homes for Christmas and find unexpected love.", imageName: "theholiday")
    ]

    var lastIndex: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        showInitialState()
    }

    func showInitialState() {
        favoriteImageView.image = UIImage(systemName: "heart.circle")
        titleLabel.text = "Rom-Com Roulette"
        descriptionLabel.text = "Tap the button to get a random movie!"
    }

    @IBAction func spinTapped(_ sender: UIButton) {
        var newIndex = Int.random(in: 0..<favorites.count)
        while newIndex == lastIndex {
            newIndex = Int.random(in: 0..<favorites.count)
        }
        lastIndex = newIndex
        show(favorites[newIndex])
    }

    func show(_ favorite: Favorite) {
        favoriteImageView.image = UIImage(named: favorite.imageName)
        titleLabel.text = favorite.title
        descriptionLabel.text = favorite.description
    }
}
