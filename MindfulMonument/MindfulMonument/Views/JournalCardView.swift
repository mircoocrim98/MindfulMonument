//
//  JournalCardView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 09.09.24.
//

import SwiftUI

struct JournalCardView: View {
    var title: String
    @Binding var text: String?
    var isTextEditor: Bool = false
    var editable: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                if editable {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor((text ?? "").isEmpty ? Color.gray : Color.cyan)
                        .opacity((text ?? "").isEmpty ? 0.3 : 1)
                }
            }

            if isTextEditor {
                TextEditor(text: Binding(
                    get: { text ?? "" },
                    set: { text = $0 }
                ))
                .frame(height: 100)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .disabled(!editable)
            } else {
                TextField("Dein Eintrag", text: Binding(
                    get: { text ?? "" },
                    set: { text = $0 }
                ))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .disabled(!editable)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(.systemGray), lineWidth: 4)
        )
        .cornerRadius(15)
    }
}
