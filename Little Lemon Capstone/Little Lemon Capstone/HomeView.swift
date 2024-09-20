//
//  HomeView.swift
//  Little Lemon Capstone
//
//  Created by Logan Buzzard on 9/19/24.
//
import SwiftUI

struct Home: View {
    var body: some View {
                NavigationView {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            TopBar()
                            HeroSection()
                            MenuCategories()
                            MenuView()
                        }
                    }
                    .navigationBarHidden(true)
                }
            }
        }

struct TopBar: View {
    var body: some View {
        HStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 40)

            Spacer()

            NavigationLink(destination: UserProfile()) {
                Image("Profile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
        }
        .padding()
    }
}

struct HeroSection: View {
    var body: some View {
        ZStack {
            BrandColors.primary1
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 10) {
                Text("Little Lemon")
                    .font(BrandFonts.display)
                    .foregroundColor(BrandColors.primary2)

                Text("Chicago")
                    .font(BrandFonts.subheading)
                    .foregroundColor(.white)

                Text("We are a family-owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                    .font(BrandFonts.body)
                    .foregroundColor(.white)
                    .lineLimit(3)

                    Image("HeroImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(16)
                }
            }
            .padding()
        }
    }

struct MenuCategories: View {
    let categories = ["Starters", "Mains", "Desserts", "Sides"]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        // Handle selection
                    }) {
                        Text(category)
                            .font(BrandFonts.navbar)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(BrandColors.secondary1)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    Home()
}
