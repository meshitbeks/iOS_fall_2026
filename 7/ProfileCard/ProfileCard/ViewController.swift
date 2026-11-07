import UIKit


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
        name: "Мешитбек Сагыныш Медеуханкызы",
        posts: "48",
        followers: "1,250",
        following: "310",
        about: "QA-инженер в банке. Интересуюсь дата-аналитикой, системной аналитикой и iOS-разработкой. Занимаюсь в зале и люблю слушать музыку."
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
