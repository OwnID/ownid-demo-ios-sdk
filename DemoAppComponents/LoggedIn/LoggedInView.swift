import SwiftUI
import OwnIDCoreSDK
import DemoAppUIComponents

public struct LoggedInView: View {
    
    // MARK: Stored Properties
    
    @ObservedObject var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Views
    
    public var body: some View {
        content()
    }
    
    @ViewBuilder
    func content() -> some View {
        switch viewModel.state {
        case .initial(let model):
            page(model: model)
            
        case .loading:
            EmptyView()
                .loading()
        }
    }

    @ViewBuilder
    func page(model: LoggedInView.ViewModel.Model) -> some View {
        VStack {
            Text("Welcome \(model.name)!")
                .foregroundColor(UISharedColor.text)
                .fontWithLineHeight(font: .systemFont(ofSize: 20, weight: .heavy), lineHeight: 32)
                .padding(.bottom, 20)
            
            VStack(spacing: 0) {
                text(value: "Name")
                field(value: model.name)
                    .padding(.bottom, 2)
                text(value: "Email")
                field(value: model.email)
            }
            .padding(.bottom)
            BlueButton(text: "Log Out ", action: viewModel.logOut)
        }
    }

    @ViewBuilder
    func text(value: String) -> some View {
        Text(value)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(UISharedColor.text)
            .fontWithLineHeight(font: .systemFont(ofSize: 16), lineHeight: 24)
    }
    
    @ViewBuilder
    func field(value: String) -> some View {
        TextField("", text: .constant(value))
            .disabled(true)
            .fieldStyle(backgroundColor: UISharedColor.loggedInGrey,
                        foregroundColor: UISharedColor.loggedInTextGrey)
            .padding(.bottom, 9)
    }
}
