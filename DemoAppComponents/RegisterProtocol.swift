import Foundation
import OwnIDFlowsSDK
import OwnIDCoreSDK
import SwiftUI

public protocol RegisterProtocol: AnyObject {
    func reset()
    func createView(usersEmail: Binding<String>) -> OwnID.FlowsSDK.RegisterView
    func registerOwnID(email: String, firstName: String)
    func register(email: String,
                  password: String,
                  firstName: String,
                  completion: @escaping (Result<OperationResult, Error>) -> Void)
    
    var eventPublisher: OwnID.FlowsSDK.RegistrationPublisher { get }
}
