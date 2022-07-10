import Foundation
import DemoAppComponents
import OwnIDFlowsSDK
import SwiftUI
import Combine
import OwnIDCoreSDK

final class LoggedIn: LoggedInProtocol {
    private var bag = Set<AnyCancellable>()
    func logOut() {
        print("logOut action in LoggedIn")
    }
    
    func fetchAccount(previousResult: OperationResult, completion: @escaping (Result<LoggedInView.ViewModel.Model, Error>) -> Void) {
        Self.fetchUserData(previousResult: previousResult)
            .sink { completionRegister in
                if case .failure(let error) = completionRegister {
                    completion(.failure(error))
                }
            } receiveValue: { model in
                completion(.success(model))
            }
            .store(in: &bag)

    }
    
    static func fetchUserData(previousResult: OperationResult) -> AnyPublisher<LoggedInView.ViewModel.Model, OwnID.CoreSDK.Error> {
        return Just(previousResult)
            .setFailureType(to: OwnID.CoreSDK.Error.self)
            .eraseToAnyPublisher()
            .map { previousResult -> URLRequest in
                var request = URLRequest(url: URL(string: "https://node-mongo.custom.demo.dev.ownid.com/api/auth/profile")!)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(previousResult)", forHTTPHeaderField: "Authorization")
                request.httpMethod = "GET"
                return request
            }
            .flatMap {
                URLSession.shared.dataTaskPublisher(for: $0)
                    .mapError { OwnID.CoreSDK.Error.statusRequestNetworkFailed(underlying: $0) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            .map { $0.data }
            .decode(type: LoggedInView.ViewModel.Model.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .mapError { OwnID.CoreSDK.Error.plugin(error: CustomIntegrationDemoError.profileRequestFailed(underlying: $0)) }
            .eraseToAnyPublisher()
    }
}
