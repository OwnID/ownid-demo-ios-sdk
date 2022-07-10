import SwiftUI
import OwnIDCoreSDK
import DemoAppUIComponents
import OwnIDFlowsSDK

struct LogInView: View {
    
    // MARK: Stored Properties
    
    @State private var isSkipPasswordOpened = false
    @ObservedObject var viewModel: LogInViewModel
    
    // MARK: Views
    
    var body: some View {
        page()
    }
}

private extension LogInView {
    
    @ViewBuilder
    func page() -> some View {
        switch viewModel.state {
        case .loading:
            content()
                .loading()
            
        default:
            content()
        }
    }
    
    @ViewBuilder
    func content() -> some View {
        VStack {
            fields()
            BlueButton(text: "Log in", action: viewModel.logIn)
        }
    }
    
    @ViewBuilder
    func error() -> some View {
        if let error = viewModel.inlineError {
            inlineError(for: error)
        }
    }
    
    @ViewBuilder
    func fields() -> some View {
        Group {
            VStack(alignment: .leading) {
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .fieldStyle()
                    .padding(.bottom, 9)
                passwordField()
                error()
            }
            .padding(.bottom, 9)
        }
    }
    
    @ViewBuilder
    func passwordField() -> some View {
        HStack(spacing: 8) {
            passwordView()
                .fieldStyle()
            skipPasswordView()
                .layoutPriority(1)
        }
    }
    
    @ViewBuilder
    func passwordView() -> some View {
        SecureField("Password", text: $viewModel.password)
            .textContentType(.password)
            .keyboardType(.emailAddress)
    }
    
    @ViewBuilder
    func skipPasswordView() -> some View {
        viewModel.loginObject.createView(usersEmail: $viewModel.email)
    }
}

