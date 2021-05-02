import UIKit

class FavoriteCatViewController: UIViewController {
    // MARK: - Dependencies
    var viewModel: FavoriteViewModel!

    // MARk: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Private properties
    private var refreshControl = UIRefreshControl()

    // MARK: - Private methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
        viewModel.viewDidLoad()
    }

    // MARK: - Private methods
    private func configTableView() {
        tableView.configBasicTableView()
        tableView.delegate = self
        tableView.dataSource = self

        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc
    private func refresh() {
        viewModel.viewDidLoad()
    }
}

extension FavoriteCatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CatListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.selectionStyle = .none
        cell.updateCell(with:.init(
            id: "\(viewModel.favorites[indexPath.row].id)",
            breed: nil,
            urlString: viewModel.favorites[indexPath.row].image.url,
            isFavorited: true
        ))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = viewModel.favorites[indexPath.row]

        let deleteAction = UIContextualAction(
            style: .normal,
            title: "UnFavorite"
        ) { [weak self] _, _, completion in
            self?.viewModel.removeFavoriteCat(item.id)
            completion(true)
        }
        deleteAction.backgroundColor = .red

        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeAction
    }
}

extension FavoriteCatViewController: BaseView {
    func showLoading() {
        tableView.showLoadingIndicator()
    }

    func showError(error: Error?) {
        tableView.hideLoadingIndicator()
        showAlert(title: "Unexpected Error!", message: "Pull down to retry")
    }

    func showEmpty() {
        tableView.hideLoadingIndicator()
        tableView.setEmptyMessage("Oops! Seems like there is no cat in your favorite list!")
        tableView.reloadDataAnimated()
    }

    func updateView() {
        tableView.hideLoadingIndicator()
        tableView.restore()
        tableView.reloadDataAnimated()
    }
}
