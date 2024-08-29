import UIKit

final class ImageCropVCAssembler {
    private init() { }
    
    static func makeImageCropVC(
        coordinator: ImageCropVCCoordinatorProtocol,
        container: Container
    ) -> UIViewController {
        return ImageCropViewController(
            viewModel: makeViewModel(
                coordinator: coordinator,
                container: container
            )
        )
    }
    
    private static func makeViewModel(
        coordinator: ImageCropVCCoordinatorProtocol,
        container: Container
    ) -> ImageCropVMProtocol {
        return ImageCropViewModel(
            coordinator: coordinator,
            alertFactory: makeAlertFactory(container: container)
        )
    }
    
    private static func makeAlertFactory(container: Container) -> AlertFactoryProtocol {
        return container.resolve()
    }
    
}
