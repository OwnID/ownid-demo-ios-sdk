import SwiftUI
import OwnIDCoreSDK
import DemoAppUIComponents

public struct AppCoordinatorView: View {
    
    public init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: Stored Properties
    @ObservedObject var coordinator: AppCoordinator
    @State private var isDisplayingServerURL = false
    
    // MARK: Views
    
    public var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    HeaderView()
                        .frame(height: 160)
                        .frame(maxWidth: .infinity)
                        .background(UISharedColor.headerBackground)
                    container()
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
        .overlay(alignment: .topTrailing) {
            if coordinator.appConfig.config.isButtonSwitchEnabled {
                Menu {
                    Section(header: Text("Server URL")) {
                        currentServerURLView
                    }
                } label: {
                    imageStack
                }
                .frame(width: 100, height: 70)
                .alert("Current Server URL", isPresented: $isDisplayingServerURL) {
                } message: {
                    Text("\(configurationURL())").multilineTextAlignment(.center)
                }
            }
        }
    }
}

private extension AppCoordinatorView {
    
    @ViewBuilder
    var currentServerURLView: some View {
        Button {
            isDisplayingServerURL = true
        } label: {
            Text("Display Current Server URL")
            Image(systemName: "link.circle.fill")
        }
    }
    
    @ViewBuilder
    var imageStack: some View {
        VStack {
            if coordinator.appConfig.config.isServicePictureEnabled {
                Image(imageNameForConfig(), bundle: .frameworkBundle)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .scaledToFit()
            }
        }
    }
    
    func configurationURL() -> String {
        return OwnID.CoreSDK.shared.serverURL.absoluteString
    }
    
    func imageNameForConfig() -> String {
        if ((Bundle.main.bundleIdentifier?.range(of: "firebase")) != nil) {
            return "firebase"
        }
        if ((Bundle.main.bundleIdentifier?.range(of: "gigya")) != nil) {
            return "sap"
        }
        if ((Bundle.main.bundleIdentifier?.range(of: "custom")) != nil) {
            return "custom"
        }
        return ""
    }
    
    func container() -> some View {
        appContent()
            .padding(EdgeInsets(top: 24, leading: 7, bottom: 24, trailing: 7))
    }
    
    @ViewBuilder
    func appContent() -> some View {
        switch coordinator.state {
        case .loggedIn:
            LoggedInView(viewModel: coordinator.loggedInViewModel!)
                .padding()
            
        case .loggedOut:
            LoggedOutCoordinatorView(coordinator: coordinator.loggedOutCoordinator)
                .padding(.top)
                .padding(.bottom)
                .background(UISharedColor.tabsBackground)
                .cornerRadius(6)
        }
    }
}
