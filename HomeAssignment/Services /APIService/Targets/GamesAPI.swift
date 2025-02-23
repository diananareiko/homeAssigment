import Foundation

enum RickAndMortyAPI {

    case getCharacter(id: Int)
    case getAllCharacters(page: Int?)
    case getLocation(id: Int)
}

// MARK: - TargetType

extension RickAndMortyAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://rickandmortyapi.com/api")!
    }
    
    var path: String {
        switch self {
        case .getCharacter(let id):
            return "/character/\(id)"
        case .getAllCharacters:
            return "/character"
        case .getLocation(let id):
            return "/location/\(id)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getCharacter,
             .getLocation:
            return .requestPlain
        case .getAllCharacters(let page):
            if let page = page {
                return .requestParameters(parameters: ["page": page], encoding: .url)
            } else {
                return .requestPlain
            }
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
