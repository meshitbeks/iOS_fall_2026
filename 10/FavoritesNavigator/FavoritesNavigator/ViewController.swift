import UIKit

/// List screen. It is the root screen of the navigation controller (set in Main.storyboard).
class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    private let items = FavoritesLibrary.items

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Deselect the tapped row after coming back from the Detail screen.
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    // MARK: - Navigation

    /// Called right before the "showDetail" segue. Passes only data to the Detail screen.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail",
              let detailViewController = segue.destination as? DetailViewController,
              let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        detailViewController.item = items[indexPath.row]
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
