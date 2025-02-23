import Combine
import Foundation

protocol APIServiceProtocol {
    func request<T: Decodable>(target: TargetType) -> AnyPublisher<T, APIServiceError>
}

class APIService: APIServiceProtocol {
    
    // MARK: - APIServiceProtocol
    
    func request<T: Decodable>(target: TargetType) -> AnyPublisher<T, APIServiceError> {
        guard let request = try? target.createURLRequest() else {
            return Fail(error: APIServiceError.requestCreationError).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIServiceError.responseError
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> APIServiceError in
                if let decodingError = error as? DecodingError {
                    return APIServiceError.decodingError
                }
                return APIServiceError.responseError
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
