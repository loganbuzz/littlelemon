//
//  Little_Lemon_CapstoneApp.swift
//  Little Lemon Capstone
//
//  Created by Logan Buzzard on 9/18/24.
//

import SwiftUI

@main
struct Little_Lemon_CapstoneApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.bool(forKey: kIsLoggedInKey) {
                Home()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                Onboarding()
            }
        }
    }
}
