//
//  DishDetail.swift
//  Little Lemon Capstone
//
//  Created by Logan Buzzard on 9/19/24.
//

import SwiftUI
import CoreData

struct DishDetail: View {
    let dish: Dish

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(dish.title ?? "Unknown Title")
                .font(.largeTitle)
                .padding(.top, 20)

            if let imageUrl = dish.image,
               let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
            }

            Text("Price: $\(dish.price ?? "0.00")")
                .font(.title2)

            Text(dish.desc ?? "No description available.")
                .font(.body)

            Spacer()
        }
        .padding()
        .navigationTitle(dish.title ?? "Dish Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DishDetail_Previews: PreviewProvider {
    static var previews: some View {
        // Load the managed object model from the app bundle
        guard let modelURL = Bundle.main.url(forResource: "ExampleDatabase", withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load managed object model")
        }

        // Set up the persistent store coordinator with the model
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(
                ofType: NSInMemoryStoreType,
                configurationName: nil,
                at: nil,
                options: nil
            )
        } catch {
            fatalError("Failed to set up in-memory persistent store: \(error)")
        }

        // Create the managed object context
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator

        // Create a sample Dish instance
        let sampleDish = Dish(context: context)
        sampleDish.title = "Sample Dish"
        sampleDish.price = "9.99"
        sampleDish.desc = "A delicious sample dish."
        sampleDish.image = "https://via.placeholder.com/150"

        // Return the DishDetail view with the sample Dish
        return DishDetail(dish: sampleDish)
    }
}
