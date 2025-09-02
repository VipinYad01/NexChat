//
//  AuthModel.swift
//  Firebase Authentication
//
//  Created by vipin on 22/08/25.
//

import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var authError: String? = nil
    @Published var isLoading = false
    
    init() {
    //     Listen for login/logout automatically
        Auth.auth().addStateDidChangeListener { _ , user in
            self.user = user
        }
    }
    
    func login(email: String, password: String , showAlert: Binding<Bool> , alertMessage: Binding<String> ) {
        guard !email.isEmpty else {
            alertMessage.wrappedValue = "Please enter your email"
            showAlert.wrappedValue = true
            return
        }
        guard !password.isEmpty else {
            alertMessage.wrappedValue = "Please enter your password"
            showAlert.wrappedValue = true
            return
        }
        
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false // hide loader safely

                if let errorrr = error as NSError? {
                    switch AuthErrorCode(rawValue: errorrr.code) {
                    case .wrongPassword: alertMessage.wrappedValue = "Incorrect password"
                    case .invalidEmail: alertMessage.wrappedValue = "Invalid email"
                    case .userNotFound: alertMessage.wrappedValue = "User does not exist"
                    default: alertMessage.wrappedValue = errorrr.localizedDescription
                    }
                   
                    showAlert.wrappedValue = true
                    print("Error aa gaya bhai : \(errorrr.localizedDescription)")
                } else {
                    self.authError = nil
                    print("Account is created succcessfully ✅")
                    if let user = Auth.auth().currentUser {
                                 print("User email: \(user.email ?? "No email")")
                                 print("User UID: \(user.uid)") // unique ID in Firebase
                             }
                }
            }
        }
        


    }
    
    func logout() {
        try? Auth.auth().signOut()
        self.user = nil
    }
}
