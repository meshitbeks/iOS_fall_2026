import UIKit

/// Custom cell designed as a prototype cell in Main.storyboard.
/// The list cell shows only the image and the title; everything else is on the Detail screen.
final class FavoriteCell: UITableViewCell {

    static let reuseIdentifier = "FavoriteCell"

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    /// Fully resets the cell from one item, because cells are reused while scrolling.
    func configure(with item: FavoriteItem) {
        itemImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
    }
}
