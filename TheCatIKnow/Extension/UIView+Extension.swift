import UIKit

extension UIView {
    func showLoadingIndicator() {
        guard viewWithTag(0xDEADBEEF) == nil else { return }
        
        let containerView = UIView(frame: bounds)
        containerView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        containerView.tag = 0xDEADBEEF
        containerView.layer.cornerRadius = layer.cornerRadius

        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.startAnimating()

        containerView.addSubview(loadingIndicator)
        loadingIndicator.center = containerView.center
        addSubview(containerView)
        bringSubviewToFront(containerView)
    }

    func hideLoadingIndicator() {
        if let foundView = viewWithTag(0xDEADBEEF) {
            foundView.removeFromSuperview()
        }
    }
}
