import Combine

class LeaguesViewModel: ObservableObject {

    private let router: AppRouterProtocol
    @Injected private var apiClient: APIClientProtocol?
    
    init(router: AppRouterProtocol) {
        self.router = router
    }
    
    func didSelectLeague(_ league: String) {
        router.navigate(to: .stories(league: league))
    }
}
