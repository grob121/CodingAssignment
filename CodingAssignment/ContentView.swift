import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var populationViewModel = PopulationViewModel(persistentContainer: CoreDataStack.shared.persistentContainer)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(populationViewModel.data, id: \.yearId) { data in
                    NavigationLink {
                        Text("\(data.nation) - \(data.population)")
                    } label: {
                        Text("\(data.year) - \(data.population)")
                    }
                }
            }
            .onAppear {
                populationViewModel.fetchPopulationData()
            }
            .alert("Error",
                   isPresented: $populationViewModel.isPresented,
                   actions: { },
                   message: { Text(populationViewModel.errorMessage) })
        }
        .overlay {
            if populationViewModel.isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
