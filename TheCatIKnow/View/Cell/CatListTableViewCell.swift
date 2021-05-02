import SDWebImage
import UIKit

class CatListTableViewCell: UITableViewCell {
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
}

extension CatListTableViewCell: CatListCellView {
    func updateCell(with model: CatListCellModel) {
        catImageView.sd_setImage(with: URL(string: model.urlString))
        idLabel.text = model.id
    }
}
