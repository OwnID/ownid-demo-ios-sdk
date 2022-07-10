import SwiftUI
import OwnIDCoreSDK
import DemoAppUIComponents
import OwnIDUISDK

struct RegisterView: View {
    
    // MARK: Stored Properties
    
    @State private var isSkipPasswordOpened = false
    @ObservedObject var viewModel: RegisterViewModel
    
    // MARK: Views
    
    var body: some View {
        page()
    }
}

private extension RegisterView {
    
    @ViewBuilder
    func page() -> some View {
        switch viewModel.state {
        case .loading:
            content()
                .loading()
            
        case .initial:
            content()
        }
    }
    
    @ViewBuilder
    func content() -> some View {
        VStack {
            fields()
            BlueButton(text: "Create Account", action: viewModel.register)
            terms()
                .padding(.top, 4)
        }
    }
    
    func terms() -> some View {
        VStack(spacing: 0) {
            Text("By creating an account you agree to our")
                .fontWithLineHeight(font: .systemFont(ofSize: 12), lineHeight: 18)
                .foregroundColor(OwnID.Colors.textGrey)
                .verticalFixedSizeMultiline()
                .padding(.bottom, 3)
            HStack {
                Button(action: { UIApplication.shared.open(Constants.termsOfUse) }) {
                    Text("Terms of use")
                        .fontWithLineHeight(font: .systemFont(ofSize: 12), lineHeight: 18)
                        .foregroundColor(OwnID.Colors.blue)
                }
                Text("&")
                    .fontWithLineHeight(font: .systemFont(ofSize: 12), lineHeight: 18)
                    .foregroundColor(OwnID.Colors.textGrey)
                Button(action: { UIApplication.shared.open(Constants.privacy) }) {
                    Text("Privacy")
                        .fontWithLineHeight(font: .systemFont(ofSize: 12), lineHeight: 18)
                        .foregroundColor(OwnID.Colors.blue)
                }
            }
        }
    }
    
    func fields() -> some View {
        Group {
            VStack(alignment: .leading) {
                TextField("First name", text: $viewModel.firstName)
                    .textContentType(.givenName)
                    .keyboardType(.alphabet)
                    .fieldStyle()
                    .padding(.bottom, 9)
                TextField("Email", text: $viewModel.email)
                    .autocapitalization(.none)
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
    func error() -> some View {
        if let error = viewModel.inlineError {
            inlineError(for: error)
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
            .disabled(viewModel.isOwnIDEnabled)
    }
    
    @ViewBuilder
    func skipPasswordView() -> some View {
        viewModel.registerObject.createView(usersEmail: $viewModel.email)
    }
}
