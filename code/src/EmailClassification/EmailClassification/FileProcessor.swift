//
//  FileProcessor.swift
//  EmailClassification
//
//  Created by Neha Vishnoi on 25/03/25.
//

import Foundation
import PDFKit

class FileProcessor {
    
    // Function to detect file type and extract text
    static func extractText(from url: URL) -> String {
        let fileExtension = url.pathExtension.lowercased()
        
        switch fileExtension {
        case "pdf":
            return extractTextFromPDF(url: url) ?? "Could not extract text from PDF."
        case "docx":
            return extractTextFromDOCX(url: url) ?? "Could not extract text from DOCX."
        case "eml":
            return extractTextFromEML(url: url) ?? "Could not extract text from EML."
        case "txt":
            return extractTextFromTXT(url: url) ?? "Could not extract text from TXT."
        default:
            return "Unsupported file format: \(fileExtension)"
        }
    }
    
    // Extract text from PDF
    private static func extractTextFromPDF(url: URL) -> String? {
        guard let pdfDocument = PDFDocument(url: url) else { return nil }
        var extractedText = ""
        
        for i in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: i), let text = page.string {
                extractedText += text + "\n"
            }
        }
        return extractedText
    }
    
    // Extract text from DOCX
    private static func extractTextFromDOCX(url: URL) -> String? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.docFormat], documentAttributes: nil) else { return nil }
        
        return attributedString.string
    }
    
    // Extract text from Email (.eml)
    private static func extractTextFromEML(url: URL) -> String? {
        guard let emailContent = try? String(contentsOf: url, encoding: .utf8) else { return nil }
        return emailContent
    }
    
    // Extract text from TXT
    private static func extractTextFromTXT(url: URL) -> String? {
        guard let textContent = try? String(contentsOf: url, encoding: .utf8) else { return nil }
        return textContent
    }
}
