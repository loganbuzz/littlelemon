//
//  HomeView.swift
//  Little Lemon Capstone
//
//  Created by Logan Buzzard on 9/19/24.
//

import SwiftUI

import SwiftUI

struct Home: View {
    var body: some View {
        TabView {
            Menu()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }

            UserProfile()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Home()
}
