//
//  PostView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 30.10.24.
//

import SwiftUI

struct PostView: View {
    var post: Post
    var onLike: () -> Void
    var onComment: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(post.authorId)
                .font(.headline)
                .foregroundColor(.black)
            
            Text(post.content)
                .foregroundColor(.black)
                .padding(.vertical, 5)

            HStack {
                Button(action: onLike) {
                    HStack {
                        Image(systemName: "hand.thumbsup.fill")
                        Text("\(post.likeCount)")
                    }
                    .foregroundColor(.cyan)
                }
                
                Spacer()
                
                Button(action: onComment) {
                    HStack {
                        Image(systemName: "bubble.right.fill")
                        Text("\(post.commentCount)")
                    }
                    .foregroundColor(.cyan)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(.systemGray), lineWidth: 4)
        )
        .cornerRadius(15)
        .padding(.horizontal)
    }
}
