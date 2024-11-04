//
//  ChatsView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 30.10.24.
//

import SwiftUI

struct ChatsView: View {
    @State private var chats: [Chat] = [
        Chat(username: "Alice", lastMessage: "Hey, wie geht's?", timestamp: "vor 5 Min."),
        Chat(username: "Bob", lastMessage: "Hast du die Notizen erhalten?", timestamp: "vor 2 Std."),
        Chat(username: "Charlie", lastMessage: "Bis bald!", timestamp: "Gestern")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(chats) { chat in
                        ChatCardView(chat: chat)
                    }
                }
                
            }
            .background(Color.background)
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.vertical)
        }
    }
}


#Preview {
    ChatsView()
}
