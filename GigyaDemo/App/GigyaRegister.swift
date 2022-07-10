import Foundation
import OwnIDGigyaSDK
import Gigya
import DemoAppComponents
import SwiftUI
import OwnIDFlowsSDK
import GigyaAndScreensetsShared
import NormalizedGigyaError

final class GigyaRegister: RegisterProtocol {
    
    let ownIDViewModel = OwnID.GigyaSDK.registrationViewModel(instance: GigyaShared.instance)
    
    func params(firstName: String) -> OwnID.GigyaSDK.Registration.Parameters {
        let nameValue = "{ \"firstName\": \"\(firstName)\" }"
        let paramsDict = ["profile": nameValue]
        let params = OwnID.GigyaSDK.Registration.Parameters(parameters: paramsDict)
        return params
    }
    
    func createView(usersEmail: Binding<String>) -> OwnID.FlowsSDK.RegisterView {
        OwnID.GigyaSDK.createRegisterView(viewModel: ownIDViewModel, email: usersEmail)
    }
    
    func registerOwnID(email: String, firstName: String) {
        ownIDViewModel.register(with: email, registerParameters: params(firstName: firstName))
    }
    
    func register(email: String,
                  password: String,
                  firstName: String,
                  completion: @escaping (Result<OperationResult, Error>) -> Void) {
        GigyaShared.instance.register(email: email, password: password, params: params(firstName: firstName).parameters)
        { result in
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
    
    var eventPublisher: OwnID.FlowsSDK.RegistrationPublisher {
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
