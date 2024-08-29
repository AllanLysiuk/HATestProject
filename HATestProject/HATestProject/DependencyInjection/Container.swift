import Foundation

final class Container {
    typealias LazyInitClosure = () -> Any
    
    private var dependencies: [String: Any] = [:]
    private var lazyDependencies: [String: LazyInitClosure] = [:]
    
    func register<DT: Any>(_ closure: @escaping () -> DT) {
        lazyDependencies["\(DT.self)"] = closure
    }
    
    func resolve<DT: Any>() -> DT {
        if dependencies["\(DT.self)"] == nil {
            let dependency = lazyDependencies["\(DT.self)"]?()
            dependencies["\(DT.self)"] = dependency
        }
        return dependencies["\(DT.self)"] as! DT
    }
}
