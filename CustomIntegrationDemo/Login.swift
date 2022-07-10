import Foundation
import DemoAppComponents
import SwiftUI
import OwnIDFlowsSDK
import OwnIDCoreSDK
import OwnIDUISDK
import Combine

enum CustomIntegrationDemoError: PluginError {
    case loginRequestFailed(underlying: Error)
    case profileRequestFailed(underlying: Error)
    case noTokenFound
}

extension String: OperationResult { }

final class Login: LoginProtocol {
    private var bag = Set<AnyCancellable>()
    let ownIDViewModel = OwnID.FlowsSDK.LoginView.ViewModel(loginPerformer: CustomLoginPerformer(),
                                                            sdkConfigurationName: DemoApp.clientName,
                                                            webLanguages: .init(rawValue: Locale.preferredLanguages))
    
    func createView(usersEmail: Binding<String>) -> OwnID.FlowsSDK.LoginView {
        OwnID.FlowsSDK.LoginView(viewModel: ownIDViewModel,
                                 usersEmail: usersEmail,
                                 visualConfig: .init())
    }
    
    func login(email: String, password: String, completion: @escaping (Result<OperationResult, Error>) -> Void) {
        Self.login(ownIdData: .none, password: password, email: email)
            .sink { completionRegister in
                if case .failure(let error) = completionRegister {
                    completion(.failure(error))
                }
            } receiveValue: { token in
                completion(.success(token))
            }
            .store(in: &bag)
    }
    
    func reset() {
        ownIDViewModel.resetDataAndState()
    }
    
    var eventPublisher: OwnID.FlowsSDK.LoginPublisher {
        ownIDViewModel.eventPublisher
    }
    
    static func login(ownIdData: Any?,
                      password: String? = .none,
                      email: String) -> AnyPublisher<OperationResult, OwnID.CoreSDK.Error> {
        if let ownIdData = ownIdData as? [String: String], let token = ownIdData["token"] {
            return Just(token)
                .setFailureType(to: OwnID.CoreSDK.Error.self)
                .eraseToAnyPublisher()
        }
        let payloadDict = ["email": email, "password": password]
        return Just(payloadDict)
            .setFailureType(to: OwnID.CoreSDK.Error.self)
            .eraseToAnyPublisher()
            .tryMap { try JSONSerialization.data(withJSONObject: $0) }
            .map { payloadData -> URLRequest in
                var request = URLRequest(url: URL(string: "https://node-mongo.custom.demo.dev.ownid.com/api/auth/login")!)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                request.httpBody = payloadData
                return request
            }
            .flatMap {
                URLSession.shared.dataTaskPublisher(for: $0)
                    .mapError { OwnID.CoreSDK.Error.statusRequestNetworkFailed(underlying: $0) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            .map { $0.data }
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .map { $0.token }
            .receive(on: DispatchQueue.main)
            .mapError { OwnID.CoreSDK.Error.plugin(error: CustomIntegrationDemoError.loginRequestFailed(underlying: $0)) }
            .eraseToAnyPublisher()
    }
}

struct LoginResponse: Decodable {
    let token: String
}

final class CustomLoginPerformer: LoginPerformer {
    func login(payload: OwnID.CoreSDK.Payload,
               email: String) -> AnyPublisher<OperationResult, OwnID.CoreSDK.Error> {
        Login.login(ownIdData: payload.dataContainer, email: email)
    }
}
