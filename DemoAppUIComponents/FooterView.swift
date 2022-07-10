import SwiftUI

public extension View {
    func footer() -> some View {
        HStack {
            Spacer()
            Text("This app is only for demoing purposes to showcase how the OwnID widget functions.\n\(build)")
                .foregroundColor(UISharedColor.text)
                .multilineTextAlignment(.center)
                .font(.system(size: 12))
                .lineSpacing(8)
                .padding()
            Spacer()
        }
    }
    
    private var build: String {
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let buildString = "v. \(appVersion ?? "").\(build ?? "")"
        return buildString
    }
}
