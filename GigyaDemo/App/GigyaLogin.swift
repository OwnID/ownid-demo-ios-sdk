import Foundation
import OwnIDGigyaSDK
import Gigya
import DemoAppComponents
import SwiftUI
import OwnIDFlowsSDK
import GigyaAndScreensetsShared
import NormalizedGigyaError

final class GigyaLogin: LoginProtocol {
    let ownIDViewModel = OwnID.GigyaSDK.loginViewModel(instance: GigyaShared.instance)
    func createView(usersEmail: Binding<String>) -> OwnID.FlowsSDK.LoginView {
        OwnID.GigyaSDK.createLoginView(viewModel: ownIDViewModel,
                                       usersEmail: usersEmail)
    }
    
    func login(email: String, password: String, completion: @escaping (Result<OperationResult, Error>) -> Void) {
        GigyaShared.instance.login(loginId: email, password: password) { result in
            switch result {
            case .success:
                completion(.success(VoidOperationResult()))

            case .failure(let error):
                completion(.failure(error.error.generalError))
            }
        }
    }
    
    func reset() {
        ownIDViewModel.resetDataAndState()
    }
    
    var eventPublisher: OwnID.FlowsSDK.LoginPublisher {
        ownIDViewModel.eventPublisher
            .map { result in
                switch result {
                case .success(let event):
                    return .success(event)
                case .failure(let coreSDKError):
                    return .failure(coreSDKError.mapGigyaCoreError(OwnIDAccount.self))
                }
            }
            .eraseToAnyPublisher()
    }
}
