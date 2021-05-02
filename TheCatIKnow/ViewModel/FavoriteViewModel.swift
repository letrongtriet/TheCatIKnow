import Foundation

class FavoriteViewModel {
    // MARK: - Dependencies
    let network: NetworkDefinition
    weak var view: BaseView?

    var favorites = [Favorite]()

    // MARK: - Init
    init(network: NetworkDefinition,
         view: BaseView?
    ) {
        self.network = network
        self.view = view
    }

    // MARK: - Public methods
    func viewDidLoad() {
        getFavorites()
    }

    func removeFavoriteCat(_ id: Int) {
        view?.showLoading()

        network.unFavoriteCat(id: "\(id)") { [weak self] result in
            switch result {
            case let .failure(error):
                self?.view?.showError(error: error)
            case .success:
                self?.getFavorites()
            }
        }
    }

    // MARK: - Private methods
    private func getFavorites() {
        view?.showLoading()

        network.getFavorites { [weak self] result in
            switch result {
            case let .failure(error):
                self?.view?.showError(error: error)
            case let .success(favorites):
                self?.favorites = favorites
                favorites.isEmpty ? self?.view?.showEmpty() : self?.view?.updateView()
            }
        }
    }
}
