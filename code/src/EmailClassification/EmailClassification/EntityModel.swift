//
//  EntityModel.swift
//  EmailClassification
//
//  Created by Neha Vishnoi on 26/03/25.
//

import Foundation

struct ResponseModel: Codable {
    let candidates: [Candidate]
    let usageMetadata: UsageMetadata
    let modelVersion: String
}

struct Candidate: Codable {
    let content: Content
    let finishReason: String
    let avgLogprobs: Double
}

struct Content: Codable {
    let parts: [Part]
    let role: String
}

struct Part: Codable {
    let text: String
}

struct UsageMetadata: Codable {
    let promptTokenCount: Int
    let candidatesTokenCount: Int
    let totalTokenCount: Int
    let promptTokensDetails: [TokenDetails]
    let candidatesTokensDetails: [TokenDetails]
}

struct TokenDetails: Codable {
    let modality: String
    let tokenCount: Int
}

struct SummaryResponse: Codable {
    let summary: [SummaryItem]
}

struct SummaryItem: Codable, Identifiable {
    let id = UUID()
    let filename: String?
    let issueSummary: String?
    let requestType: String?
    let requestSubtype: String?
    let confidenceScore: Int?
    let namedEntities: NamedEntities?
    
}

struct NamedEntities: Codable {
    let ORG: [String]?
    let MONEY: [String]?
    let EMAIL: [String]?
}

