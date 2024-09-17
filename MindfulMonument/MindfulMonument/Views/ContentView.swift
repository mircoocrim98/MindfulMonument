//
//  ContentView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 15.09.24.
//

import SwiftUI

struct ContentView: View {
    
    //@State var viewModel: UserViewModel
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            JournalView()
                .tabItem {
                    Label("Journal", systemImage: "book")
                }

//            CommunityView()
//                .tabItem {
//                    Label("Community", systemImage: "person.3")
//                }
//
//            MessageView()
//                .tabItem {
//                    Label("Messages", systemImage: "message")
//                }
        }
    }
}

#Preview {
    ContentView()
}
