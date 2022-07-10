import SwiftUI
import OwnIDGigyaSDK
import Gigya
import DemoAppComponents
import GigyaAndScreensetsShared

@main
struct DemoApp: App {
    // MARK: Stored Properties
    let appConfig = AppConfiguration<GigyaServerConfig>()
    @StateObject private var coordinator: AppCoordinator

    init() {
        GigyaShared.instance.initFor(apiKey: appConfig.config.apiKey,
                                     apiDomain: appConfig.config.apiDomain)
        OwnID.GigyaSDK.configure()
        let appCoordinator = AppCoordinator(loginObject: GigyaLogin(),
                                            registerObject: GigyaRegister(),
                                            loggenInObject: GigyaLoggedIn())
        _coordinator = StateObject(wrappedValue: appCoordinator)
    }
    
    // MARK: Scenes
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: coordinator)
        }
    }
}
