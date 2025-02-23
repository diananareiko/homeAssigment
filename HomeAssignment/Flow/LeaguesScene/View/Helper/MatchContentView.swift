struct MatchContentView: View {
    let match: LeagueMatch

    var body: some View {
        HStack {
            TeamView(team: match.team1)

            Spacer()

            MatchInfoView(time: match.time, score: match.score, isLive: match.isLive)

            Spacer()

            TeamView(team: match.team2)
        }
    }
}