import UIKit

final class ImageCropVCCoordinator: Coordinator {
    private var tabBarController: UITabBarController
    private var rootCoordinator: ImageCropVCRootCoordinatorProtocol
    private var navigationController = UINavigationController()
    private var container: Container
    
    var childCoordinators: [Coordinator] = []
    
    init(
        tabBarController: UITabBarController,
        rootCoordinator: ImageCropVCRootCoordinatorProtocol,
        container: Container
    ) {
        self.tabBarController = tabBarController
        self.rootCoordinator = rootCoordinator
        self.container = container
    }
    
    func start() {
        let vc = ImageCropVCAssembler.makeImageCropVC(
            coordinator: self,
            container: container
        )
        navigationController.addChild(vc)
        tabBarController.addChild(navigationController)
    }
    
    func finish() {
        tabBarController.removeFromParent()
        rootCoordinator.imageCropSceneFinished(self)
    }
}

extension ImageCropVCCoordinator: ImageCropVCCoordinatorProtocol {
    func openImagePicker(_ delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = delegate
        self.navigationController.present(picker, animated: true)
    }
    
    func dismissImagePicker() {
        self.navigationController.dismiss(animated: true)
    }
    
    func openErrorPopUp(_ alert: UIAlertController) {
        self.navigationController.present(alert, animated: true)
    }
}
