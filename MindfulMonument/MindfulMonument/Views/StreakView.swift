//
//  StreakView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 18.10.24.
//

import SwiftUI


struct StreakView: View {
    var title: String
    var streak: Int
    var color: Color
    
    var body: some View {
        VStack {
            Text("\(streak)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.body)
                .foregroundColor(Color.darkText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(.systemGray), lineWidth: 4))
        .cornerRadius(15)
    }
}
#Preview {
    StreakView(title: "highest streak", streak: 10, color: .cyan)
}
