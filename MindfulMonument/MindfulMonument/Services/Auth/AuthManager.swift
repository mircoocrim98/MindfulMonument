//
//  FirebaseAuthManager.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 14.09.24.
//

import Foundation
import FirebaseAuth

@Observable
class AuthManager {
    
    private init() {
        checkAuth()
    }
    
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private let userRepository = UserRepository.shared
    
    var firebaseUser: User?
    
    var isUserSignedIn: Bool {
        firebaseUser != nil
    }
    
    var userID: String? {
        firebaseUser?.uid
    }
    
    func signUp(email: String, password: String, username: String) async throws {
            let authResult = try await auth.createUser(withEmail: email, password: password)
            guard let email = authResult.user.email else { throw AuthError.noEmail }
            print("User with email '\(email)' is registered with id '\(authResult.user.uid)'")
            
            let newUser = UserModel(
                id: authResult.user.uid,
                username: username,
                email: email
            )
            
            try await UserRepository.shared.createUserInFirestore(user: newUser)
            
            self.firebaseUser = authResult.user
        }

    func signIn(email: String, password: String) async throws {
        let authResult = try await auth.signIn(withEmail: email, password: password)
        guard let email = authResult.user.email else { throw AuthError.noEmail }
        print("User with email '\(email)' signed in with id '\(authResult.user.uid)'")
        self.firebaseUser = authResult.user
    }
    
    func signOut() {
        do {
            try auth.signOut()
            firebaseUser = nil
            print("Sign out succeeded.")
        } catch {
            print("Sign out failed.")
        }
    }
    
    
    
    private func checkAuth() {
        guard let currentUser = auth.currentUser else {
            print("Not logged in")
            return
        }
        self.firebaseUser = currentUser
    }
}

enum AuthError: LocalizedError {
    case noEmail
    case notAuthenticated
    
    var errorDescription: String { "Auth Error" }
    
    var localizedDescription: String {
        switch self {
        case .noEmail:
            "No email was found on newly created user."
        case .notAuthenticated:
            "The user is not authenticated."
        }
    }
}
