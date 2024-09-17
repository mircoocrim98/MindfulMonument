//
//  JournalView2.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 09.09.24.
//

import SwiftUI

struct JournalView: View {
    @State private var currentDay = Date()
    @State private var dailyGoal = ""
    @State private var relaxation = ""
    @State private var thoughts = ""
    @State private var gratitude = ""
    @State private var bestMoment = ""
    @State private var affirmation = ""
    @State private var mood = 3.0
    @State private var completedSections = 0

    var body: some View {
        VStack(spacing: 20) {
            HeaderView()
            
            ProgressView(value: Double(completedSections), total: 6)
                .padding(.horizontal)
                .accentColor(.cyan)

            ScrollView {
                VStack(spacing: 20) {
                    
                    sectionHeader(title: "Morgenroutine", iconName: "sun.max.fill")
                    
                    JournalCardView(title: "Tagesziel", text: $dailyGoal)
                        .onChange(of: dailyGoal) { calculateCompletedSections() }
                    
                    JournalCardView(title: "Wie entspannst du dich heute?", text: $relaxation)
                        .onChange(of: relaxation) { calculateCompletedSections() }
                    
                    JournalCardView(title: "Gedanken, Ideen & Notizen", text: $thoughts, isTextEditor: true)
                        .onChange(of: thoughts) { calculateCompletedSections() }
                    
                    Divider()
                        .padding(.vertical)
                    
                    sectionHeader(title: "Abendroutine", iconName: "moon.fill")
                    
                    JournalCardView(title: "Dafür bin ich heute dankbar", text: $gratitude)
                        .onChange(of: gratitude) { calculateCompletedSections() }
                    
                    JournalCardView(title: "Mein schönster Moment heute", text: $bestMoment)
                        .onChange(of: bestMoment) { calculateCompletedSections() }
                    
                    JournalCardView(title: "Lieblings Affirmation", text: $affirmation)
                        .onChange(of: affirmation) { calculateCompletedSections() }
                    
                    VStack {
                        Text("Wie fühlst du dich heute?")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        HStack {
                            Text("1")
                            Slider(value: $mood, in: 1...5, step: 1)
                                .accentColor(.primaryCyan)
                            Text("5")
                        }
                        .padding()
                        
                        Text("Deine Stimmung: \(Int(mood))")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    func calculateCompletedSections() {
        let sections = [dailyGoal, relaxation, thoughts, gratitude, bestMoment, affirmation]
        completedSections = sections.filter { !$0.isEmpty }.count
    }
    
    func sectionHeader(title: String, iconName: String) -> some View {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.black)
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal)
        }
}

#Preview {
    JournalView()
}
