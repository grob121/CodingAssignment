import Foundation
import Combine
import CombineMoya
import Moya

struct PopulationAPIManager {
    static var cancelable = Set<AnyCancellable>()
    
    static func fetchData() -> AnyPublisher<[Population], Error> {
        Future<[Population], Error> { promise in
            let populationAPI: PopulationAPI = .population
            let provider = MoyaProvider<PopulationAPI>()
            
            provider.requestPublisher(populationAPI)
                .sink(receiveCompletion: { completion in
                    switch completion {
                        case .finished:
                            print("Receive completion finished")
                        case .failure(let error):
                            promise(.failure(error))
                    }
                }, receiveValue: { response in
                    let result = try? JSONDecoder().decode(PopulationResponse.self, from: response.data)
                    promise(.success(result?.data ?? []))
                })
                .store(in: &cancelable)
            
        }
        .eraseToAnyPublisher()
    }
}
