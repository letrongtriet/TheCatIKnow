import Foundation

class CatViewModel {
    let network: NetworkDefinition
    weak var view: BaseView?

    var breeds = [Breed]()
    var cats = [Cat]()
    var favorites = [Favorite]()
    private var apiCats = [Cat]()

    var currentBreedId = ""

    init(network: NetworkDefinition,
         view: BaseView?
    ) {
        self.network = network
        self.view = view
    }

    func viewDidLoad() {
        getCats()
    }

    func userDidChooseBreedId(_ id: String) {
        currentBreedId = currentBreedId == id ? "" : id
        updateViewWithFilterIfNeeded()
    }

    func favoriteCat(_ id: String) {
        view?.showLoading()

        network.favoriteCat(id: id) { [weak self] result in
            switch result {
            case let .failure(error):
                self?.view?.showError(error: error)
            case .success:
                self?.getFavorites()
            }
        }
    }

    func unFavoriteCat(_ id: String) {
        guard let idToChange = favorites.first(where: { $0.image.id == id })?.id else { return }

        view?.showLoading()

        network.unFavoriteCat(id: "\(idToChange)") { [weak self] result in
            switch result {
            case let .failure(error):
                self?.view?.showError(error: error)
            case .success:
                self?.getFavorites()
            }
        }
    }

    private func getCats() {
        view?.showLoading()

        network.getCats { [weak self] result in
            switch result {
            case let .failure(error):
                self?.view?.showError(error: error)
            case let .success(cats):
                self?.apiCats = cats
                self?.getBreeds()
            }
        }
    }

    private func getBreeds() {
        view?.showLoading()

        network.getBreeds { [weak self] result in
            switch result {
            case let .failure(error):
                self?.view?.showError(error: error)
            case let .success(breeds):
                self?.breeds = breeds
                self?.getFavorites()
            }
        }
    }

    private func getFavorites() {
        view?.showLoading()

        network.getFavorites { [weak self] result in
            switch result {
            case let .failure(error):
                self?.view?.showError(error: error)
            case let .success(favorites):
                self?.favorites = favorites
                self?.updateViewWithFilterIfNeeded()
            }
        }
    }

    private func updateViewWithFilterIfNeeded() {
        if currentBreedId.isEmpty {
            cats = apiCats
            cats.isEmpty ? view?.showEmpty() : view?.updateView()
        } else {
            cats = apiCats.filter({ $0.breeds.map({ $0.id }).contains(currentBreedId) })
            cats.isEmpty ? view?.showEmpty() : view?.updateView()
        }
    }
}
