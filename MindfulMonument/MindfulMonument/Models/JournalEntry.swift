//
//  JournalEntry.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 20.09.24.
//

import Foundation
import FirebaseFirestore

struct JournalEntry: Identifiable, Codable {
    @DocumentID var id: String?
    var affirmation: String = ""
    var bestMoment: String = ""
    var dailyGoal: String = ""
    var date: Timestamp
    var gratitude: String = ""
    var mood: Int = 0
    var relaxation: String = ""
    var thoughts: String = ""
    
    var dateFormatted: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
        return formatter.string(from: date.dateValue())
    }
}
