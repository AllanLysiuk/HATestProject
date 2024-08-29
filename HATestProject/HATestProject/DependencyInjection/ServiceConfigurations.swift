import Foundation

final class ServiceConfigurations {
    
    private init() {  }
    
    static func configure(container: Container) {
        container.register({ Self.alertFactory })
    }
    
}

protocol AlertFactoryProtocol: AnyObject, AlertControllerFactoryProtocol { }

private extension ServiceConfigurations {
    
    static var alertFactory: AlertFactoryProtocol {
        return AlertControllerFactory()
    }
    
}
