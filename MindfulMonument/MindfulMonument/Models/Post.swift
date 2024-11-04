//
//  Post.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 30.10.24.
//


import FirebaseFirestore

struct Post: Codable, Identifiable {
    @DocumentID var id: String?
    var authorId: String
    var content: String
    var timestamp: Timestamp
    var likeCount: Int
    var commentCount: Int
    var likedBy: [String]
}
