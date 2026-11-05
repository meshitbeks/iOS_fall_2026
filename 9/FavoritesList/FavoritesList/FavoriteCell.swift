import UIKit

/// Custom cell designed as a prototype cell in Main.storyboard.
/// Only outlets and one method that fills the cell; no layout code.
final class FavoriteCell: UITableViewCell {

    static let reuseIdentifier = "FavoriteCell"

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!

    /// Fully resets the cell from one item, because cells are reused while scrolling.
    func configure(with item: FavoriteItem) {
        itemImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle

        let stars = [star1, star2, star3, star4, star5]
        for (index, star) in stars.enumerated() {
            let symbolName = index < item.rating ? "star.fill" : "star"
            star?.image = UIImage(systemName: symbolName)
        }
    }
}
