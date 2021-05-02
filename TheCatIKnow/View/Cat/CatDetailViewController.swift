import SDWebImage
import UIKit

class CatDetailViewController: UIViewController {
    // MARK: - Dependencies
    var cat: Cat?
    var isFavorited: Bool?

    var favoriteCallBack: (() -> Void)?

    // MARK: - IBOutlets
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var catBreedLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteImageView: UIImageView!

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateFavorite()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        favoriteButton.layer.cornerRadius = 8
        favoriteButton.layer.masksToBounds = true

        catImageView.layer.cornerRadius = 8
        catImageView.layer.masksToBounds = true
    }

    // MARK: - IBActions
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.favoriteCallBack?()
        }
    }

    // MARK: - Private methods
    private func updateUI() {
        guard let cat = cat else { return }

        catImageView.sd_setImage(with: URL(string: cat.url))
        catBreedLabel.text = cat.breeds.map({ $0.name }).joined(separator: ", ")
        idLabel.text = cat.id
    }

    private func updateFavorite() {
        guard let isFavorited = isFavorited else { return }

        favoriteButton.isHidden = isFavorited
        favoriteImageView.isHidden = !isFavorited
    }
}
