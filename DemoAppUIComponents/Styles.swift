import SwiftUI
import OwnIDCoreSDK
import OwnIDUISDK

public extension Bundle {
    static let frameworkBundle = Bundle.module
}

public struct DemoStyles: LibraryContentProvider {
    @LibraryContentBuilder
    public func modifiers(base: TextField<Text>) -> [LibraryItem] {
        LibraryItem(base.fieldStyle(),
                    title: "Default Field Style",
                    category: .control)
    }
}

public extension View {
    func fieldStyle(backgroundColor: Color = UISharedColor.grey, foregroundColor: Color = UISharedColor.text) -> some View {
        self
            .disableAutocorrection(true)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(6)
    }
    
    func fullWidthTextWithMultiline() -> some View {
        self
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .center
            )
    }
    
    /// Used especially in the HStack to have multiline with other elements in place
    /// - Returns: View
    func verticalFixedSizeMultiline() -> some View {
        self
            .fixedSize(horizontal: false, vertical: true)
    }
    
    func bottomLine(color: Color) -> some View {
        self
            .overlay(Rectangle().frame(height: 2).offset(y: 10), alignment: .bottom)
            .foregroundColor(color)
    }
    
    func loading() -> some View {
        ZStack(alignment: .center) {
            self
                .disabled(true)
                .blur(radius: 3)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}

public enum UISharedColor {
    public static let background = Color("background", bundle: .frameworkBundle)
    public static let tabsBackground = Color("tabsBackground", bundle: .frameworkBundle)
    public static let grey = Color("grey", bundle: .frameworkBundle)
    public static let loggedInGrey = Color("loggedInGrey", bundle: .frameworkBundle)
    public static let loggedInTextGrey = Color("loggedInTextGrey", bundle: .frameworkBundle)
    public static let text = Color("text", bundle: .frameworkBundle)
    public static let headerBackground = Color("headerBackground", bundle: .frameworkBundle)
    public static let bottomLine = Color("bottomLine", bundle: .frameworkBundle)
}
