import SwiftUI
import Combine
import OwnIDCoreSDK
import OwnIDFlowsSDK

extension LoggedOutCoordinator {
    enum State {
        case logIn
        case register
    }
}

final class LoggedOutCoordinator: ObservableObject {
    @Published var registerViewModel: RegisterViewModel!
    @Published var logInViewModel: LogInViewModel!
    @Published private(set) var state = State.logIn
    
    private var bag = Set<AnyCancellable>()
    private unowned let parent: AppCoordinator
    
    internal init(parent: AppCoordinator,
                  loginObject: LoginProtocol,
                  registerObject: RegisterProtocol) {
        self.parent = parent
        registerViewModel = RegisterViewModel(coordinator: self, registerObject: registerObject)
        logInViewModel = LogInViewModel(coordinator: self, loginObject: loginObject)
    }
    
    func showLoggedIn(previousResult: OperationResult) {
        parent.showLoggedIn(previousResult: previousResult)
    }
    
    func showLogIn() {
        resetErrors()
        state = .logIn
    }
    
    func showRegister() {
        resetErrors()
        state = .register
    }
    
    func resetErrors() {
        logInViewModel.resetError()
        registerViewModel.resetError()
    }
}
