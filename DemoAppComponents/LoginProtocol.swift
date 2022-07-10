import Foundation
import OwnIDFlowsSDK
import OwnIDCoreSDK
import SwiftUI

public protocol LoginProtocol: AnyObject {
    func login(email: String, password: String, completion: @escaping (Result<OperationResult, Error>) -> Void)
    func reset()
    func createView(usersEmail: Binding<String>) -> OwnID.FlowsSDK.LoginView
    
    var eventPublisher: OwnID.FlowsSDK.LoginPublisher { get }
}
