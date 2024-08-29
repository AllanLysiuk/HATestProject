import UIKit

final class SettingsVCAssembler {
    private init() { }
    
    static func makeSettingsVC(
        coordinator: SettingsVCCoordinatorProtocol,
        container: Container
    ) -> UIViewController {
        return SettingsViewController(
            viewModel: makeViewModel(
                coordinator: coordinator,
                container: container
            )
        )
    }
    
    private static func makeViewModel(
        coordinator: SettingsVCCoordinatorProtocol,
        container: Container
    ) -> SettingsVMProtocol {
        return SettingsViewModel(
            coordinator: coordinator,
            alertFactory: makeAlertFactory(container: container)
        )
    }
    
    private static func makeAlertFactory(container: Container) -> AlertFactoryProtocol {
        return container.resolve()
    }
    
}
