//
//  HeaderView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 09.09.24.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var userViewModel: UserViewModel

    var body: some View {
        HStack {
            Button(action: {
                Task { await userViewModel.navigateToPreviousEntry() }
                Task { await userViewModel.saveCurrentJournal() }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.cyan)
                    .padding()
            }
            
            Spacer()
            
            Text(userViewModel.currentJournal != nil ?
                 formattedDate(userViewModel.currentJournal!.date.dateValue()) : "Error")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: {
                Task { await userViewModel.navigateToNextEntry() }
                Task { await userViewModel.saveCurrentJournal() }
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.cyan)
                    .padding()
            }
        }
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .onAppear {
            Task { await userViewModel.loadLatestJournal() }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter.string(from: date)
    }
}
