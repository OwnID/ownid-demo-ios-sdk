import Foundation
import DemoAppComponents
import SwiftUI
import OwnIDFlowsSDK
import OwnIDCoreSDK
import Combine

final class Register: RegisterProtocol {
    
    private var bag = Set<AnyCancellable>()
    let ownIDViewModel = OwnID.FlowsSDK.RegisterView.ViewModel(registrationPerformer: CustomRegistration(),
                                                               sdkConfigurationName: DemoApp.clientName,
                                                               webLanguages: .init(rawValue: Locale.preferredLanguages))
    
    func createView(usersEmail: Binding<String>) -> OwnID.FlowsSDK.RegisterView {
        OwnID.FlowsSDK.RegisterView(viewModel: ownIDViewModel, usersEmail: usersEmail, visualConfig: .init())
    }
    
    func registerOwnID(email: String, firstName: String) {
        ownIDViewModel.register(with: email, registerParameters: CustomRegistrationParameters(firstName: firstName))
    }
    
    func register(email: String,
                  password: String,
                  firstName: String,
                  completion: @escaping (Result<OperationResult, Error>) -> Void) {
        Self.register(ownIdData: .none, password: password, email: email, name: firstName)
            .sink { completionRegister in
                if case .failure(let error) = completionRegister {
                    completion(.failure(error))
                }
            } receiveValue: { result in
                completion(.success(result))
            }
            .store(in: &bag)
    }
    
    func reset() {
        ownIDViewModel.resetDataAndState()
    }
    
    var eventPublisher: OwnID.FlowsSDK.RegistrationPublisher {
        ownIDViewModel.eventPublisher
    }
    
    static func register(ownIdData: String?,
                         password: String,
                         email: String,
                         name: String) -> AnyPublisher<OperationResult, OwnID.CoreSDK.Error> {
        var payloadDict = ["email": email, "password": password, "name": name]
        if let ownIdData = ownIdData {
            payloadDict["ownIdData"] = ownIdData
        }
        return urlSessionRequest(for: payloadDict)
            .tryMap { response -> Void in
                if !response.data.isEmpty {
                    throw OwnID.CoreSDK.Error.payloadMissing(underlying: String(data: response.data, encoding: .utf8))
                }
            }
            .eraseToAnyPublisher()
            .flatMap { _ -> AnyPublisher<OperationResult, Error> in
                Login.login(ownIdData: ownIdData, password: password, email: email).mapError { $0 as Error }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .mapError { error in
                return OwnID.CoreSDK.Error.flowCancelled
            }
            .eraseToAnyPublisher()
    }
    
    private static func urlSessionRequest(for payloadDict: [String: Any]) -> AnyPublisher<URLSession.DataTaskPublisher.Output, OwnID.CoreSDK.Error> {
        return Just(payloadDict)
            .setFailureType(to: OwnID.CoreSDK.Error.self)
            .eraseToAnyPublisher()
            .tryMap { try JSONSerialization.data(withJSONObject: $0) }
            .mapError { OwnID.CoreSDK.Error.initRequestBodyEncodeFailed(underlying: $0) }
            .map { payloadData -> URLRequest in
                var request = URLRequest(url: URL(string: "https://node-mongo.custom.demo.dev.ownid.com/api/auth/register")!)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                request.httpBody = payloadData
                return request
            }
            .eraseToAnyPublisher()
            .flatMap { request -> AnyPublisher<URLSession.DataTaskPublisher.Output, OwnID.CoreSDK.Error> in
                URLSession.shared.dataTaskPublisher(for: request)
                    .mapError { OwnID.CoreSDK.Error.statusRequestNetworkFailed(underlying: $0) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

final class CustomRegistrationParameters: RegisterParameters {
    internal init(firstName: String) {
        self.firstName = firstName
    }
    
    let firstName: String
}

final class CustomRegistration: RegistrationPerformer {
    func register(configuration: OwnID.FlowsSDK.RegistrationConfiguration, parameters: RegisterParameters) -> AnyPublisher<OperationResult, OwnID.CoreSDK.Error> {
        let ownIdData = configuration.payload.dataContainer
        return Register.register(ownIdData: ownIdData as? String,
                                 password: OwnID.FlowsSDK.Password.generatePassword().passwordString,
                                 email: configuration.email.rawValue,
                                 name: (parameters as? CustomRegistrationParameters)?.firstName ?? "no name in CustomRegistration class")
    }
}


