import UIKit

/// Detail screen. It receives one item from the list and fills its own outlets.
final class DetailViewController: UIViewController {

    /// Set by the list screen in prepare(for:sender:).
    var item: FavoriteItem?

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item else {
            print("DetailViewController opened without an item")
            return
        }

        title = item.title   // navigation bar title (small, set in Main.storyboard)
        itemImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        descriptionLabel.text = item.description

        let stars = [star1, star2, star3, star4, star5]
        for (index, star) in stars.enumerated() {
            let symbolName = index < item.rating ? "heart.fill" : "heart"
            star?.image = UIImage(systemName: symbolName)
        }
    }
}
