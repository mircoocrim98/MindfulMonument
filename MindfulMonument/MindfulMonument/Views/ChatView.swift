//
//  ChatView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 09.09.24.
//

import SwiftUI

import SwiftUI

struct ChatView: View {
    @State private var messageText = ""
    @State private var messages: [String] = ["Hi! Wie geht's?", "Gut, danke! Und dir?"]
    
    var body: some View {
        VStack {
            // Navigation Bar
            HStack {
                Text("Chat mit User")
                    .font(.headline)
                    .padding()
                Spacer()
                Button(action: {
                    // TODO
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.cyan)
                }
                .padding()
            }
            .background(Color(.systemGray6))
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(messages, id: \.self) { message in
                        HStack {
                            if message.starts(with: "Gut") {
                                Spacer()
                                Text(message)
                                    .padding()
                                    .background(Color.cyan)
                                    .cornerRadius(15)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 250, alignment: .trailing)
                            } else {
                                Text(message)
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(15)
                                    .frame(maxWidth: 250, alignment: .leading)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                }
            }
            
            HStack {
                TextField("Nachricht eingeben", text: $messageText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.cyan)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
    }
    
    func sendMessage() {
        if !messageText.isEmpty {
            messages.append(messageText)
            messageText = ""
        }
    }
}


#Preview {
    ChatView()
}
