//
//  UserViewModel.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 15.09.24.
//

import Foundation
import FirebaseCore

class UserViewModel: ObservableObject {
    
    private let authManager = AuthManager.shared
    private let userRepository = UserRepository.shared
    
    @Published var user: UserModel?
    @Published var moods: [Int] = []
    @Published var currentJournal: JournalEntry?
    @Published var isCurrentDay = true
    
    init() {
        Task {
            await loadUserData()
        }
    }
    
    func loadUserData() async {
        guard let userID = authManager.userID else { return }
        do {
            if let fetchedUser = try await userRepository.fetchUserData(userID: userID) {
                DispatchQueue.main.async {
                    self.user = fetchedUser
                }
            }
        } catch {
            print("Fehler beim Laden der Benutzerdaten: \(error)")
        }
    }
    
    func saveCurrentJournal() async {
            guard let userID = authManager.userID,
                  let journal = currentJournal,
                  Calendar.current.isDateInToday(journal.date.dateValue()) else {
                print("Kein Eintrag für heute oder currentJournal ist nil. Speicherung übersprungen.")
                return
            }
            
            do {
                try await userRepository.saveJournalEntry(userID: userID, journal: journal)
                print("Journal successfully updated.")
            } catch {
                print("Error updating journal: \(error)")
            }
        }
    
    func loadLast7JournalEntries() async {
        do {
            let entries = try await userRepository.fetchLast7Journals(userID: authManager.userID!)
            DispatchQueue.main.async {
                self.moods = entries.map { $0.mood }
                print("Mood entries loaded: \(self.moods)")
            }
        } catch {
            print("Fehler beim Laden der letzten 7 Journalentries: \(error)")
        }
    }
    
    func loadLatestJournal() async {
        guard let userID = authManager.userID else { return }
        do {
            if let latestJournal = try await userRepository.fetchLatestJournalEntry(userID: userID) {
                let latestDate = latestJournal.date.dateValue()
                
                if Calendar.current.isDateInToday(latestDate) {
                    DispatchQueue.main.async {
                        self.currentJournal = latestJournal
                        self.isCurrentDay = true
                    }
                } else {
                    let newJournal = try await userRepository.createJournalForToday(userID: userID)
                    DispatchQueue.main.async {
                        self.currentJournal = newJournal
                        self.isCurrentDay = true
                    }
                }
            } else {
                let newJournal = try await userRepository.createJournalForToday(userID: userID)
                DispatchQueue.main.async {
                    self.currentJournal = newJournal
                    self.isCurrentDay = true
                }
            }
        } catch {
            print("Fehler beim Laden des neuesten Journals: \(error)")
        }
    }

    
    func navigateToPreviousEntry() async {
            guard let currentJournalDate = currentJournal?.date.dateValue(),
                  let userID = authManager.userID else { return }
            
            do {
                if let previousJournal = try await userRepository.fetchPreviousJournalEntry(userID: userID, before: currentJournalDate) {
                    DispatchQueue.main.async {
                        self.currentJournal = previousJournal
                        self.isCurrentDay = Calendar.current.isDateInToday(previousJournal.date.dateValue())
                    }
                } else {
                    print("Kein vorheriger Journal-Eintrag gefunden.")
                }
            } catch {
                print("Fehler beim Laden des vorherigen Journals: \(error)")
            }
        }
        
    func navigateToNextEntry() async {
        guard let currentJournalDate = currentJournal?.date.dateValue(),
              let userID = authManager.userID else { return }
        
        do {
            if let nextJournal = try await userRepository.fetchNextJournalEntry(userID: userID, after: currentJournalDate) {
                DispatchQueue.main.async {
                    self.currentJournal = nextJournal
                    self.isCurrentDay = Calendar.current.isDateInToday(nextJournal.date.dateValue())
                }
            } else {
                print("Kein nächster Journal-Eintrag gefunden.")
            }
        } catch {
            print("Fehler beim Laden des nächsten Journals: \(error)")
        }
    }
    
    func incrementStreakIfAllSectionsCompleted() async {
        guard let userID = authManager.userID else { return }
        let completedSections = [
            currentJournal?.dailyGoal,
            currentJournal?.relaxation,
            currentJournal?.thoughts,
            currentJournal?.gratitude,
            currentJournal?.bestMoment,
            currentJournal?.affirmation
        ].compactMap { $0 }.filter { !$0.isEmpty }.count
        
        if completedSections == 6 {
            do {
                try await userRepository.updateStreaksIfNeeded(userID: userID)
                await loadUserData() 
            } catch {
                print("Fehler beim Aktualisieren der Streaks: \(error)")
            }
        }
    }
}
