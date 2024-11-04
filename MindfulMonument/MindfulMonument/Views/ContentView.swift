//
//  ContentView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 15.09.24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var quoteViewModel: QuoteViewModel
    @ObservedObject var communityViewModel: CommunityViewModel

    var body: some View {
        TabView {
            HomeView(userViewModel: userViewModel, quoteViewModel: quoteViewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            JournalView(userViewModel: userViewModel)
                .tabItem {
                    Label("Journal", systemImage: "book")
                }

            CommunityView(communityViewModel: communityViewModel, userViewModel: userViewModel)
                .tabItem {
                    Label("Community", systemImage: "person.3")
                }

//            ChatsView()
//                .tabItem {
//                    Label("Chats", systemImage: "message")
//                }
        }
        .accentColor(.cyan)
    }
}

