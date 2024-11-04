//
//  StartScreenView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 09.09.24.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var quoteViewModel: QuoteViewModel
    @State private var showProfileSheet = false
    @State private var trophyProgress = 0.5

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(quoteViewModel.quote)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(.systemGray), lineWidth: 4))
                    .cornerRadius(15)
                    .padding(.top, 20)

                HStack(spacing: 20) {
                    StreakView(title: "Aktuelle Streak", streak: userViewModel.user?.currentStreak ?? 0, color: .secondaryCyan)
                    StreakView(title: "Höchste Streak", streak: userViewModel.user?.highestStreak ?? 0, color: .primaryCyan)
                }

                VStack {
                    Text("Stimmungstrend")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.bottom, 5)
                    
                    HStack(spacing: 10) {
                        ForEach(Array(userViewModel.moods), id: \.self) { mood in
                            VStack {
                                Capsule()
                                    .fill(moodColor(for: mood))
                                    .frame(width: 20, height: CGFloat(mood) * 15)
                                
                                Text("\(mood)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    HStack {
                        Text("Vor 7 Tagen")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("Heute")
                            .font(.caption)
                            .foregroundColor(.primaryCyan)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 5)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(.systemGray), lineWidth: 4)
                )
                .cornerRadius(15)




                VStack {
                    Text("Deine Trophäen")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.bottom, 5)

                    ZStack {
                        Circle()
                            .stroke(lineWidth: 7)
                            .opacity(0.3)
                            .foregroundColor(.secondaryCyan)

                        Circle()
                            .trim(from: 0.0, to: CGFloat(trophyProgress))
                            .stroke(style: StrokeStyle(lineWidth: 7, lineCap: .round))
                            .foregroundColor(.primaryCyan)
                            .rotationEffect(Angle(degrees: 270))
                            .animation(.linear, value: trophyProgress)

                        VStack {
                            Image("Trophy30")
                                .resizable()
                                .frame(width: 35, height: 35)
                                
                        }
                    }
                    .frame(width: 80, height: 80)

                    HStack {
                        Image("Trophy7")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding([.leading, .trailing], 5)
                        Image("Trophy14")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding([.leading, .trailing], 5)
                    }
                    .padding(.top, 5)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(.systemGray), lineWidth: 4))
                .cornerRadius(15)

                Spacer()
            }
            .padding()
            .background(Color.background)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showProfileSheet.toggle()
                    }) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showProfileSheet) {
                ProfileSheetView(userViewModel: userViewModel)
            }
            .onAppear {
                Task {
                    await userViewModel.loadLast7JournalEntries()
                }
            }
        }
    }

    func moodColor(for mood: Int) -> Color {
        switch mood {
        case 1: return .primaryCyan.opacity(0.7)
        case 2: return .primaryCyan.opacity(0.5)
        case 3: return .primaryCyan.opacity(0.3)
        case 4: return .primaryCyan.opacity(0.2)
        case 5: return .primaryCyan
        default: return .gray
        }
    }
}
