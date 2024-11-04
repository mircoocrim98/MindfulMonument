//
//  ChatView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 09.09.24.
//

import SwiftUI

struct ChatDetailView: View {
    @State private var messageText = ""
    @State private var messages: [String] = ["Hi! Wie geht's?", "Gut, danke! Und dir?"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Chat mit User")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    // TODO: Aktion für Schließen
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.cyan)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 2)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(messages, id: \.self) { message in
                        HStack {
                            if message.starts(with: "Gut") {
                                Spacer()
                                Text(message)
                                    .padding()
                                    .background(Color.cyan)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .frame(maxWidth: 250, alignment: .trailing)
                            } else {
                                Text(message)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .frame(maxWidth: 250, alignment: .leading)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            
            HStack {
                TextField("Nachricht eingeben", text: $messageText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 1)
                
                Button(action: {
                    sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.cyan)
                        .padding(.horizontal)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 2)
        }
        .background(Color(.systemGray6).ignoresSafeArea())
    }
    
    func sendMessage() {
        if !messageText.isEmpty {
            messages.append(messageText)
            messageText = ""
        }
    }
}

#Preview {
    ChatDetailView()
}
