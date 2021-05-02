import SDWebImage
import UIKit

class CatCollectionViewCell: UICollectionViewCell {
    var doubleTapCallBack: ((Bool) -> Void)?
    var tapCallBack: (() -> Void)?
    private var model: CatListCellModel?

    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var catBreedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGesture()
    }

    private func addTapGesture() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapRecognized))
        longPressRecognizer.delaysTouchesBegan = true
        backgroundButton.addGestureRecognizer(longPressRecognizer)
        
        backgroundButton.addTarget(self, action: #selector(doubleTapRecognized), for: .touchDownRepeat)
    }

    @objc
    private func tapRecognized(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            tapCallBack?()
        }
    }

    @objc
    private func doubleTapRecognized() {
        guard let model = model else { return }
        doubleTapCallBack?(!model.isFavorited)
    }
}

extension CatCollectionViewCell: CatListCellView {
    func updateCell(with model: CatListCellModel) {
        self.model = model
        catImageView.sd_setImage(with: URL(string: model.urlString))
        favoriteImageView.isHidden = !model.isFavorited
        catBreedLabel.text = model.breed
    }
}
