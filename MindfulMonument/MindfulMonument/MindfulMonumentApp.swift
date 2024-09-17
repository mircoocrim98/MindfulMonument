//
//  MindfulMonumentApp.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 08.09.24.
//

import SwiftUI
import Firebase

@main
struct MindfulMonumentApp: App {
    
    @StateObject private var userViewModel: UserViewModel

    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        _userViewModel = StateObject(wrappedValue: UserViewModel())
    }
        
    var body: some Scene {
        WindowGroup {
            if AuthManager.shared.isUserSignedIn {
                ContentView()
            } else {
                AuthenticationView(viewModel: userViewModel)
            }
        }
    }
}
