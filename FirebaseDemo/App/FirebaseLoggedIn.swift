import Foundation
import OwnIDFirebaseSDK
import Firebase
import DemoAppComponents
import SwiftUI
import OwnIDFlowsSDK

final class FirebaseLoggedIn: LoggedInProtocol {
    
    func logOut() {
        try? Auth.auth().signOut()
    }
    
    func fetchAccount(previousResult: OperationResult, completion: @escaping (Result<LoggedInView.ViewModel.Model, Error>) -> Void) {
        let model = LoggedInView.ViewModel.Model(email: Auth.auth().currentUser!.email!,
                                                 name: Auth.auth().currentUser!.displayName ?? "None set")
        completion(.success(model))
    }
}
