import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    private let items = FavoritesLibrary.items

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count   // one row per item
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseIdentifier, for: indexPath) as? FavoriteCell else {
            print("Cell with identifier \(FavoriteCell.reuseIdentifier) is not a FavoriteCell")
            return UITableViewCell()
        }
        cell.configure(with: items[indexPath.row])
        return cell
    }
}
