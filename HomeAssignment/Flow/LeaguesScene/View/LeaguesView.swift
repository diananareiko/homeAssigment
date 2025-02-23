import SwiftUI
import Kingfisher

struct LeaguesView: View {
    
    @EnvironmentObject var viewModel: LeaguesViewModel
    @State private var expandedLeagues: Set<Int> = []
    
    
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)
            List {
                ForEach(viewModel.leagues) { league in
                    LeagueSection(league: league,
                                  expandedLeagues: $expandedLeagues,
                                  onMatchTap: { match in
                        viewModel.didSelectMatch(match)
                    })
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            }
            .listSectionSpacing(.custom(10))
            .listStyle(PlainListStyle())
            .listRowSeparator(.hidden)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Leagues")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchMatchesAndLeagues()
        }
    }
}
