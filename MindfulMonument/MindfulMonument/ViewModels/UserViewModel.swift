//
//  UserViewModel.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 15.09.24.
//

import FirebaseAuth

class UserViewModel: ObservableObject {
    
    private let authManager = AuthManager.shared
    private let userRepository = UserRepository.shared
    
    @Published var user: User?
    @Published var userData: [String: Any]?
    
    init() {
        self.user = authManager.user
    }
    
    func signUp(email: String, password: String, username: String) async {
        do {
            try await authManager.signUp(email: email, password: password, username: username)
            self.userData = try await userRepository.fetchUserData(userID: authManager.userID ?? "")
        } catch {
            print("Sign up failed: \(error)")
        }
    }
}
