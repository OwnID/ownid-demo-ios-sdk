import Foundation
import OwnIDCoreSDK
import OwnIDGigyaSDK
import Gigya
import DemoAppComponents
import SwiftUI
import OwnIDFlowsSDK
@_exported import OwnIDAccount

public final class GigyaLoggedIn: LoggedInProtocol {
    public init() { }
    public func logOut() {
        GigyaShared.instance.logout()
    }
    
    public func fetchAccount(previousResult: OperationResult, completion: @escaping (Result<LoggedInView.ViewModel.Model, Error>) -> Void) {
        GigyaShared.instance.getAccount(true) { result in
            switch result {
            case .success(data: let account):
                completion(.success(account.model))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

public extension OwnIDAccount {
    var model: LoggedInView.ViewModel.Model {
        LoggedInView.ViewModel.Model(email: profile?.email ?? "", name: profile?.firstName ?? "")
    }
}
