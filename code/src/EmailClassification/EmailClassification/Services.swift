//
//  Services.swift
//  EmailClassification
//
//  Created by Neha Vishnoi on 26/03/25.
//

import Foundation
class Services {
    static func analyzeNER(with content: String) {
        let apiKey = "<add-api-key>"
        let url = URL(string: "https://api.openai.com/v1/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "text-davinci-003",
            "prompt": "Perform Named Entity Recognition (NER) on the following text:\n\(content)",
            "max_tokens": 500
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("NER Analysis Result: \(responseString)")
            }
        }
        task.resume()
    }
}
