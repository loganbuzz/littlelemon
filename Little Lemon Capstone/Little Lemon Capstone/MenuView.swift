//
//  MenuView.swift
//  Little Lemon Capstone
//
//  Created by Logan Buzzard on 9/19/24.
//

import SwiftUI
import CoreData

struct MenuView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    @State private var dataLoaded = false // Tracks if data has been loaded

    // MARK: - Build Sort Descriptors
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(
                key: "title",
                ascending: true,
                selector: #selector(NSString.localizedStandardCompare(_:))
            )
        ]
    }

    // MARK: - Build Predicate for Filtering
    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true) // Fetch all dishes if no search query
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Search Field with branded styling
                TextField("Search menu", text: $searchText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    .padding(.bottom, 10)

                // Fetch and display dishes from Core Data
                FetchedObjects(
                    predicate: buildPredicate(),
                    sortDescriptors: buildSortDescriptors()
                ) { (dishes: [Dish]) in
                    if !dataLoaded {
                        // Center the ProgressView
                        CenteredView {
                            ProgressView("Loading menu...")
                                .progressViewStyle(CircularProgressViewStyle(tint: BrandColors.primary2))
                                .scaleEffect(1.5)
                        }
                        .onAppear {
                            getMenuData()
                            dataLoaded = true
                        }
                    } else if dishes.isEmpty {
                        // Center the EmptyStateView
                        CenteredView {
                            EmptyStateView(
                                message: "No dishes found matching your search.",
                                resetAction: {
                                    withAnimation {
                                        searchText = ""
                                    }
                                }
                            )
                        }
                    } else {
                        // Display the list of dishes
                        List {
                            ForEach(dishes, id: \.self) { dish in
                                NavigationLink(destination: DishDetail(dish: dish)) {

                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .padding(.top, 10)
            .background(BrandColors.highlight.edgesIgnoringSafeArea(.all)) // Set background to light grey
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Fetch Menu Data from API
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
                    PersistenceController.shared.clear() // Clear old data

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

struct CenteredView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            Spacer()
            content
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DishRow: View {
    let dish: Dish

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading) {
                Text(dish.title ?? "Unknown Dish")
                    .font(BrandFonts.body)
                    .foregroundColor(BrandColors.darkShade)

                Text("$\(dish.price ?? "0.00")")
                    .font(BrandFonts.caption)
                    .foregroundColor(BrandColors.primary2)
            }

            Spacer()

            if let imageUrl = dish.image, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .padding(.vertical, 8)
    }
}


#Preview {
    MenuView()
}
