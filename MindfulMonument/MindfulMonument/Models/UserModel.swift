//
//  User.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 20.09.24.
//

import Foundation

struct UserModel: Identifiable, Codable {
    let id: String
    var username: String
    var email: String
    var profileImageURL: String? = nil
    var currentStreak: Int = 0
    var highestStreak: Int = 0
}
