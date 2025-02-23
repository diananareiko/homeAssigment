struct LeagueSection: View {
    let league: LeagueItem
    @Binding var expandedLeague: Int?
    
    var body: some View {
        Section {
            if expandedLeague == league.id {
                ForEach(league.matches) { match in
                    MatchRow(match: match)
                        .padding(.vertical, 5)
                        .listRowSeparator(.hidden) // ✅ Убираем разделитель
                        .background(Color(.systemGray6)) // ✅ Серый фон
                }
            }
        } header: {
            LeagueHeader(league: league, expandedLeague: $expandedLeague)
        }
        .listRowInsets(.none) // ✅ Убираем лишние отступы
        .background(Color.clear)
    }
}