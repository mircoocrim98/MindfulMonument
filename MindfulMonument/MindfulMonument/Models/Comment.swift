//
//  Comment.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 01.11.24.
//

import FirebaseFirestore

struct Comment: Codable, Identifiable {
    @DocumentID var id: String?
    var authorId: String
    var content: String
    var timestamp: Timestamp
}
