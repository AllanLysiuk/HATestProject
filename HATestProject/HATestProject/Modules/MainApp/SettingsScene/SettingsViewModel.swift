import Foundation

final class SettingsViewModel: SettingsVMProtocol {
    
    private weak var coordinator: SettingsVCCoordinatorProtocol?
    private var alertFactory: AlertControllerFactoryProtocol
    
    var settingsCell: [SettingsTableViewCellType] = [.aboutApp]
    
    init(
        coordinator: SettingsVCCoordinatorProtocol,
        alertFactory: AlertControllerFactoryProtocol
    ) {
        self.coordinator = coordinator
        self.alertFactory = alertFactory
    }
    
    func openAboutAppPopUp() {
        let alert = alertFactory.makeAlert(
            title: "Автор",
            message: "Aллан Лысюк\ntg: @kdhxu",
            actions: [
                .default("Ок", nil)
            ]
        )
        coordinator?.openAboutMePopUp(alert)
    }
    
    func finish() {
        coordinator?.finish()
    }
    
}
