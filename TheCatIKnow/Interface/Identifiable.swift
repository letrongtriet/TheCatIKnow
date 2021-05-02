import UIKit

protocol Identifiable {
	static func identifier() -> String
	var identifier: String { get }
}

extension Identifiable {
	static func identifier() -> String {
		String(describing: self)
	}

	var identifier: String {
		type(of: self).identifier()
	}
}

extension UICollectionReusableView: Identifiable {}
extension UIViewController: Identifiable {}
extension UITableViewHeaderFooterView: Identifiable {}
extension UITableViewCell: Identifiable {}

extension UICollectionViewCell {
	static func registerNib(in collectionView: UICollectionView) {
		collectionView.register(
			UINib(nibName: Self.identifier(), bundle: nil),
			forCellWithReuseIdentifier: Self.identifier()
		)
	}
}

extension UICollectionReusableView {
	static func registerNib(
		in collectionView: UICollectionView,
		forSupplementaryViewOfKind kind: String
	) {
		collectionView.register(
			UINib(nibName: Self.identifier(), bundle: nil),
			forSupplementaryViewOfKind: kind,
			withReuseIdentifier: Self.identifier()
		)
	}
}

extension UITableViewHeaderFooterView {
	static func registerNib(in tableView: UITableView) {
		tableView.register(
			UINib(
				nibName: Self.identifier(),
				bundle: nil
			),
			forHeaderFooterViewReuseIdentifier: Self.identifier()
		)
	}
}

extension UITableViewCell {
	static func registerNib(in tableView: UITableView) {
		tableView.register(
			UINib(
				nibName: Self.identifier(),
				bundle: nil
			),
			forCellReuseIdentifier: Self.identifier()
		)
	}
}

extension UITableView {
	func dequeueReusableCell<T: UITableViewCell>(
		withIdentifier identifier: String = T.identifier(),
		for indexPath: IndexPath
	) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T
		else {
			fatalError("Unable to dequeue cell with identifier: \(identifier)")
		}
		return cell
	}

	func dequeueReusableCell<T: UITableViewCell>(
		withIdentifier identifier: String = T.identifier()
	) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: identifier) as? T else {
			fatalError("Unable to dequeue cell with identifier: \(identifier)")
		}
		return cell
	}
}

extension UICollectionView {
	func dequeueReusableCell<T: UICollectionViewCell>(
		withIdentifier identifier: String = T.identifier(),
		for indexPath: IndexPath
	) -> T {
		guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T
		else {
			fatalError("Unable to dequeue cell with identifier: \(identifier)")
		}
		return cell
	}

	func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
		ofKind elementKind: String,
		withReuseIdentifier identifier: String = T.identifier(),
		for indexPath: IndexPath
	) -> T {
		guard let view = dequeueReusableSupplementaryView(
			ofKind: elementKind,
			withReuseIdentifier: identifier,
			for: indexPath
		) as? T else {
			fatalError("Unable to dequeue reusable supplementary view with identifier: \(identifier)")
		}
		return view
	}
}
