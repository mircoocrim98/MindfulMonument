//
//  CommunityView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 18.10.24.
//

import SwiftUI

struct CommunityView: View {
    
    @ObservedObject var communityViewModel: CommunityViewModel
    @ObservedObject var userViewModel: UserViewModel
    @State private var newMessage: String = ""
    @State private var selectedPost: Post?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ScrollView {
                    ForEach(communityViewModel.posts) { post in
                        PostView(
                            post: post,
                            onLike: { likePost(post: post) },
                            onComment: { selectedPost = post }
                        )
                    }
                }
                
                TextField("Schreibe etwas...", text: $newMessage)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding([.horizontal, .top])

                Button(action: {
                    print(userViewModel.user?.username ?? "No username")
                    postMessage()
                }) {
                    Text("Posten")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .background(Color.background)
            .navigationTitle("Community Hub")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedPost) { post in
                CommentsView(post: post, communityViewModel: communityViewModel, userViewModel: userViewModel)
            }
            .onAppear {
                Task {
                    await communityViewModel.loadPosts()
                }
            }
        }
    }
    
   
    private func likePost(post: Post) {
        guard let userId = userViewModel.user?.username else { return }
        Task {
            await communityViewModel.likePost(postId: post.id ?? "", userId: userId)
        }
    }

    
    private func postMessage() {
        guard let userId = userViewModel.user?.username, !newMessage.isEmpty else { return }
        Task {
            await communityViewModel.createPost(content: newMessage, authorId: userId)
            newMessage = ""
        }
    }
}
