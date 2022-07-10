import SwiftUI
import Combine
import Gigya
import GigyaAndScreensetsShared

extension LogInViewModel {
    enum State {
        case initial
        case loading
    }
    
    enum ScreensetError: LocalizedError {
        case failed
    }
}

final class LogInViewModel: ObservableObject {
    
    // MARK: Stored Properties
    
    private(set) var screensetResult = PassthroughSubject<GigyaPluginEvent<OwnIDAccount>, Never>()
    
    @Published private(set) var state = State.initial
    
    private unowned let coordinator: AppCoordinator
    
    @Published var email = ""
    @Published var password = ""
    
    @Published var inlineError: String?
    
    private var bag = Set<AnyCancellable>()
    
    internal init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        screensetResult
            .sink { [unowned self] result in
                state = .initial
                
                switch result {
                case .onLogin:
                    redirectToLoggedIn()
                case .error:
                    handleError(error: ScreensetError.failed)
                    
                default:
                    print(result)
                }
                
            }
            .store(in: &bag)
    }
    
    func logIn() {
        state = .loading
    }
}

private extension LogInViewModel {
    
    func redirectToLoggedIn() {
        reset()
        coordinator.showLoggedIn()
    }
    
    func handleError(error: Error) {
        state = .initial
        inlineError = error.localizedDescription
    }
    
    func reset() {
        state = .initial
        inlineError = .none
        email = ""
        password = ""
    }
}
