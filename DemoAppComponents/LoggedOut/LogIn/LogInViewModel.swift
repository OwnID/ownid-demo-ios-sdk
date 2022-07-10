import SwiftUI
import OwnIDCoreSDK
import Combine
import OwnIDFlowsSDK

extension LogInViewModel {
    enum State {
        case initial
        case loading
    }
}

final class LogInViewModel: ObservableObject {
    
    // MARK: Stored Properties
    
    @Published private(set) var state = State.initial
    
    private unowned let coordinator: LoggedOutCoordinator
    
    @Published var email = ""
    @Published var password = ""
    
    @Published var inlineError: String?
    
    private var bag = Set<AnyCancellable>()
    var loginObject: LoginProtocol
    
    internal init(coordinator: LoggedOutCoordinator,
                  loginObject: LoginProtocol) {
        self.coordinator = coordinator
        self.loginObject = loginObject
        subscribe(to: loginObject.eventPublisher)
    }
    
    func subscribe(to eventsPublisher: OwnID.LoginPublisher) {
        eventsPublisher
            .sink { [unowned self] event in
                switch event {
                case .success(let mode):
                    switch mode {
                    case let .loggedIn(logInResult):
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.redirectToLoggedIn(previousResult: logInResult)
                        }
                        
                    case .loading:
                        inlineError = .none
                        state = .loading
                    }
                case .failure(let error):
                    switch error {
                    case .flowCancelled:
                        state = .initial
                        break
                        
                    default:
                        handleError(error: error)
                    }
                }
            }
            .store(in: &bag)
    }
    
    func logIn() {
        loginEmailPassowrd()
    }
    
    func resetError() {
        inlineError = .none
    }
}

private extension LogInViewModel {
    func loginEmailPassowrd() {
        state = .loading
        loginObject.login(email: email, password: password) { [unowned self] result in
            switch result {
            case let .success(previousResult):
                redirectToLoggedIn(previousResult: previousResult)
                
            case .failure(let error):
                handleError(error: error)
            }
        }
    }
    
    func redirectToLoggedIn(previousResult: OperationResult) {
        reset()
        coordinator.showLoggedIn(previousResult: previousResult)
    }
    
    func handleError(error: Error) {
        state = .initial
        inlineError = error.localizedDescription
    }
    
    func reset() {
        state = .initial
        email = ""
        password = ""
        inlineError = .none
    }
}
