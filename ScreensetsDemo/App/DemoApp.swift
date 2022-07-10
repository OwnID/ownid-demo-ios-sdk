import SwiftUI
import DemoAppComponents
import GigyaAndScreensetsShared

@main
struct DemoApp: App {
    // MARK: Stored Properties
    let appConfig = AppConfiguration<GigyaServerConfig>()

    init() {
        GigyaShared.instance.initFor(apiKey: appConfig.config.apiKey,
                                     apiDomain: appConfig.config.apiDomain)
    }
    
    @StateObject var coordinator = AppCoordinator()

    // MARK: Scenes
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: coordinator)
        }
    }
}
