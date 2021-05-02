import UIKit

class HomeViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var catsView: UIView!
    @IBOutlet weak var favoritesView: UIView!
    @IBOutlet weak var uploadsView: UIView!

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViews()
    }

    // MARK: - IBActions
    @IBAction func userDidChooseAnotherSection(_ sender: UISegmentedControl) {
        updateView(sender.selectedSegmentIndex)
    }

    // MARK: - Private methods
    private func addChildViews() {
        addChildViewController(Configuration.catViewController, to: catsView)
        addChildViewController(Configuration.favoriteViewController, to: favoritesView)
        addChildViewController(Configuration.uploadCatViewController, to: uploadsView)
    }

    private func updateView(_ nextIndex: Int) {
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(nextIndex)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
}
