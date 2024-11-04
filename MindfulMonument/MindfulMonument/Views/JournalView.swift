//
//  JournalView2.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 09.09.24.
//

import SwiftUI

struct JournalView: View {
    @ObservedObject var userViewModel: UserViewModel
    
    private var completedSections: Int {
        let sections = [
            userViewModel.currentJournal?.dailyGoal,
            userViewModel.currentJournal?.relaxation,
            userViewModel.currentJournal?.thoughts,
            userViewModel.currentJournal?.gratitude,
            userViewModel.currentJournal?.bestMoment,
            userViewModel.currentJournal?.affirmation
        ]
        return sections.compactMap { $0 }.filter { !$0.isEmpty }.count
    }

    var body: some View {
        VStack(spacing: 20) {
            HeaderView(userViewModel: userViewModel)
            
            ProgressView(value: Double(completedSections), total: 6)
                .padding(.horizontal)
                .accentColor(.cyan)
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    sectionHeader(title: "Morgenroutine", iconName: "sun.max.fill")
                    
                    JournalCardView(title: "Tagesziel", text: Binding(
                        get: { userViewModel.currentJournal?.dailyGoal ?? "" },
                        set: { userViewModel.currentJournal?.dailyGoal = $0 ?? "" }
                    ), editable: userViewModel.isCurrentDay)
                    
                    JournalCardView(title: "Wie entspannst du dich heute?", text: Binding(
                        get: { userViewModel.currentJournal?.relaxation ?? "" },
                        set: { userViewModel.currentJournal?.relaxation = $0 ?? ""}
                    ), editable: userViewModel.isCurrentDay)
                    
                    JournalCardView(title: "Gedanken, Ideen & Notizen", text: Binding(
                        get: { userViewModel.currentJournal?.thoughts ?? "" },
                        set: { userViewModel.currentJournal?.thoughts = $0 ?? "" }
                    ), isTextEditor: true, editable: userViewModel.isCurrentDay)
                    
                    Divider()
                    
                    sectionHeader(title: "Abendroutine", iconName: "moon.fill")
                    
                    JournalCardView(title: "Dafür bin ich heute dankbar", text: Binding(
                        get: { userViewModel.currentJournal?.gratitude ?? "" },
                        set: { userViewModel.currentJournal?.gratitude = $0 ?? ""}
                    ), editable: userViewModel.isCurrentDay)
                    
                    JournalCardView(title: "Mein schönster Moment heute", text: Binding(
                        get: { userViewModel.currentJournal?.bestMoment ?? "" },
                        set: { userViewModel.currentJournal?.bestMoment = $0 ?? ""}
                    ), editable: userViewModel.isCurrentDay)
                    
                    JournalCardView(title: "Lieblings Affirmation", text: Binding(
                        get: { userViewModel.currentJournal?.affirmation ?? "" },
                        set: { userViewModel.currentJournal?.affirmation = $0 ?? ""}
                    ), editable: userViewModel.isCurrentDay)
                    
                    // Stimmungsanzeige
                    VStack {
                        Text("Wie fühlst du dich heute?")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        HStack {
                            Text("1")
                            Slider(value: Binding(
                                get: { Double(userViewModel.currentJournal?.mood ?? 3) },
                                set: { userViewModel.currentJournal?.mood = Int($0) }
                            ), in: 1...5, step: 1)
                            .accentColor(.primaryCyan)
                            .disabled(!userViewModel.isCurrentDay)
                            Text("5")
                        }
                        .padding()
                        
                        Text("Deine Stimmung: \(userViewModel.currentJournal?.mood ?? 3)")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            Task { await userViewModel.loadLatestJournal()}
        }
        .onDisappear {
            Task { await userViewModel.saveCurrentJournal() }
        }
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
