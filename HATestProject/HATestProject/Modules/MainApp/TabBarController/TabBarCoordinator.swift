import UIKit

final class TabBarCoordinator: Coordinator {
    
    private var rootNavigationController: UINavigationController
    private var rootCoordinator: TabBarRootCoordinatorProtocol
    private var container: Container
    
    var childCoordinators: [Coordinator] = []
    
    init(
        rootNavigationController: UINavigationController,
        rootCoordinator: TabBarRootCoordinatorProtocol,
        container: Container
    ) {
        self.rootNavigationController = rootNavigationController
        self.rootCoordinator = rootCoordinator
        self.container = container
    }
    
    func start() {
        let tabBar = TabBarAssembler.makeTabBarController(coordinator: self)
        rootNavigationController.navigationBar.isHidden = true
        
        generateImageCropItem(tabBar)
        generateSettingsItem(tabBar)
        
        rootNavigationController.pushViewController(tabBar, animated: true)
    }
    
    func finish() {
        rootNavigationController.popViewController(animated: false)
        rootCoordinator.mainSceneFinished(self)
    }
}

extension TabBarCoordinator {
    
    private func generateImageCropItem(_ tabBar: UITabBarController) {
        let coordinator = ImageCropVCCoordinator(
            tabBarController: tabBar,
            rootCoordinator: self,
            container: container
        )
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func generateSettingsItem(_ tabBar: UITabBarController) {
        let coordinator = SettingsVCCoordinator(
            tabBarController: tabBar,
            rootCoordinator: self,
            container: container
        )
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
}

extension TabBarCoordinator: TabBarCoordinatorProtocol { }

extension TabBarCoordinator: ImageCropVCRootCoordinatorProtocol {
    func imageCropSceneFinished(_ coordinator: Coordinator) {
        childCoordinators = []
        rootNavigationController.popViewController(animated: false)
        rootCoordinator.mainSceneFinished(self)
    }
}

extension TabBarCoordinator: SettingsVCRootCoordinatorProtocol {
    func settingsSceneFinished(_ coordinator: Coordinator) {
        childCoordinators = []
        rootNavigationController.popViewController(animated: false)
        rootCoordinator.mainSceneFinished(self)
    }
}
