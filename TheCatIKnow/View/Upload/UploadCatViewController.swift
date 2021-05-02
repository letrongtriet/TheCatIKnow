import UIKit

class UploadCatViewController: UIViewController {
    // MARK: - Dependencies
    var viewModel: UploadViewModel!

    // MARk: - IBOutlets
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Private properties
    private var imagePicker: UIImagePickerController!

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
        viewModel.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        uploadButton.layer.cornerRadius = uploadButton.bounds.width / 2
        uploadButton.layer.masksToBounds = true
    }

    // MARK: - IBActions
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        showImagePickerActionSheet()
    }

    // MARK: - Private methods
    private func showImagePickerActionSheet() {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )

        if UIImagePickerController.isCameraDeviceAvailable(.rear) || UIImagePickerController.isCameraDeviceAvailable(.front) {
            let cameraAction = UIAlertAction(
                title: "Take and Upload",
                style: .default,
                handler: { [weak self] _ in
                    self?.selectImageFrom(.camera)
                }
            )
            alertController.addAction(cameraAction)
        }

        let photoLibraryAction = UIAlertAction(
            title: "Upload",
            style: .default,
            handler: { [weak self] _ in
                self?.selectImageFrom(.photoLibrary)
            }
        )
        alertController.addAction(photoLibraryAction)

        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    private func selectImageFrom(_ source: ImageSource){
        imagePicker = UIImagePickerController()
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.delegate = self

        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }

        present(imagePicker, animated: true)
    }

    private func configTableView() {
        tableView.configBasicTableView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension UploadCatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CatListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.selectionStyle = .none
        cell.updateCell(with:.init(
            id: viewModel.cats[indexPath.row].id,
            breed: nil,
            urlString: viewModel.cats[indexPath.row].url,
            isFavorited: true
        ))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

// MARK: - UIImagePickerControllerDelegate
extension UploadCatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    enum ImageSource {
        case photoLibrary
        case camera
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        if let selectedFileUrl = info[.imageURL] as? URL {
            viewModel.uploadImage(selectedFileUrl.absoluteString)
        } else if let capturedImage = info[.originalImage] as? UIImage {
            let fileName = "\(Date()).png"

            if let data = capturedImage.jpegData(compressionQuality: 0.2),
               let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName) {
                do {
                    try data.write(to: fileUrl)
                    viewModel.uploadImage(fileUrl.absoluteString)
                } catch {
                    showError(error: error)
                }
            }
        }
    }
}

extension UploadCatViewController: BaseView {
    func showLoading() {
        tableView.showLoadingIndicator()
    }

    func showError(error: Error?) {
        tableView.hideLoadingIndicator()
        showAlert(title: "Unexpected Error!", message: "Try again later")
    }

    func showEmpty() {
        tableView.hideLoadingIndicator()
        tableView.setEmptyMessage("Oops! Seems like there is no cat in your favorite list!")
        tableView.reloadDataAnimated()
    }

    func updateView() {
        tableView.hideLoadingIndicator()
        tableView.restore()
        tableView.reloadDataAnimated()
    }
}
