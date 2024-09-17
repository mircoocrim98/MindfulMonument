//
//  JournalCardView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 09.09.24.
//

import SwiftUI

struct JournalCardView: View {
    var title: String
    @Binding var text: String
    var isTextEditor: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(text.isEmpty ? Color.gray : Color.cyan)
                    .opacity(text.isEmpty ? 0.3 : 1)
            }

            if isTextEditor {
                TextEditor(text: $text)
                    .frame(height: 100)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            } else {
                TextField("Dein Eintrag", text: $text)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}


struct JournalCardView_Previews: PreviewProvider {
    @State static var testText = "Test"
    
    static var previews: some View {
        JournalCardView(title: "TEST", text: $testText)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

