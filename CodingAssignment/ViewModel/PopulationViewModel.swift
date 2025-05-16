import Foundation
import Combine
import CoreData

class PopulationViewModel: ObservableObject{
    var cancellable = Set<AnyCancellable>()
    
    @Published var data: [Population] = []
    @Published var isPresented: Bool = false
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    
    private let persistentContainer: NSPersistentContainer
    
    public init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func fetchPopulationData() {
        let populationList = fetchPopulationListFromCoreData()
        
        if !populationList.isEmpty {
            isLoading = false
            
            data = populationList
        } else {
            PopulationAPIManager.fetchData()
                .sink(receiveCompletion: { [weak self] result in
                    guard let self = self else { return }
                    
                    isLoading = false
                    
                    switch result {
                        case .finished:
                            self.isPresented = false
                            self.errorMessage = ""
                        case .failure(let error):
                            self.isPresented = true
                            self.errorMessage = error.localizedDescription
                    }
                }, receiveValue: { [weak self] values in
                    guard let self = self else { return }
                    
                    isLoading = false
                    
                    for value in values {
                        self.data.append(value)
                    }
                    
                    self.savePopulationListToCoreData(populationList: values)
                })
                .store(in: &cancellable)
        }
    }
    
    private func savePopulationListToCoreData(populationList: [Population]) {
        let context = persistentContainer.viewContext
        
        for population in populationList {
            let populationEntity = PopulationEntity(context: context)
            populationEntity.yearId = Int64(population.yearId)
            populationEntity.idNation = population.idNation
            populationEntity.nation = population.nation
            populationEntity.year = population.year
            populationEntity.population = Int64(population.population)
            populationEntity.slugNation = population.slugNation
        }
        
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func fetchPopulationListFromCoreData() -> [Population] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PopulationEntity> = PopulationEntity.fetchRequest()
        
        do {
            let populationEntities = try context.fetch(fetchRequest)
            
            var populationList: [Population] = populationEntities.map {
                return Population(yearId: Int($0.yearId),
                                  idNation: $0.idNation ?? "",
                                  nation: $0.nation ?? "",
                                  year: $0.year ?? "",
                                  population: Int($0.population),
                                  slugNation: $0.slugNation ?? "")
            }
            
            populationList.sort { $0.yearId > $1.yearId }
            
            return populationList
        } catch {
            return []
        }
    }
}
