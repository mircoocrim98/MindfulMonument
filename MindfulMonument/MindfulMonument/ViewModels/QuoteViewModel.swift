//
//  QuoteViewmodel.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 18.10.24.
//

import Foundation

class QuoteViewModel: ObservableObject {
    @Published var quote: String = ""
    private let quoteService = QuoteService()
    
    init() {
        loadQuote()
    }
    
    func loadQuote() {
        quoteService.fetchQuote { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedQuote):
                    self.quote = fetchedQuote.quote
                case .failure(let error):
                    print("Fehler beim Laden des Zitats: \(error.localizedDescription)")
                }
            }
        }
    }
}
