import SwiftUI
import DemoAppComponents
import OwnIDCoreSDK

extension DemoApp {
    static let clientName = "CustomIntegrationDemoApp"
    static let version = "0.0.1"
}

@main
struct DemoApp: App {
    private static func info() -> OwnID.CoreSDK.SDKInformation {
        (clientName, version)
    }
    
    init() {
        OwnID.CoreSDK.shared.configure(userFacingSDK: DemoApp.info(), underlyingSDKs: [])
        let appCoordinator = AppCoordinator(loginObject: Login(),
                                            registerObject: Register(),
                                            loggenInObject: LoggedIn())
        _coordinator = StateObject(wrappedValue: appCoordinator)
    }
    
    // MARK: Stored Properties
    
    @StateObject var coordinator: AppCoordinator
    
    // MARK: Scenes
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: coordinator)
                .onOpenURL { url in
                    OwnID.CoreSDK.shared.handle(url: url, sdkConfigurationName: Self.clientName)
                }
        }
    }
}
