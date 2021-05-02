import Foundation

class UploadViewModel {
    let network: NetworkDefinition
    weak var view: BaseView?

    var cats = [Cat]()

    init(network: NetworkDefinition,
         view: BaseView?
    ) {
        self.network = network
        self.view = view
    }

    // MARK: - Public methods
    func viewDidLoad() {
        getUploads()
    }

    func uploadImage(_ urlString: String) {
        view?.showLoading()

        let boundary = "Boundary-\(UUID().uuidString)"
        network.uploadCat(urlString: urlString, boundary: boundary) { [weak self] result in
            switch result {
            case let .failure(error):
                self?.view?.showError(error: error)
            case .success:
                self?.getUploads()
            }
        }
    }

    // MARK: - Private methods
    private func getUploads() {
        view?.showLoading()

        network.getUploads { [weak self] result in
            switch result {
            case let .failure(error):
                self?.view?.showError(error: error)
            case let .success(cats):
                self?.cats = cats
                cats.isEmpty ? self?.view?.showEmpty() : self?.view?.updateView()
            }
        }
    }
}
