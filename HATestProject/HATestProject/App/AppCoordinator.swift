import UIKit

final class AppCoordinator: Coordinator {
    private var windowScene: UIWindowScene
    private var window: UIWindow?
    var childCoordinators: [Coordinator] = []
    
    private var container: Container = {
        let container = Container()
        ServiceConfigurations.configure(container: container)
        return container
    }()
    
    init (windowScene: UIWindowScene) {
        self.windowScene = windowScene
    }
    
    func start() {
        openMainScene()
        window?.makeKeyAndVisible()
    }
    
    func finish() {

    }
    
    private func openMainScene() {
        let mainWindow = UIWindow(windowScene: windowScene)
        let nc = UINavigationController()
        mainWindow.rootViewController = nc
        mainWindow.makeKeyAndVisible()
        
        let tabBarCoordinator = TabBarCoordinator(
            rootNavigationController: nc,
            rootCoordinator: self,
            container: container
        )
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
        
        window = mainWindow
    }
    
}

extension AppCoordinator: TabBarRootCoordinatorProtocol {
    func mainSceneFinished(_ coordinator: Coordinator) {
        childCoordinators.removeAll { tmp in
            tmp === coordinator
        }
        start()
    }
}
