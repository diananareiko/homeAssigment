import SwiftUI

struct LeagueSection: View {
    
    let league: LeagueItem
    @Binding var expandedLeagues: Set<Int>
    let onMatchTap: (LeagueMatch) -> Void

    private enum Constants {
        static let spacing: CGFloat = 5
        static let sectionBackground = Color.clear
    }

    var body: some View {
        Section {
            if expandedLeagues.contains(league.id) {
                VStack(spacing: Constants.spacing) {
                    ForEach(league.matches) { match in
                        MatchRow(match: match, onTap: onMatchTap)
                    }
                }
            }
        } header: {
            LeagueHeader(league: league, expandedLeagues: $expandedLeagues)
        }
        .listRowInsets(.none)
    }
}
