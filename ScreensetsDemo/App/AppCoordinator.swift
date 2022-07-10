import SwiftUI
import DemoAppComponents
import OwnIDFlowsSDK
import GigyaAndScreensetsShared

extension AppCoordinator {
    enum State {
        case loggedIn
        case loggedOut
    }
}

final class AppCoordinator: ObservableObject, CoordinatorLoggedOutAction {
    @Published private(set) var state = State.loggedOut
    @Published var logInViewModel: LogInViewModel!
    @Published var loggedInViewModel: LoggedInView.ViewModel?
    
    init() {
        logInViewModel = LogInViewModel(coordinator: self)
    }
    
    func showLoggedIn() {
        loggedInViewModel = LoggedInView.ViewModel(coordinator: self,
                                                   loggenInObject: GigyaLoggedIn(),
                                                   previousResult: VoidOperationResult())
        state = .loggedIn
    }
    
    func showLoggedOut() {
        state = .loggedOut
        loggedInViewModel = .none
    }
}
