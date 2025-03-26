//
//  ContentView.swift
//  EmailClassification
//
//  Created by Neha Vishnoi on 25/03/25.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State var summaryItems: [SummaryResponse]?
    
    var body: some View {
        VStack {
            Button("Browse Folder") {
                browseFiles()
            }
        }
        .padding()
    }
    
    func browseFiles() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.begin { response in
            if response == .OK, let selectedFolderURL = openPanel.url {
                print("Selected folder: \(selectedFolderURL.path)")
                
                do {
                    let fileManager = FileManager.default
                    let fileURLs = try fileManager.contentsOfDirectory(at: selectedFolderURL, includingPropertiesForKeys: nil)
                    summaryItems = [SummaryResponse]()
                    for fileURL in fileURLs {
                        if fileURL.isFileURL {
                            let content = FileProcessor.extractText(from: fileURL)
                            print("File: \(fileURL.lastPathComponent)")
                            print("Content: \(content)")
                            
                            // Send content to LLM for NER analysis
                            Services.analyzeNERWithGemini(with: content) { summaryResponse in
                                if let item = summaryResponse {
                                    summaryItems?.append(item)
                                }
                                print("summaryItemss: \(String(describing: summaryItems))")
                            }
                        }
                    }
                } catch {
                    print("Error reading folder contents: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
