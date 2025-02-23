import SwiftUI

struct MatchInfoView: View {
    let score: String?
    let isLive: Bool
    
    private enum Constants {
        static let scoreFont = Font.title2.bold()
        static let liveFont = Font.subheadline.bold()
        static let textColor = Color.gray
        static let liveTextColor = Color.red
        static let scoreColor = Color.black
    }

    var body: some View {
        VStack {
            if isLive {
                Text("Started")
                    .font(.subheadline)
                    .foregroundColor(Constants.liveTextColor)
                    .bold()
            }

            Text(score ?? "")
                .font(.title2)
                .bold()
                .foregroundColor(.black)
        }
    }
}
