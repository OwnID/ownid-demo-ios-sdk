import SwiftUI
import OwnIDCoreSDK
import OwnIDFlowsSDK
import DemoAppUIComponents

struct LoggedOutCoordinatorView: View {
    
    // MARK: Stored Properties
    
    @ObservedObject var coordinator: LoggedOutCoordinator
    
    // MARK: Views
    
    var body: some View {
        navigation(for: coordinator.state)
    }
}

private extension LoggedOutCoordinatorView {
    
    func navigation(for state: LoggedOutCoordinator.State) -> some View {
        VStack {
            HStack(spacing: 0) {
                loginButtonView(state)
                registerButtonView(state)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .padding(.bottom)
            contentView(for: state)
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom)
        }
    }
    
    @ViewBuilder
    func contentView(for state: LoggedOutCoordinator.State) -> some View {
        switch state {
        case .logIn:
            LogInView(viewModel: coordinator.logInViewModel)
            
        case .register:
            RegisterView(viewModel: coordinator.registerViewModel)
        }
    }
    
    @ViewBuilder
    func loginButtonView(_ state: LoggedOutCoordinator.State) -> some View {
        let view = VStack {
            Button(action: { coordinator.showLogIn() }, label: {
                logInText(state)
            })
        }
            .frame(minWidth: 0, maxWidth: .infinity)
        
        switch state {
        case .logIn:
            view
                .bottomLine(color: OwnID.Colors.blue)
            
        case .register:
            view
                .bottomLine(color: UISharedColor.bottomLine)
        }
    }
    
    @ViewBuilder
    func registerButtonView(_ state: LoggedOutCoordinator.State) -> some View {
        let view = VStack {
            Button(action: { coordinator.showRegister() }, label: {
                registerText(state)
            })
        }
            .frame(minWidth: 0, maxWidth: .infinity)
        
        switch state {
        case .logIn:
            view
                .bottomLine(color: UISharedColor.bottomLine)
            
        case .register:
            view
                .bottomLine(color: OwnID.Colors.blue)
        }
    }
    
    @ViewBuilder
    func registerText(_ state: LoggedOutCoordinator.State) -> some View {
        let text = Text("Create Account")
        switch state {
        case .logIn:
            text
                .applyTextStyling(isActive: false)
            
        case .register:
            text
                .applyTextStyling(isActive: true)
        }
    }
    
    @ViewBuilder
    func logInText(_ state: LoggedOutCoordinator.State) -> some View {
        let text = Text("Log in")
        switch state {
        case .logIn:
            text
                .applyTextStyling(isActive: true)
            
        case .register:
            text
                .applyTextStyling(isActive: false)
        }
    }
}

extension Text {
    func applyTextStyling(isActive: Bool) -> some View {
        self
        .foregroundColor(isActive ? OwnID.Colors.blue : OwnID.Colors.textGrey)
        .fontWithLineHeight(font: .systemFont(ofSize: 14, weight: .bold), lineHeight: 16)
    }
}
