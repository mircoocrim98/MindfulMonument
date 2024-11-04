//
//  QuoteService.swift
//  MindfulMonument
//
//  Created by Mirco Lange on 18.10.24.
//

import Foundation

class QuoteService {
    private let apiUrl = "https://api.api-ninjas.com/v1/quotes?category=success"
    private let apiKey = "pO9htCMf72IiLx6AxWOQFg==pG26MOVc749PPA6t"

    func fetchQuote(completion: @escaping (Result<Quote, Error>) -> Void) {
        guard let url = URL(string: apiUrl) else {
            print("Ungültige URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("Keine Daten erhalten")
                return
            }
            
            do {
                let quotes = try JSONDecoder().decode([Quote].self, from: data)
                if let firstQuote = quotes.first {
                    completion(.success(firstQuote))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
