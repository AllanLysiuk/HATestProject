import Foundation

protocol SettingsVMProtocol {
    func openAboutAppPopUp()
    
    var settingsCell: [SettingsTableViewCellType] { get }
}
