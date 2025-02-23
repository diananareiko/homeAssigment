import Combine

protocol APIClientProtocol {
    
    func getCharacter(id: Int) -> AnyPublisher<Character, APIServiceError>
    func getCharacters(page: Int?) -> AnyPublisher<[Character], APIServiceError>
    func getLocation(id: Int) -> AnyPublisher<Location, APIServiceError>
    
}

class APIClient: APIClientProtocol {

    private var apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    // MARK: - APIClientProtocol
    
    func getCharacter(id: Int) -> AnyPublisher<Character, APIServiceError> {
        let target = RickAndMortyAPI.getCharacter(id: id)
        return apiService.request(target: target)
    }
    
    func getCharacters(page: Int?) -> AnyPublisher<[Character], APIServiceError> {
        let target = RickAndMortyAPI.getAllCharacters(page: page)
        return apiService.request(target: target)
                .tryMap { (response: CharactersResponse) in
                    return response.results
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
    
    func getLocation(id: Int) -> AnyPublisher<Location, APIServiceError> {
        let target = RickAndMortyAPI.getLocation(id: id)
        return apiService.request(target: target)
    }
}
