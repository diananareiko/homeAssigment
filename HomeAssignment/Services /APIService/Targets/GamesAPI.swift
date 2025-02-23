import Foundation

enum GamesAPI {
    case getGames
}

// MARK: - TargetType

extension GamesAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://growthprodeus2.prod-cdn.clipro.tv/tests/mobile-task")!
    }
    
    var path: String {
        switch self {
        case .getGames:
            return "/games.json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
