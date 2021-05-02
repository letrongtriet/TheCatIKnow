import UIKit

extension UIViewController {
	func addChildViewController(_ child: UIViewController, to containerView: UIView) {
		addChild(child)
		containerView.addSubview(child.view)
		child.view.frame = containerView.bounds
		child.didMove(toParent: self)
	}

	func removeFromParentViewController() {
		guard parent != nil else {
			return
		}
		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}

    func showAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            .init(
                title: "OK",
                style: .default
            )
        )

        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: completion)
        }
    }
}
