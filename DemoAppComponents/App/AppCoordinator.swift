import SwiftUI
import OwnIDCoreSDK
import OwnIDFlowsSDK

extension AppCoordinator {
    enum State {
        case loggedIn
        case loggedOut
    }
}

public protocol CoordinatorLoggedOutAction: AnyObject {
    func showLoggedOut()
}

public final class AppCoordinator: ObservableObject, CoordinatorLoggedOutAction {
    @Published private(set) var state = State.loggedOut
    @Published var loggedOutCoordinator: LoggedOutCoordinator!
    @Published var loggedInViewModel: LoggedInView.ViewModel?
    
    let appConfig = AppConfiguration<FeatureFlagsConfig>()
    
    private let loggenInObject: LoggedInProtocol
    
    public init(loginObject: LoginProtocol,
                registerObject: RegisterProtocol,
                loggenInObject: LoggedInProtocol) {
        self.loggenInObject = loggenInObject
        loggedOutCoordinator = LoggedOutCoordinator(parent: self,
                                                    loginObject: loginObject,
                                                    registerObject: registerObject)
    }
    
    func showLoggedIn(previousResult: OperationResult) {
        loggedInViewModel = LoggedInView.ViewModel(coordinator: self, loggenInObject: loggenInObject, previousResult: previousResult)
        state = .loggedIn
    }
    
    public func showLoggedOut() {
        state = .loggedOut
        loggedInViewModel = .none
    }
}
