//
//  CodingAssignmentApp.swift
//  CodingAssignment
//
//  Created by Collabera on 5/16/25.
//

import SwiftUI

@main
struct CodingAssignmentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
