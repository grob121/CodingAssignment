import Foundation
import Moya

enum PopulationAPI {
    case population
}

extension PopulationAPI: Moya.TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        switch self{
            case .population:
                return URL(string: "https://datausa.io")!
        }
    }
    
    var path: String {
        switch self {
            case .population:
                return "/api/data"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .population:
                return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
            case .population:
                return .requestParameters(
                    parameters: ["drilldowns": "Nation",
                                 "measures": "Population"],
                    encoding: URLEncoding.queryString)
        }
    }
}
