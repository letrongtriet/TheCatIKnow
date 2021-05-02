import UIKit

class RootCoordinator {
    // MARK: - Private properties
    private let window: UIWindow
    private let navigationController: UINavigationController

    // MARK: - Init
    init(window: UIWindow) {
        self.window = window

        navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = true
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Private methods
    private func makeHomeView() {
        navigationController.setViewControllers([Configuration.homeViewController], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

// MARK: - Coordinator
extension RootCoordinator: Coordinator {
    func start() {
        makeHomeView()
    }
}
