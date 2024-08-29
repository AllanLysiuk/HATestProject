import UIKit

final class ImageCropViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true
        return imageView
    }()
    
    private var addPhotoButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let btnImage = UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 40,
                weight: .bold
            )
        )
        btn.setImage(btnImage, for: .normal)
        btn.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
        return btn
    }()
    
    private var croppingView: CroppingView = {
        let view = CroppingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private var filterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private var filterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.text = "Применить ч/б фильтр"
        label.textColor = .black
        return label
    }()
    
    private var filterSwitch: UISwitch = {
        let filterSwitch = UISwitch()
        filterSwitch.translatesAutoresizingMaskIntoConstraints = false
        filterSwitch.isOn = false
        return filterSwitch
    }()
    
    // MARK: - Private variables
    
    private var viewModel: ImageCropVMProtocol
    private var initialImageViewCenter = CGPoint()
    
    // MARK: - Life cycle
    
    init(viewModel: ImageCropVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        requiredInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func requiredInit() {
        tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "photo.artframe"), tag: 0)
        navigationController?.tabBarItem = tabBarItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.setupDelegate(self)
        setupImageViewGestures()
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        setupStyle()
        addSubviews()
        setupConstraints()
    }
    
    private func setupStyle() {
        self.view.backgroundColor = .white
    }
    
    private func addSubviews() {
        self.view.addSubview(addPhotoButton)
        self.view.addSubview(imageView)
        self.view.addSubview(croppingView)
        self.view.addSubview(filterView)
        filterView.addSubview(filterLabel)
        filterView.addSubview(filterSwitch)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addPhotoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addPhotoButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 50),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: croppingView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: croppingView.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            croppingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            croppingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            croppingView.topAnchor.constraint(equalTo: self.view.topAnchor),
            croppingView.bottomAnchor.constraint(equalTo: filterView.topAnchor),
        ])
        
        NSLayoutConstraint.activate([
            filterView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            filterView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            filterLabel.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 16),
            filterLabel.centerYAnchor.constraint(equalTo: self.filterSwitch.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            filterSwitch.leadingAnchor.constraint(equalTo: self.filterLabel.trailingAnchor, constant: 8),
            filterSwitch.bottomAnchor.constraint(equalTo: filterView.bottomAnchor, constant: -4),
            filterSwitch.topAnchor.constraint(equalTo: filterView.topAnchor, constant: 4),
        ])
    }
    
    // MARK: - Private methods
    
    private func setupNavigationItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить",
            style: .plain,
            target: self,
            action: #selector(saveImageToUserLibrary)
        )
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Удалить фото",
            style: .plain,
            target: self,
            action: #selector(clearImage)
        )
    }
    
    private func setupImageViewGestures() {
        let rotation: UIRotationGestureRecognizer = UIRotationGestureRecognizer(
            target: self,
            action: #selector(self.handleRotation(_:))
        )
        let pinch: UIPinchGestureRecognizer = UIPinchGestureRecognizer(
            target: self,
            action: #selector(self.handlePinch(_:))
        )
        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.handlePan(_:))
        )
        
        rotation.cancelsTouchesInView = false
        pinch.cancelsTouchesInView = false
        pan.cancelsTouchesInView = false
        
        pinch.delegate = self
        rotation.delegate = self
        pan.delegate = self
        
        self.imageView.addGestureRecognizer(rotation)
        self.imageView.addGestureRecognizer(pinch)
        self.imageView.addGestureRecognizer(pan)
    }
    
    private func reconfigureUIBasedOnState() {
        switch viewModel.screenState {
        case .addPhoto:
            imageView.isHidden = true
            addPhotoButton.isHidden = false
            croppingView.isHidden = true
            removeNavigationItems()
        case .editPhoto:
            imageView.isHidden = false
            addPhotoButton.isHidden = true
            croppingView.isHidden = false
            setupNavigationItems()
        }
    }
    
    private func removeNavigationItems() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
    }
    
    // MARK: - Actions
    
    @objc private func addButtonDidTap() {
        viewModel.openImagePicker(self)
    }
    
    @objc private func handleRotation(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard let gestureRecognizerView = gestureRecognizer.view else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizerView.transform = gestureRecognizerView.transform.rotated(by: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
        }
    }
    
    @objc private func handlePinch(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let gestureRecognizerView = gestureRecognizer.view else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizerView.transform = gestureRecognizerView.transform.scaledBy(
                x: gestureRecognizer.scale,
                y: gestureRecognizer.scale
            )
            gestureRecognizer.scale = 1.0
        }
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let gestureRecognizerView = gestureRecognizer.view else {return}
        let piece = gestureRecognizerView
        let translation = gestureRecognizer.translation(in: piece.superview)
        
        if gestureRecognizer.state == .began {
            self.initialImageViewCenter = piece.center
        }
        
        if gestureRecognizer.state != .cancelled {
            let newCenter = CGPoint(
                x: initialImageViewCenter.x + translation.x,
                y: initialImageViewCenter.y + translation.y
            )
            piece.center = newCenter
        }
        else {
            piece.center = initialImageViewCenter
        }
    }
    
    @objc private func saveImageToUserLibrary() {
        if let originalImage = self.imageView.image {
            var croppedImage = viewModel.cropImage(
                imageView: imageView,
                originalImage: originalImage,
                cropFrame: croppingView.getCropReferenceViewFrame()
            )
            
            if filterSwitch.isOn,
               let filteredImage = viewModel.applyBlackWhiteFilter(to: croppedImage) {
                croppedImage = filteredImage
            }
            
            if let croppedImage = croppedImage {
                viewModel.saveImage(image: croppedImage, completionTarget: self, #selector(image(_:didFinishSavingWithError:contextInfo:)))
            } else {
                viewModel.openErrorPopUp(title: "Ошибка", message: "Упс, что-то пошло не так. Попробуйте повторить действие позже")
            }
        } else {
            viewModel.openErrorPopUp(title: "Ошибка", message: "Выберите фото из галереи чтобы ее сохранить")
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            viewModel.openErrorPopUp(title: "Ошибка", message: "Не удалось сохранить изображение: \(error.localizedDescription)")
        } else {
            viewModel.openErrorPopUp(title: "Успех", message: "Изображение успешно сохранено в галерею.")
        }
    }
    
    @objc private func clearImage() {
        self.imageView.image = nil
        viewModel.changeScreenState(to: .addPhoto)
    }
    
}

// MARK: - UIImagePickerController extension

extension ImageCropViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        viewModel.dismissImagePicker()
        if let image = viewModel.didFinishPickingMediaWithInfo(info) {
            viewModel.changeScreenState(to: .editPhoto)
            self.imageView.image = image
        } else {
            viewModel.openErrorPopUp(title: "Ошибка", message: "Упс, что-то пошло не так. Попробуйте повторить действие позже")
        }
    }
}

// MARK: - ImageCropVCDelegate extension

extension ImageCropViewController: ImageCropVCDelegate {
    func screenStateDidChange() {
        self.reconfigureUIBasedOnState()
    }
}

// MARK: - UIGestureRecognizerDelegate extension

extension ImageCropViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UIImage {
    static func image(fromView view: UIView) -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        view.alpha = 1.0
        view.layer.render(in: context)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
