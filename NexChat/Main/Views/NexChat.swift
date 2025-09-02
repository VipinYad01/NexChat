//
//  Firebase_AuthenticationApp.swift
//  Firebase Authentication
//
//  Created by vipin on 13/07/25.
//

import SwiftUI
import Firebase

@main
struct YourAppApp: App {
    @StateObject var auth = AuthViewModel()
    
    init() {
        FirebaseApp.configure() // setup Firebase
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
        }
    }
}


