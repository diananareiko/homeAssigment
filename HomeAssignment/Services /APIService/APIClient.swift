import Combine

protocol APIClientProtocol {

    func getGames() -> AnyPublisher<[Response], APIServiceError>
}

class APIClient: APIClientProtocol {
    
    private var apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    // MARK: - APIClientProtocol
    
    func getGames() -> AnyPublisher<[Response], APIServiceError> {
        let target = GamesAPI.getGames
        return apiService.request(target: target)
            .tryMap { (response: Welcome) in
                return response.response
                    .filter { $0.wscGame?.primeStory != nil }
                    .map { game in
                        var updatedGame = game
                        if var wscGame = game.wscGame, let lastPage = wscGame.primeStory?.pages.last {
                            wscGame.finalScoreHome = lastPage.homeScore
                            wscGame.finalScoreAway = lastPage.awayScore
                            updatedGame.wscGame = wscGame
                        }
                        return updatedGame
                    }
            }
            .mapError { error in
                if let apiError = error as? APIServiceError {
                    return apiError
                } else {
                    return APIServiceError.responseError
                }
            }
            .eraseToAnyPublisher()
    }
}
