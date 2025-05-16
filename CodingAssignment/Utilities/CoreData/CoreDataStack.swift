import Foundation
import CoreData

public class CoreDataStack {
    public static let shared = CoreDataStack()
    
    public let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "PopulationModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error)")
            }
        }
    }
    
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
