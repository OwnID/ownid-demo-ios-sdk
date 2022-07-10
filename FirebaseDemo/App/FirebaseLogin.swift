import Foundation
import OwnIDFirebaseSDK
import Firebase
import DemoAppComponents
import SwiftUI
import OwnIDFlowsSDK

final class FirebaseLogin: LoginProtocol {
    let ownIDViewModel = OwnID.FirebaseSDK.loginViewModel()
    
    func createView(usersEmail: Binding<String>) -> OwnID.FlowsSDK.LoginView {
        OwnID.FirebaseSDK.createLoginView(viewModel: ownIDViewModel, usersEmail: usersEmail)
    }
    
    func login(email: String, password: String, completion: @escaping (Result<OperationResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(VoidOperationResult()))
        }
    }
    
    func reset() {
        ownIDViewModel.resetDataAndState()
    }
    
    var eventPublisher: OwnID.FlowsSDK.LoginPublisher {
        ownIDViewModel.eventPublisher
    }
}
