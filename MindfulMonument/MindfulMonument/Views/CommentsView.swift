//
//  CommentsView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 01.11.24.
//

import SwiftUI
import Firebase

struct CommentsView: View {
    @State var post: Post
    @ObservedObject var communityViewModel: CommunityViewModel
    @ObservedObject var userViewModel: UserViewModel
    @State private var newComment: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                ForEach(communityViewModel.comments) { comment in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(comment.authorId)
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(comment.content)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding([.horizontal, .top])
                }
            }
            
            TextField("Schreibe einen Kommentar...", text: $newComment)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding([.horizontal, .top])

            Button(action: {
                Task {
                    await addComment()
                }
            }) {
                Text("Kommentieren")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.cyan)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Kommentare")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await communityViewModel.loadComments(for: post.id ?? "")
                print(communityViewModel.comments)
            }
        }
    }
    
    func addComment() async {
        guard !newComment.isEmpty else { return }
        
        await communityViewModel.addComment(to: post.id ?? "", content: newComment, authorId: userViewModel.user?.username ?? "error")
        newComment = ""
    }
}
