import UIKit

enum Configuration {
    static var homeViewController: HomeViewController {
        let homeViewController = HomeViewController(nibName: HomeViewController.identifier(), bundle: nil)
        return homeViewController
    }

    static var catViewController: CatViewController {
        let networkManager = NetworkManager(baseUrlString: Constants.Network.baseUrl)
        let catViewController = CatViewController(
            nibName: CatViewController.identifier(),
            bundle: nil
        )
        catViewController.viewModel = .init(
            network: networkManager,
            view: catViewController
        )
        return catViewController
    }

    static var favoriteViewController: FavoriteCatViewController {
        let networkManager = NetworkManager(baseUrlString: Constants.Network.baseUrl)
        let favoriteViewController = FavoriteCatViewController(
            nibName: FavoriteCatViewController.identifier(),
            bundle: nil
        )
        favoriteViewController.viewModel = .init(
            network: networkManager,
            view: favoriteViewController
        )
        return favoriteViewController
    }

    static var uploadCatViewController: UploadCatViewController {
        let networkManager = NetworkManager(baseUrlString: Constants.Network.baseUrl)
        let uploadCatViewController = UploadCatViewController(
            nibName: UploadCatViewController.identifier(),
            bundle: nil
        )
        uploadCatViewController.viewModel = .init(
            network: networkManager,
            view: uploadCatViewController
        )
        return uploadCatViewController
    }
}
