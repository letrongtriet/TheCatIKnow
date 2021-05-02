import Foundation

protocol BaseView: AnyObject {
    func showLoading()
    func showError(error: Error?)
    func showEmpty()
    func updateView()
}
