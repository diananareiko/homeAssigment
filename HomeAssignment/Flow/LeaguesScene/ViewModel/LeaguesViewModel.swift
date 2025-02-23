import Combine
import Foundation

class LeaguesViewModel: ObservableObject {
    
    private let router: AppRouterProtocol
    private var cancellables = Set<AnyCancellable>()
    @Injected private var apiClient: APIClientProtocol?
    
    @Published var leagues: [LeagueItem] = []
    @Published var selectedLeague: Int?
    
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
    func fetchMatchesAndLeagues() {
        apiClient?.getGames()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching data: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] games in
                guard let self = self else { return }
                
                let groupedLeagues = Dictionary(grouping: games, by: { $0.league.id })
                
                self.leagues = groupedLeagues.map { (leagueID, games) in
                    let firstGame = games.first!
                    return LeagueItem(
                        id: leagueID,
                        name: firstGame.league.name.rawValue,
                        logo: firstGame.league.logo,
                        matches: games.map { leagueMatch in
                            LeagueMatch(
                                id: leagueMatch.wscGameID,
                                team1: leagueMatch.teams.home,
                                team2: leagueMatch.teams.away,
                                score: "\(leagueMatch.wscGame?.finalScoreHome ?? 0) - \(leagueMatch.wscGame?.finalScoreAway ?? 0)",
                                time: leagueMatch.fixture.date,
                                isLive: leagueMatch.fixture.status.short != .ns,
                                primeStory: leagueMatch.wscGame?.primeStory
                            )
                        }
                    )
                }
            })
            .store(in: &cancellables)
    }
    
    
    
    func didSelectMatch(_ match: LeagueMatch) {
        guard let stories = match.primeStory?.pages.map({ page in
            StoryEvent(id: page.paggeID, videoUrl: page.videoURL)
        }) else {
            return
        }
        
        router.navigate(to: .stories(stories: stories))
    }
}
