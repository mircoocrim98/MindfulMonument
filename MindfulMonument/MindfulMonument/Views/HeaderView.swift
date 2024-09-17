//
//  HeaderView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 09.09.24.
//

import SwiftUI

struct HeaderView: View {
    @State private var currentDay = Date()

    var body: some View {
        
        HStack {
            Button(action: {
                currentDay = Calendar.current.date(byAdding: .day, value: -1, to: currentDay) ?? currentDay
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.cyan)
                    .padding()
            }
            
            Spacer()
            
            Text(formattedDate(currentDay))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: {
                currentDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDay) ?? currentDay
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.cyan)
                    .padding()
            }
        }
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
    }
}

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, d MMMM yyyy"
    return formatter.string(from: date)
}

#Preview {
    HeaderView()
}
