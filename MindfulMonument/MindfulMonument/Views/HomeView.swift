//
//  StartScreenView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 09.09.24.
//

import SwiftUI

struct HomeView: View {
    @State private var currentStreak = 7
    @State private var highestStreak = 30
    @State private var quote = "Erfolg ist kein Glück, sondern das Ergebnis von harter Arbeit."
    
    @State private var moodTrend = [4, 3, 5, 2, 4, 3, 5]
    @State private var trophyProgress = 0.7
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text(quote)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 4))
            .cornerRadius(15)
            
            
            
            HStack(spacing: 20) {
                VStack {
                    Text("\(currentStreak)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.secondaryCyan)
                    Text("Aktuelle Streak")
                        .font(.body)
                        .foregroundColor(Color.darkText)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 4))
                .cornerRadius(15)
                
                
                VStack {
                    Text("\(highestStreak)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primaryCyan)
                    Text("Höchste Streak")
                        .font(.body)
                        .foregroundColor(Color.darkText)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 4))
                .cornerRadius(15)
                
            }
            
            VStack {
                Text("Stimmungstrend")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 5)
                
                HStack(spacing: 10) {
                    ForEach(moodTrend, id: \.self) { mood in
                        VStack {
                            Capsule()
                                .fill(moodColor(for: mood))
                                .frame(width: 20, height: CGFloat(mood) * 20)
                            Text("\(mood)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 4))
            .cornerRadius(15)
            
            
            VStack {
                Text("Deine Trophäen")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.bottom, 5)
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .opacity(0.3)
                        .foregroundColor(.secondaryCyan)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(trophyProgress))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .foregroundColor(.primaryCyan)
                        .rotationEffect(Angle(degrees: 270))
                        .animation(.linear, value: trophyProgress)
                    
                    VStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                        
                    }
                }
                .frame(width: 120, height: 120)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.black)
                    Image(systemName: "star.fill")
                        .foregroundColor(.black)
                    Image(systemName: "star.fill")
                        .foregroundColor(.black)
                }
                .padding(.top, 5)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 4))
            .cornerRadius(15)
            
            
            Spacer()
        }
        .padding()
        .background(Color.background)
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

#Preview {
    HomeView()
}

