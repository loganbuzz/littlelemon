//
//  UserProfile.swift
//  Little Lemon Capstone
//
//  Created by Logan Buzzard on 9/19/24.
//

import SwiftUI

struct UserProfile: View {
    // Retrieve user data from UserDefaults
    let firstName = UserDefaults.standard.string(forKey: kFirstNameKey) ?? ""
    let lastName = UserDefaults.standard.string(forKey: kLastNameKey) ?? ""
    let email = UserDefaults.standard.string(forKey: kEmailKey) ?? ""

    // Environment variable to access presentation mode
    @Environment(\.presentationMode) var presentation

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Personal Information")
                .font(.title)
                .padding(.top, 20)

            // Profile Image
            Image("Profile")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))

            // User Information
            Text("First Name: \(firstName)")
            Text("Last Name: \(lastName)")
            Text("Email: \(email)")

            // Logout Button
            Button(action: {
                // Reset login state in UserDefaults
                UserDefaults.standard.set(false, forKey: kIsLoggedInKey)

                // Dismiss to go back to Onboarding
                presentation.wrappedValue.dismiss()
            }) {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 30)

            Spacer() // Push content to the top
        }
        .padding()
    }
}
#Preview {
    UserProfile()
}
