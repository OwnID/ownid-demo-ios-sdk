import OwnIDCoreSDK
import Combine
import SwiftUI
import OwnIDFlowsSDK

public extension LoggedInView.ViewModel {
    struct Model: Decodable {
        public init(email: String, name: String) {
            self.email = email
            self.name = name
        }
        
        let email: String
        let name: String
        
        static func stub() -> Model {
            Model(email: "Sol-ring@gmail.com", name: "Sol")
        }
    }
}

extension LoggedInView.ViewModel {
    enum State {
        case initial(model: Model)
        case loading
    }
}

public extension LoggedInView {
    final class ViewModel: ObservableObject {
        @Published private(set) var state = State.loading
        @Published var errorModel: Alert.ViewModel?
        private var loggedInModel = Model.stub()
        let previousResult: OperationResult
        
        private unowned let coordinator: CoordinatorLoggedOutAction
        private var bag = Set<AnyCancellable>()
        private let loggenInObject: LoggedInProtocol
        
        public init(coordinator: CoordinatorLoggedOutAction,
                    loggenInObject: LoggedInProtocol,
                    previousResult: OperationResult = VoidOperationResult()) {
            self.coordinator = coordinator
            self.loggenInObject = loggenInObject
            self.previousResult = previousResult
            fetchAccount()
        }
        
        func logOut() {
            loggenInObject.logOut()
            reset()
            coordinator.showLoggedOut()
        }
    }
}

private extension LoggedInView.ViewModel {
    func fetchAccount() {
        state = .loading
        loggenInObject.fetchAccount(previousResult: previousResult) { [unowned self] result in
            switch result {
            case .success(let account):
                state = .initial(model: account)
            case .failure(let error):
                state = .initial(model: loggedInModel)
                handleError(error: error)
            }
        }
    }
    
    func handleError(error: Error) {
        state = .initial(model: loggedInModel)
        errorModel = .defaultAlert(message: error.localizedDescription)
    }
    
    func reset() {
        state = .initial(model: loggedInModel)
        errorModel = .none
    }
}

extension Alert {
    struct ViewModel: Identifiable {
        public let title: String
        public let message: String
        public let buttonText: String
        
        public var id: String { title + message + buttonText }
        
        public func makeAlert() -> Alert {
            Alert(title: Text(title), message: Text(message), dismissButton: .default(Text(buttonText)))
        }
        
        public static func defaultAlert(message: String) -> ViewModel {
            ViewModel(title: "", message: message, buttonText: "OK")
        }
    }
}
