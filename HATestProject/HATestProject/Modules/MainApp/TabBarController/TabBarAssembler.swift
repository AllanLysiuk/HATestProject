import UIKit

final class TabBarAssembler {
    
    private init() { }
    
    static func makeTabBarController(coordinator: TabBarCoordinatorProtocol) -> UITabBarController {
        return TabBarController()
    }
    
}
