import Foundation
import OwnIDCoreSDK
import SwiftUI
import OwnIDFlowsSDK

public protocol LoggedInProtocol: AnyObject {
    func logOut()
    func fetchAccount(previousResult: OperationResult, completion: @escaping (Result<LoggedInView.ViewModel.Model, Error>) -> Void)
}
