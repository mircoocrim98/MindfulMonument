//
//  LoadingView.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 15.09.24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            
            ProgressView("Laden...")
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
                .padding()
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    LoadingView()
}
