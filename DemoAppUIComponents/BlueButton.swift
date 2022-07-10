
import Foundation
import SwiftUI

public struct BlueButton: View {
    public init(text: String, action: @escaping () -> Void, color: Color) {
        self.text = text
        self.action = action
        self.color = color
    }
    
    public let text: String
    public let color: Color
    public let action: () -> Void
    
    public var body: some View {
        HStack {
            Button(action: { action() }, label: {
                Text(text)
                    .font(.system(size: 16, weight: .bold))
                    .fullWidthTextWithMultiline()
            })
        }
        .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(6)
    }
}
