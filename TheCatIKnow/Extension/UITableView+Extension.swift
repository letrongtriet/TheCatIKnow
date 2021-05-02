import UIKit

extension UITableView {
    func reloadDataAnimated() {
        UIView.transition(with: self,
                          duration: 0.25,
                          options: [.beginFromCurrentState, .transitionCrossDissolve],
                          animations: { self.reloadData() },
                          completion: { _ in self.refreshControl?.endRefreshing() })
    }

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        messageLabel.sizeToFit()
        backgroundView = messageLabel
        separatorStyle = .none
    }

    func restore() {
        backgroundView = nil
        separatorStyle = .singleLine
    }

    func configBasicTableView() {
        CatListTableViewCell.registerNib(in: self)
        tableFooterView = UIView()
        tableHeaderView = UIView()
        rowHeight = 80
        estimatedRowHeight = 80
        separatorStyle = .singleLine
        separatorColor = .gray
    }
}
