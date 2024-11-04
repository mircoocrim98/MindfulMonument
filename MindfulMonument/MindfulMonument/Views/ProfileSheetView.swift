//
//  ProfileSheetView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 20.09.24.
//

import SwiftUI

struct ProfileSheetView: View {
    @ObservedObject var userViewModel: UserViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationView {
            VStack {
                if let user = userViewModel.user {
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .padding()

                        Text(user.username)
                            .font(.title)
                            .fontWeight(.bold)

                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else {
                    Text("Keine Benutzerdaten verfügbar")
                        .foregroundColor(.gray)
                }

                Spacer()

                Button(action: {
                    showLogoutAlert = true
                }) {
                    Text("Abmelden")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                }
                .padding()
                .alert(isPresented: $showLogoutAlert) {
                    Alert(
                        title: Text("Abmelden"),
                        message: Text("Möchtest du dich wirklich abmelden?"),
                        primaryButton: .destructive(Text("Abmelden")) {
                            AuthManager.shared.signOut()
                            userViewModel.user = nil
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .navigationTitle("Profil")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
            })
        }
    }
}
