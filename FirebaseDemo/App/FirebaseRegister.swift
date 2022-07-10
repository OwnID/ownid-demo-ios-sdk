import Foundation
import OwnIDFirebaseSDK
import Firebase
import DemoAppComponents
import SwiftUI
import Combine
import OwnIDFlowsSDK

final class FirebaseRegister: RegisterProtocol {
    
    private var bag = Set<AnyCancellable>()
    let ownIDViewModel = OwnID.FirebaseSDK.registrationViewModel()
    var firstName: String!
    
    func createView(usersEmail: Binding<String>) -> OwnID.FlowsSDK.RegisterView {
        OwnID.FirebaseSDK.createRegisterView(viewModel: ownIDViewModel, email: usersEmail)
    }
    
    func registerOwnID(email: String, firstName: String) {
        self.firstName = firstName
        ownIDViewModel.register(with: email)
    }
    
    func register(email: String,
                  password: String,
                  firstName: String,
                  completion: @escaping (Result<OperationResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] auth, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            auth!.user.getIDToken { [unowned self] token, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                updateName(firstName: firstName)
                    .sink { event in
                        switch event {
                        case let .success(sucessEvent):
                            switch sucessEvent {
                            case .userRegisteredAndLoggedIn:
                                completion(.success(VoidOperationResult()))
                                
                            default:
                                break
                            }
                        case let .failure(error):
                            completion(.failure(error))
                        }
                    }
                    .store(in: &bag)
            }
        }
    }
    
    func reset() {
        ownIDViewModel.resetDataAndState()
    }
    
    func updateName(firstName: String) -> OwnID.FlowsSDK.RegistrationPublisher {
        Future<Result<OwnID.FlowsSDK.RegistrationEvent, OwnID.CoreSDK.Error>, Never> { promise in
            let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
            changeRequest.displayName = firstName
            changeRequest.commitChanges { error in
                if let error = error {
                    promise(.success(.failure(.plugin(error: OwnID.FirebaseSDK.Error.firebaseSDK(error: error)))))
                    return
                }
                promise(.success(.success(.userRegisteredAndLoggedIn(registrationResult: VoidOperationResult()))))
            }
        }
        .eraseToAnyPublisher()
    }
    
    var eventPublisher: OwnID.FlowsSDK.RegistrationPublisher {
        ownIDViewModel.eventPublisher
            .flatMap { [unowned self] event -> OwnID.FlowsSDK.RegistrationPublisher in
                switch event {
                case let .success(sucessEvent):
                    switch sucessEvent {
                    case .userRegisteredAndLoggedIn:
                        return updateName(firstName: firstName).eraseToAnyPublisher()
                        
                    default:
                        return Just(event).eraseToAnyPublisher()
                    }
                default:
                    return Just(event).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
