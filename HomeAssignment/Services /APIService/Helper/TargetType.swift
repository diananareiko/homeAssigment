import Foundation

protocol TargetType {

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    var headers: [String: String]? { get }
}

extension TargetType {

    func createURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        switch task {
        case .requestPlain:
            break
        case .requestParameters(let parameters, let encoding):
            switch encoding {
            case .json:
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .url:
                guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                    throw APIServiceError.invalidURL
                }
                urlComponents.queryItems = parameters.map { key, value in
                    URLQueryItem(name: key, value: "\(value)")
                }
                request.url = urlComponents.url
            }
        }
        return request
    }
}
