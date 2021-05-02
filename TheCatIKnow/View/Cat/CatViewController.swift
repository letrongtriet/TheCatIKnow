import UIKit

class CatViewController: UIViewController {
    enum Constants {
        static let cellSpacing: CGFloat = 8
        static let numberOfCellPerRow: CGFloat = 3
    }

    // MARK: - Dependencies
    var viewModel: CatViewModel!

    // MARK: - IBOutlets
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Private properties
    private var refreshControl = UIRefreshControl()
    private var didShowAlert = false

    private var currentCatDetailViewController: CatDetailViewController?

        // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        configCollectionView()
        viewModel.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard !didShowAlert else { return }
        showAlert(title: "IMPORTANT", message: "Double Tap Image to Favorite/UnFavorite \n\n Long Press to view details") { [weak self] in
            self?.didShowAlert = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        filterButton.layer.cornerRadius = filterButton.bounds.width / 2
        filterButton.layer.masksToBounds = true
    }

    // MARK: - IBActions
    @IBAction func filterButtonPressed(_ sender: Any) {
        showCatBreeds()
    }

    // MARK: - Private methods
    private func configCollectionView() {
        CatCollectionViewCell.registerNib(in: collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self

        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    private func showCatBreeds() {
        let actionSheet = UIAlertController(title: "Choose a breed!", message: nil, preferredStyle: .actionSheet)
        viewModel.breeds.forEach { breed in
            var name = breed.name
            if !viewModel.currentBreedId.isEmpty {
                name += breed.id == viewModel.currentBreedId ? " ✓" : ""
            }
            actionSheet.addAction(.init(title: name, style: .default, handler: { [weak self] _ in
                self?.viewModel.userDidChooseBreedId(breed.id)
            }))
        }
        actionSheet.addAction(.init(title: "Cancel", style: .cancel))
        DispatchQueue.main.async { [weak self] in
            self?.present(actionSheet, animated: true)
        }
    }

    @objc
    private func refresh() {
        viewModel.viewDidLoad()
    }

    private func showCatDetail(_ cat: Cat) {
        let catDetailViewController = CatDetailViewController(
            nibName: CatDetailViewController.identifier(),
            bundle: nil
        )

        catDetailViewController.cat = cat
        catDetailViewController.isFavorited = viewModel.favorites.map({ $0.image.id }).contains(cat.id)

        catDetailViewController.favoriteCallBack = { [weak self] in
            self?.viewModel.favoriteCat(cat.id)
        }

        DispatchQueue.main.async { [weak self] in
            self?.present(catDetailViewController, animated: true)
        }
    }
}

extension CatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.cats[indexPath.row]
        let cell: CatCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        cell.updateCell(with: .init(
            id: item.id,
            breed: item.breeds.map({ $0.name }).joined(separator: ", "),
            urlString: item.url,
            isFavorited: viewModel.favorites.map({ $0.image.id }).contains(item.id)
        ))

        cell.doubleTapCallBack = { [weak self] isFavorited in
            isFavorited ? self?.viewModel.favoriteCat(item.id) : self?.viewModel.unFavoriteCat(item.id)
        }

        cell.tapCallBack = { [weak self] in
            self?.showCatDetail(item)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let remainingWidth = collectionViewWidth - ( (Constants.numberOfCellPerRow - 1) * Constants.cellSpacing)
        let cellWidth = remainingWidth / Constants.numberOfCellPerRow
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        .zero
    }
}

extension CatViewController: BaseView {
    func updateView() {
        collectionView.hideLoadingIndicator()
        collectionView.restore()
        collectionView.reloadDataAnimated()
    }

    func showLoading() {
        collectionView.showLoadingIndicator()
    }

    func showError(error: Error?) {
        collectionView.hideLoadingIndicator()
        showAlert(title: "Unexpected Error!", message: "Pull down to retry")
    }

    func showEmpty() {
        collectionView.hideLoadingIndicator()
        collectionView.setEmptyMessage("Oops! Seems like there is no cat with this breed!")
        collectionView.reloadDataAnimated()
    }
}
