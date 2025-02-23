import Kingfisher
import SwiftUI

struct Logo: View {
    let url: String
    
    private enum Constants {

        static let size: CGFloat = 30
        static let cornerRadius: CGFloat = 5
        static let placeholderColor = Color.gray.opacity(0.3)
    }
    
    var body: some View {
        KFImage(URL(string: url))
            .resizable()
            .placeholder {
                placeholderView
            }
            .scaledToFit()
            .frame(width: Constants.size, height: Constants.size)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
    
    private var placeholderView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Constants.placeholderColor)
                .frame(width: Constants.size, height: Constants.size)
            ProgressView()
        }
    }
}
