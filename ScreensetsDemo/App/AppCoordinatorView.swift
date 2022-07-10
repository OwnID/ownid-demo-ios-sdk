import SwiftUI
import OwnIDCoreSDK
import DemoAppUIComponents
import DemoAppComponents

struct AppCoordinatorView: View {
    
    // MARK: Stored Properties
    
    @ObservedObject var coordinator: AppCoordinator
    
    // MARK: Views
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    HeaderView()
                        .frame(height: 160)
                        .frame(maxWidth: .infinity)
                        .background(OwnID.Colors.darkBlue)
                    appContent()
                        .padding(.top)
                        .padding(.top)
                    Spacer()
                    footer()
                        .padding(.bottom)
                        .padding(.bottom)
                }
                .frame(minHeight: proxy.size.height)
            }
        }
        .background(UISharedColor.background)
        .edgesIgnoringSafeArea([.top, .bottom])
    }
}

private extension AppCoordinatorView {
    
    @ViewBuilder
    func appContent() -> some View {
        switch coordinator.state {
        case .loggedIn:
            LoggedInView(viewModel: coordinator.loggedInViewModel!)
                .padding(EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24))
            
        case .loggedOut:
            LogInView(viewModel: coordinator.logInViewModel)
                .padding(EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24))
                .background(Color.white)
                .cornerRadius(6)
                .padding()
        }
    }
}
