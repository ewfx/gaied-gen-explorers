//
//  Services.swift
//  EmailClassification
//
//  Created by Neha Vishnoi on 26/03/25.
//

import Foundation

class Services {
    static func analyzeNERWithGemini(with content: String, completion: @escaping (SummaryResponse?) -> Void) {
        // Step 1: Prepare API request
        let apiKey = "api-key" // Replace with your Gemini API key
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Step 2: Create the request body
        let body: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        [
                            "text": "I want you to act as a service request agent. In the following passed text, an issue is being discussed; I want you to generate an output with below columns: issue summary, request type, request subtype, confidence score (in percentage). Also extract all named entities from email. Add the named entities as last column in summary with their value; for example if person is a ner category mention its values after that:\n\(content). Do Not generate any other content apart from summary. The summary should be json format"
                        ]
                    ]
                ]
            ]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // Step 3: Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error as NSError? {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("NER Analysis Result: \(responseString)")
                do {
                    let response = try JSONDecoder().decode(ResponseModel.self, from: data)
                    let classification = response.candidates.first?.content
                    completion(parseTextJson(classification?.parts.first?.text))
                } catch {
                    print("Failed to decode response: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
    
    // Method to decode text JSON
    static func parseTextJson(_ text: String?) -> SummaryResponse? {
        let jsonString = text?.replacingOccurrences(of: "```json", with: "").replacingOccurrences(of: "```", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard let jsonData = jsonString?.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(SummaryResponse.self, from: jsonData)
    }

}
    

