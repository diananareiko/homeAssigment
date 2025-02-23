import SwiftUI

struct MatchContentView: View {
    let match: LeagueMatch

    private enum Constants {
    
        static let spacing: CGFloat = 12
    }

    var body: some View {
        HStack(spacing: Constants.spacing) {
            TeamView(team: match.team1)
                .frame(maxWidth: .infinity)
            
            MatchInfoView(score: match.score, isLive: match.isLive)
                .frame(maxWidth: .infinity)
            
            TeamView(team: match.team2)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}


