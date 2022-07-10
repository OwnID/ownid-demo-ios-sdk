
import Foundation
import SwiftUI

public struct HeaderView: View {
    public init() { }
    
    public var body: some View {
        VStack {
            Spacer()
            Image("ownidLogo", bundle: .frameworkBundle)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.white)
                .scaledToFit()
                .frame(width: 168, height: 56)
                .padding(EdgeInsets(top: 80, leading: 20, bottom: 24, trailing: 10))
            Spacer()
        }
    }
}
