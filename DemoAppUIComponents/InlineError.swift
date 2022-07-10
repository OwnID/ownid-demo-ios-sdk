import Foundation
import SwiftUI
import OwnIDUISDK

@ViewBuilder
public func inlineError(for error: String) -> some View {
    Text(error)
        .foregroundColor(.red)
        .fontWithLineHeight(font: .systemFont(ofSize: 11), lineHeight: 18)
        .verticalFixedSizeMultiline()
}
