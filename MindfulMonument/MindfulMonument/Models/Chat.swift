//
//  Chat.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 30.10.24.
//


import Foundation

struct Chat: Identifiable {
    let id = UUID()
    var username: String
    var lastMessage: String
    var timestamp: String
}
