//
//  UserRepository.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 15.09.24.
//

import FirebaseFirestore

class UserRepository {
    
    static let shared = UserRepository()
    private let db = Firestore.firestore()
    
    func createUserInFirestore(userID: String, email: String, username: String) async throws {
        let userData: [String: Any] = [
            "email": email,
            "username": username,
            "createdAt": Timestamp(date: Date())
        ]
        try await db.collection("users").document(userID).setData(userData)
    }
    
    func fetchUserData(userID: String) async throws -> [String: Any]? {
        let document = try await db.collection("users").document(userID).getDocument()
        return document.data()
    }
}

