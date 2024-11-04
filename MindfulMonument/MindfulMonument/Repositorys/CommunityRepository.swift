//
//  CommunityRepository.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 01.11.24.
//

import FirebaseFirestore

class CommunityRepository {
    
    static let shared = CommunityRepository()
    private let db = Firestore.firestore()
    
    func createPost(content: String, authorId: String) async throws {
        let postRef = db.collection("posts").document()
        let post = [
            "authorId": authorId,
            "content": content,
            "timestamp": Timestamp(),
            "likeCount": 0,
            "commentCount": 0,
            "likedBy": []
        ] as [String : Any]
        
        try await postRef.setData(post)
    }
    
    func fetchPosts() async throws -> [Post] {
        let querySnapshot = try await db.collection("posts")
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return querySnapshot.documents.compactMap { try? $0.data(as: Post.self) }
    }

    func likePost(postId: String, userId: String) async throws {
        let postRef = db.collection("posts").document(postId)
        
        _ = try await db.runTransaction { transaction, errorPointer in
            do {
                let postSnapshot = try transaction.getDocument(postRef)
                guard var post = try? postSnapshot.data(as: Post.self) else {
                    errorPointer?.pointee = NSError(domain: "AppError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Post not found"])
                    return nil
                }
                
                if post.likedBy.contains(userId) {
                    post.likedBy.removeAll { $0 == userId }
                    post.likeCount -= 1
                } else {
                    post.likedBy.append(userId)
                    post.likeCount += 1
                }
                
                try transaction.setData(from: post, forDocument: postRef)
            } catch {
                errorPointer?.pointee = NSError(domain: "AppError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Transaction failed: \(error.localizedDescription)"])
                return nil
            }
            
            return nil
        }
    }



    func addComment(to postId: String, content: String, authorId: String) async throws {
        let commentRef = db.collection("posts").document(postId).collection("comments").document()
        
        let commentData: [String: Any] = [
            "authorId": authorId,
            "content": content,
            "timestamp": Timestamp()
        ]
        
        try await commentRef.setData(commentData)
        
        let postRef = db.collection("posts").document(postId)
        try await postRef.updateData(["commentCount": FieldValue.increment(Int64(1))])
    }
    
    func fetchComments(for postId: String) async throws -> [Comment] {
            let commentsRef = db.collection("posts").document(postId).collection("comments")
            
            let querySnapshot = try await commentsRef
                .order(by: "timestamp", descending: false) 
                .getDocuments()
            
            return querySnapshot.documents.compactMap { try? $0.data(as: Comment.self) }
        }
}
