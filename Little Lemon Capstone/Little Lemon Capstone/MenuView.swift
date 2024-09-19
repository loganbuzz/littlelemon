//
//  MenuView.swift
//  Little Lemon Capstone
//
//  Created by Logan Buzzard on 9/19/24.
//

import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    @State private var dataLoaded = false // Tracks if data has been loaded

    // Function to build sort descriptors
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
    }

    // Function to build predicate based on search text
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true) // Fetch all dishes if search text is empty
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Header Information
                Text("Little Lemon")
                    .font(.largeTitle)
                    .padding(.bottom, 5)

                Text("Chicago")
                    .font(.title2)
                    .padding(.bottom, 5)

                Text("We are a family-owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                    .padding(.bottom, 20)

                // Search Field
                TextField("Search menu", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)

                // Fetch and display dishes from Core Data
                FetchedObjects(
                    predicate: buildPredicate(),
                    sortDescriptors: buildSortDescriptors()
                ) { (dishes: [Dish]) in
                    if !dataLoaded {
                        // Center the ProgressView vertically
                        VStack {
                            Spacer()
                            ProgressView("Loading menu...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(1.5)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            getMenuData()
                            dataLoaded = true
                        }
                    } else if dishes.isEmpty {
                        // Center the EmptyStateView vertically
                        VStack {
                            Spacer()
                            EmptyStateView(
                                message: "No dishes found matching your search.",
                                resetAction: {
                                    withAnimation {
                                        searchText = ""
                                    }
                                }
                            )
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Display the list of dishes
                        List {
                            ForEach(dishes, id: \.self) { dish in
                                NavigationLink(destination: DishDetail(dish: dish)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(dish.title ?? "Unknown Dish")
                                                .font(.headline)
                                            Text("$\(dish.price ?? "0.00")")
                                                .font(.subheadline)
                                        }

                                        Spacer()

                                        if let imageUrl = dish.image,
                                           let url = URL(string: imageUrl) {
                                            AsyncImage(url: url) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 80, height: 80)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .padding()
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Function to fetch menu data from the API
    func getMenuData() {
        let serverURL = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"

        guard let url = URL(string: serverURL) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                let menuList = try decoder.decode(MenuList.self, from: data)

                // Save to Core Data on the main thread
                DispatchQueue.main.async {
                    // Clear existing data
                    PersistenceController.shared.clear()

                    // Save new data
                    for item in menuList.menu {
                        let dish = Dish(context: viewContext)
                        dish.id = Int16(item.id)
                        dish.title = item.title
                        dish.image = item.image
                        dish.price = item.price
                        dish.desc = item.description
                    }

                    do {
                        try viewContext.save()
                        print("Data saved to Core Data")
                    } catch {
                        print("Error saving to Core Data: \(error.localizedDescription)")
                    }
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }

        task.resume()
    }
}

#Preview {
    Menu()
}
