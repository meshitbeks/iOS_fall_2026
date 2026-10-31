import UIKit

// Data for the profile screen. Code only fills in data:
// no frames, no constraints, no anchors (all layout is in Main.storyboard).
struct Profile {
    let name: String
    let posts: String
    let followers: String
    let following: String
    let about: String
}

class ViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!

    let profile = Profile(
        name: "Maximilian Alexander von Habsburg",
        posts: "128",
        followers: "4,512",
        following: "301",
        about: "iOS student from Almaty. I love building small apps with UIKit, drinking coffee and watching romantic comedies. Currently learning Auto Layout and trying to make every screen work on both small and large iPhones."
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        show(profile)
    }

    func show(_ profile: Profile) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 44, weight: .regular)
        avatarImageView.image = UIImage(systemName: "person.fill", withConfiguration: symbolConfig)
        nameLabel.text = profile.name
        postsCountLabel.text = profile.posts
        followersCountLabel.text = profile.followers
        followingCountLabel.text = profile.following
        aboutLabel.text = profile.about
    }
}
