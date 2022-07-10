import UIKit
import OwnIDGigyaSDK
import DemoAppComponents
import GigyaAndScreensetsShared

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Stored Properties
    let appConfig = AppConfiguration<GigyaServerConfig>()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GigyaShared.instance.initFor(apiKey: appConfig.config.apiKey,
                                     apiDomain: appConfig.config.apiDomain)
        OwnID.GigyaSDK.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

