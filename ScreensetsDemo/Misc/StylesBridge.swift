import DemoAppUIComponents
import SwiftUI
import OwnIDCoreSDK

extension BlueButton {
    init(text: String, action: @escaping () -> Void, coloring: Color = OwnID.Colors.blue) {
        self.init(text: text, action: action, color: coloring)
    }
}
