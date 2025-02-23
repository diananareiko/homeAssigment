import SwiftUI

struct MatchRow: View {
    let match: LeagueMatch
    let onTap: (LeagueMatch) -> Void

    private enum Constants {
        static let logoSize: CGFloat = 30
        static let textColor = Color.gray
        static let liveTextColor = Color.red
        static let backgroundColor = Color.white
        static let shadowColor = Color.black.opacity(0.1)
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 3
    }

    var body: some View {
        VStack {
            MatchDateView(date: match.time)
            MatchContentView(match: match)
        }
        .padding()
        .background(Constants.backgroundColor)
        .cornerRadius(Constants.cornerRadius)
        .shadow(color: Constants.shadowColor, radius: Constants.shadowRadius, x: 0, y: 2)
        .listRowSeparator(.hidden)
        .onTapGesture {
            onTap(match)
        }
    }
}
