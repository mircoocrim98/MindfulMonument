//
//  CommunityViewModel.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 01.11.24.
//

import Foundation

@MainActor
class CommunityViewModel: ObservableObject {
    
    private let communityRepository = CommunityRepository.shared
    
    @Published var posts: [Post] = []
    @Published var comments: [Comment] = []
    @Published var errorMessage: String?
    
    init() {
        Task {
            await loadPosts()
        }
    }

    func loadPosts() async {
        do {
            posts = try await communityRepository.fetchPosts()
        } catch {
            errorMessage = "Fehler beim Laden der Posts: \(error.localizedDescription)"
        }
    }
    
    func createPost(content: String, authorId: String) async {
        do {
            try await communityRepository.createPost(content: content, authorId: authorId)
            await loadPosts()
        } catch {
            errorMessage = "Fehler beim Erstellen des Posts: \(error.localizedDescription)"
        }
    }
    
    func likePost(postId: String, userId: String) async {
        do {
            try await communityRepository.likePost(postId: postId, userId: userId)
            await loadPosts()
        } catch {
            errorMessage = "Fehler beim Liken des Posts: \(error.localizedDescription)"
        }
    }

    func loadComments(for postId: String) async {
        do {
            comments = try await communityRepository.fetchComments(for: postId)
        } catch {
            errorMessage = "Fehler beim Laden der Kommentare: \(error.localizedDescription)"
        }
    }
    
    func addComment(to postId: String, content: String, authorId: String) async {
        do {
            try await communityRepository.addComment(to: postId, content: content, authorId: authorId)
            await loadComments(for: postId) 
        } catch {
            errorMessage = "Fehler beim Hinzufügen des Kommentars: \(error.localizedDescription)"
        }
    }
}
