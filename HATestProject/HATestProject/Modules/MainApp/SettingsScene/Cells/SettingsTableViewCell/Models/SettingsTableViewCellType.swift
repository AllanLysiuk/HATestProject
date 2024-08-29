import Foundation

enum SettingsTableViewCellType {
    case aboutApp
    
    var cellName: String {
        switch self {
        case .aboutApp:
            return "О приложении"
        }
    }
}
