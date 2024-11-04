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
    @StateObject private var quoteViewModel: QuoteViewModel
    @StateObject private var communityViewModel: CommunityViewModel

    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        _userViewModel = StateObject(wrappedValue: UserViewModel())
        _quoteViewModel = StateObject(wrappedValue: QuoteViewModel())
        _communityViewModel = StateObject(wrappedValue: CommunityViewModel())
    }
        
    var body: some Scene {
        WindowGroup {
            if AuthManager.shared.isUserSignedIn {
                ContentView(userViewModel: userViewModel, quoteViewModel: quoteViewModel, communityViewModel: communityViewModel)
            } else {
                AuthenticationView(viewModel: userViewModel)
            }
        }
    }
}
