import Foundation
import Combine
import OwnIDCoreSDK
import SwiftUI
import OwnIDFlowsSDK

extension RegisterViewModel {
    enum State {
        case initial
        case loading
    }
}

final class RegisterViewModel: ObservableObject {
    
    // MARK: Stored Properties
    
    @Published private(set) var state = State.initial
    
    @Published var inlineError: String?
    
    // MARK: OwnID
    @Published var isOwnIDEnabled = false
    
    @Published var firstName = ""
    @Published var email = ""
    @Published var password = ""
    
    private var bag = Set<AnyCancellable>()
    let registerObject: RegisterProtocol
    
    private unowned let coordinator: LoggedOutCoordinator
    
    internal init(coordinator: LoggedOutCoordinator,
                  registerObject: RegisterProtocol) {
        self.coordinator = coordinator
        self.registerObject = registerObject
        subscribe(to: registerObject.eventPublisher)
    }
    
    func subscribe(to eventsPublisher: OwnID.RegistrationPublisher) {
        eventsPublisher
            .sink { [unowned self] event in
                switch event {
                case .success(let event):
                    switch event {
                    case let .readyToRegister(usersEmailFromWebApp):
                        if let usersEmailFromWebApp = usersEmailFromWebApp, !usersEmailFromWebApp.isEmpty, email.isEmpty {
                            email = usersEmailFromWebApp
                        }
                        state = .initial
                        inlineError = .none
                        isOwnIDEnabled = true
                        
                    case let .userRegisteredAndLoggedIn(result):
                        redirectToLoggedIn(previousResult: result)
                        
                    case .loading:
                        inlineError = .none
                        state = .loading
                        
                    case .resetTapped:
                        resetOwnID()
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
    
    func resetOwnID() {
        state = .initial
        isOwnIDEnabled = false
    }
    
    func register() {
        state = .loading
        if isOwnIDEnabled {
            registerObject.registerOwnID(email: email, firstName: firstName)
        } else {
            registerEmailPassword()
        }
    }
    
    func resetError() {
        inlineError = .none
    }
}

private extension RegisterViewModel {
    
    func registerEmailPassword() {
        registerObject.register(email: email, password: password, firstName: firstName) { [unowned self] result in
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
        firstName = ""
        email = ""
        password = ""
        isOwnIDEnabled = false
        inlineError = .none
    }
}
