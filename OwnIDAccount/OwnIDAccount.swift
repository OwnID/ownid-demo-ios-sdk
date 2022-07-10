import Gigya

public class OwnIDAccount: GigyaAccountProtocol {
    public var UID: String?
    public var profile: GigyaProfile?
    public var UIDSignature: String?
    public var apiVersion: Int?
    public var created: String?
    public var createdTimestamp: Double?
    public var isActive: Bool?
    public var isRegistered: Bool?
    public var isVerified: Bool?
    public var lastLogin: String?
    public var lastLoginTimestamp: Double?
    public var lastUpdated: String?
    public var lastUpdatedTimestamp: Double?
    public var loginProvider: String?
    public var oldestDataUpdated: String?
    public var oldestDataUpdatedTimestamp: Double?
    public var registered: String?
    public var registeredTimestamp: Double?
    public var signatureTimestamp: String?
    public var socialProviders: String?
    public var verified: String?
    public var verifiedTimestamp: Double?
    public var data: OwnIdKey?
    
    enum CodingKeys: String, CodingKey {
        case UID,
             profile,
             UIDSignature,
             data
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.UID = try? container.decodeIfPresent(String.self, forKey: .UID)
        self.profile = try? container.decodeIfPresent(GigyaProfile.self, forKey: .profile)
        self.UIDSignature = try? container.decodeIfPresent(String.self, forKey: .UIDSignature)
        self.data = try? container.decodeIfPresent(OwnIdKey.self, forKey: .data)
    }
}

public struct OwnIdKey: Codable {
    public let ownId: OwnIDData
}

public struct OwnIDData: Codable {
    public let connections: [Connection]
}

public struct Connection: Codable {
    public let authType: String
}

public enum GigyaShared {
    public static var instance: GigyaCore<OwnIDAccount> {
        Gigya.sharedInstance(OwnIDAccount.self)
    }
}
