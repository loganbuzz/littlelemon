//
//  OnboardingView.swift
//  Little Lemon Capstone
//
//  Created by Logan Buzzard on 9/19/24.
//

import SwiftUI

let kFirstNameKey = "firstNameKey"
let kLastNameKey = "lastNameKey"
let kEmailKey = "emailKey"
let kIsLoggedInKey = "isLoggedIn"

struct Onboarding: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = UserDefaults.standard.bool(forKey: kIsLoggedInKey)

    var body: some View {
        NavigationStack {
            VStack {
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)

                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.bottom, 20)

                Button(action: {
                    // Input Validation
                    if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && isValidEmail(email) {
                        // Save to UserDefaults
                        UserDefaults.standard.set(firstName, forKey: kFirstNameKey)
                        UserDefaults.standard.set(lastName, forKey: kLastNameKey)
                        UserDefaults.standard.set(email, forKey: kEmailKey)
                        // Inside the if statement where registration is successful
                        UserDefaults.standard.set(true, forKey: kIsLoggedInKey)
                    } else {
                        // Show error alert
                        alertMessage = "Please fill in all fields correctly."
                        showingAlert = true
                    }
                }) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .padding()
            .navigationTitle("Register")
            .navigationDestination(isPresented: $isLoggedIn) {
                Home()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
#Preview {
    Onboarding()
}
