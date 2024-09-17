//
//  AuthenticationView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 14.09.24.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var isLoginMode = true
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var username = ""
    @State private var passwordsMatch = true
    @ObservedObject var viewModel: UserViewModel
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image("DarkLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .padding(.top, 50)

                Text("Mindful Monument")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.darkText)
                    .padding(.top, 20)

                TextField("E-Mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)

                SecureField("Passwort", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)

                if !isLoginMode {
                    SecureField("Passwort bestätigen", text: $confirmPassword)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)

                    TextField("Benutzername", text: $username)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)

                    if !passwordsMatch {
                        Text("Passwörter stimmen nicht überein")
                            .foregroundColor(.red)
                    }
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: {
                    checkPasswordMatch()

                    Task {
                        if isLoginMode {
                            await signInUser()
                        } else {
                            await signUpUser()
                        }
                    }
                }) {
                    Text(isLoginMode ? "Einloggen" : "Registrieren")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.cyan)
                        .cornerRadius(10)
                }

                Button(action: {
                    isLoginMode.toggle()
                }) {
                    Text(isLoginMode ? "Neu hier? \n Registrieren" : "Bereits ein Konto? Einloggen")
                        .foregroundColor(.cyan)
                        .fontWeight(.semibold)
                }
            }
            .padding()
        }
        .background(Color(Color.background))
    }

    private func checkPasswordMatch() {
        passwordsMatch = (password == confirmPassword)
    }

    private func signInUser() async {
        do {
            try await AuthManager.shared.signIn(email: email, password: password)
            errorMessage = nil
        } catch {
            errorMessage = "Anmeldung fehlgeschlagen: \(error.localizedDescription)"
        }
    }

    private func signUpUser() async {
        if !passwordsMatch {
            errorMessage = "Passwörter stimmen nicht überein."
            return
        }

        do {
            try await AuthManager.shared.signUp(email: email, password: password, username: username)
            errorMessage = nil
        } catch {
            errorMessage = "Registrierung fehlgeschlagen: \(error.localizedDescription)"
        }
    }
}
