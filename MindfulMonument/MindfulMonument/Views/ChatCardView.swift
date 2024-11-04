//
//  ChatCardView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 30.10.24.
//

import SwiftUI

struct ChatCardView: View {
    var chat: Chat

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(chat.username)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Text(chat.timestamp)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text(chat.lastMessage)
                .foregroundColor(.black)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.vertical, 5)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 4)
        )
        .cornerRadius(15)
        .padding(.horizontal)
    }
}


#Preview {
    ChatCardView(chat: Chat(username: "Alice", lastMessage: "Hey, wie geht's?", timestamp: "vor 5 Min."))
}
