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
    
    func createUserInFirestore(user: UserModel) async throws {
        try db.collection("users").document(user.id).setData(from: user)
        
        let journalRef = db.collection("users").document(user.id).collection("journals")
        let initialJournalData: [String: Any] = [
            "affirmation": "",
            "bestMoment": "",
            "dailyGoal": "",
            "gratitude": "",
            "mood": 3,
            "relaxation": "",
            "thoughts": "",
            "date": Timestamp()
        ]
        try await journalRef.document("\(UUID())").setData(initialJournalData)
    }
    
    func fetchUserData(userID: String) async throws -> UserModel? {
        let document = try await db.collection("users").document(userID).getDocument()
        return try document.data(as: UserModel.self)
    }
    
    func saveJournalEntry(userID: String, journal: JournalEntry) async throws {
        let journalCollection = db.collection("users").document(userID).collection("journals")
        
        guard let journalID = journal.id else {
            print("Journal hat keine ID. Aktualisierung übersprungen.")
            return
        }
        
        try journalCollection.document(journalID).setData(from: journal)
    }
    
    func fetchLast7Journals(userID: String) async throws -> [JournalEntry] {
        let journalCollection = db.collection("users").document(userID).collection("journals")
        let querySnapshot = try await journalCollection
            .order(by: "date", descending: false)
            .limit(to: 7)
            .getDocuments()
        
        return try querySnapshot.documents.compactMap { document in
            try document.data(as: JournalEntry.self)
        }
    }
    
    func fetchLatestJournalEntry(userID: String) async throws -> JournalEntry? {
        let journalCollection = db.collection("users").document(userID).collection("journals")
        
        let querySnapshot = try await journalCollection
            .order(by: "date", descending: true)
            .limit(to: 1)
            .getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            return nil
        }
        
        return try document.data(as: JournalEntry.self)
    }
    
    func fetchPreviousJournalEntry(userID: String, before date: Date) async throws -> JournalEntry? {
        let journalCollection = db.collection("users").document(userID).collection("journals")
        
        let querySnapshot = try await journalCollection
            .whereField("date", isLessThan: Timestamp(date: date))
            .order(by: "date", descending: true)
            .limit(to: 1)
            .getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            return nil
        }
        
        return try document.data(as: JournalEntry.self)
    }
    
    func fetchNextJournalEntry(userID: String, after date: Date) async throws -> JournalEntry? {
        let journalCollection = db.collection("users").document(userID).collection("journals")
        
        let querySnapshot = try await journalCollection
            .whereField("date", isGreaterThan: Timestamp(date: date))
            .order(by: "date", descending: false)
            .limit(to: 1)
            .getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            return nil
        }
        
        return try document.data(as: JournalEntry.self)
    }
    
    
    func createJournalForToday(userID: String) async throws -> JournalEntry {
        let journalCollection = db.collection("users").document(userID).collection("journals")
        
        let newJournal = JournalEntry(
            affirmation: "",
            bestMoment: "",
            dailyGoal: "",
            date: Timestamp(),
            gratitude: "",
            mood: 3,
            relaxation: "",
            thoughts: ""
        )
        
        let documentRef = journalCollection.document()
        try documentRef.setData(from: newJournal)
        
        return newJournal
    }
    
    
    
    func updateStreaksIfNeeded(userID: String) async throws {
        let userRef = db.collection("users").document(userID)
        
        _ = try await db.runTransaction { transaction, errorPointer in
            do {
                let userDocument = try transaction.getDocument(userRef)
                guard var userData = userDocument.data(),
                      var currentStreak = userData["currentStreak"] as? Int,
                      var highestStreak = userData["highestStreak"] as? Int,
                      let lastStreakDateTimestamp = userData["lastStreakDate"] as? Timestamp else {
                    errorPointer?.pointee = NSError(domain: "AppError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data not found"])
                    return nil
                }
                
                let lastStreakDate = lastStreakDateTimestamp.dateValue()
                if Calendar.current.isDateInToday(lastStreakDate) {
                    return nil
                }
                
                currentStreak += 1

                if currentStreak > highestStreak {
                    highestStreak = currentStreak
                }
                
                transaction.updateData([
                    "currentStreak": currentStreak,
                    "highestStreak": highestStreak,
                    "lastStreakDate": Timestamp(date: Date())
                ], forDocument: userRef)
                
                return nil
            } catch {
                errorPointer?.pointee = NSError(domain: "AppError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Transaction failed: \(error.localizedDescription)"])
                return nil
            }
        }
    }

}
