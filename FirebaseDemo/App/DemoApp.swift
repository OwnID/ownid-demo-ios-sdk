import SwiftUI
import OwnIDFirebaseSDK
import Firebase
import DemoAppComponents

@main
struct DemoApp: App {
    
    init() {
        FirebaseApp.configure()
        OwnID.FirebaseSDK.configure()
        let appCoordinator = AppCoordinator(loginObject: FirebaseLogin(),
                                            registerObject: FirebaseRegister(),
                                            loggenInObject: FirebaseLoggedIn())
        _coordinator = StateObject(wrappedValue: appCoordinator)
    }
    
    // MARK: Stored Properties
    
    @StateObject var coordinator: AppCoordinator
    
    // MARK: Scenes
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: coordinator)
        }
    }
}
