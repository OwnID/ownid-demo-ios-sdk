import Foundation

public protocol ConfigurationFileName: Decodable {
    static var fileName: String { get }
    static var bundle: Bundle { get }
    
    static func defaultInit() -> Self
}

public struct GigyaServerConfig: ConfigurationFileName {
    public let apiKey: String
    public let apiDomain: String!
    public let screenSet: String!
    public static var bundle: Bundle { Bundle.main }
    public static var fileName: String { "GigyaSDKConfiguration" }
    
    public static func defaultInit() -> GigyaServerConfig {
        GigyaServerConfig(apiKey: "apiKey", apiDomain: "apiDomain", screenSet: "screenSet")
    }
}

public struct FeatureFlagsConfig: ConfigurationFileName {
    public let isServicePictureEnabled: Bool
    public let isButtonSwitchEnabled: Bool
    public let isConfigURLEnabled: Bool
    public static var bundle: Bundle { Bundle.module }
    public static var fileName: String { "FeatureFlags" }
    
    public static func defaultInit() -> FeatureFlagsConfig {
        .init(isServicePictureEnabled: false, isButtonSwitchEnabled: false, isConfigURLEnabled: false)
    }
}

public final class AppConfiguration<T: ConfigurationFileName> {
    public let config: T = AppConfiguration.loadJson(T.fileName, bundle: T.bundle) ?? T.defaultInit()
    
    public init() { }
    
    private static func loadJson<T: Decodable>(_ fileName: String, bundle: Bundle) -> T? {
        if let url = bundle.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                return jsonData
            } catch {
                print("\(AppConfiguration.self)➡️ error:\(error)")
            }
        }
        return .none
    }
}
