import UIKit

final class SettingsVCCoordinator: Coordinator {
    private var tabBarController: UITabBarController
    private var rootCoordinator: SettingsVCRootCoordinatorProtocol
    private var navigationController = UINavigationController()
    private var container: Container
    
    var childCoordinators: [Coordinator] = []
    
    init(
        tabBarController: UITabBarController,
        rootCoordinator: SettingsVCRootCoordinatorProtocol,
        container: Container
    ) {
        self.tabBarController = tabBarController
        self.rootCoordinator = rootCoordinator
        self.container = container
    }
    
    func start() {
        let vc = SettingsVCAssembler.makeSettingsVC(
            coordinator: self,
            container: container
        )
        navigationController.addChild(vc)
        tabBarController.addChild(navigationController)
    }
    
    func finish() {
        tabBarController.removeFromParent()
        rootCoordinator.settingsSceneFinished(self)
    }
}

extension SettingsVCCoordinator: SettingsVCCoordinatorProtocol {

    func openAboutMePopUp(_ alert: UIAlertController) {
        self.navigationController.present(alert, animated: true)
    }
}
