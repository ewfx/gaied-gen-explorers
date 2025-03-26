//
//  ContentView.swift
//  EmailClassification
//
//  Created by Neha Vishnoi on 25/03/25.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State var summaryItems: [SummaryItem] = []
    @State private var selectedItem: SummaryItem?
    @State private var isProcessing: Bool = false
    @State private var selectedFilter: String = "All"
    @State private var filteredItems: [SummaryItem] = []
    
    var body: some View {
            NavigationSplitView {
                VStack {
                    HStack {
                        // 📂 Browse Folder Button
                        Button("📂 Browse Folder") {
                            browseFiles()
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(alignment: .leading)
                        
                        Spacer()

                        // 🔍 Filter Picker (Dropdown)
                        Picker("Filter", selection: $selectedFilter) {
                            Text("All").tag("All")
                            ForEach(uniqueRequestTypes(), id: \.self) { type in
                                Text(type).tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // macOS-style dropdown
                        .onChange(of: selectedFilter) { _ in
                            applyFilter()
                        }
                        .fixedSize()
                        .frame(alignment: .trailing)

                    }
                    .padding()
                    
                    // 🔄 Show Activity Indicator While Processing
                    if isProcessing {
                        ProgressView("Processing files…")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }

                    if summaryItems.isEmpty {
                        Text("No emails found. Click 'Browse Folder' to load data.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List(summaryItems) { item in
                            SummaryRowView(summaryItem: item)
                                .onTapGesture {
                                    selectedItem = item
                                }
                        }
                        .listStyle(.plain)
                        .frame(minHeight: 200) // ✅ Ensures List has height
                    }
                }
                .frame(minWidth: 200)
                .navigationTitle("Emails")
            } detail: {
                if let selectedItem = selectedItem {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("📌 Issue Summary")
                            .font(.title2)
                            .bold()
                        Text(selectedItem.issueSummary ?? "")
                            .padding(.bottom, 10)

                        Text("📋 Request Type: \(selectedItem.requestType ?? "") (\(selectedItem.requestSubtype ?? ""))")
                            .font(.subheadline)

                        Text("🔎 Confidence Score: \(selectedItem.confidenceScore ?? 0)%")
                            .font(.subheadline)

                        Text("🏢 Organizations: \(selectedItem.namedEntities?.ORG?.joined(separator: ", ") ?? "")")
                        Text("💰 Money: \(selectedItem.namedEntities?.MONEY?.joined(separator: ", ") ?? "")")
                        Text("📧 Emails: \(selectedItem.namedEntities?.EMAIL?.joined(separator: ", ") ?? "")")
                    }
                    .padding()
                } else {
                    Text("Select an email to view details")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    
    func browseFiles() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseFiles = false

        if openPanel.runModal() == .OK, let selectedFolderURL = openPanel.url {
            processFiles(in: selectedFolderURL)
        }
    }
    
    func uniqueRequestTypes() -> [String] {
        let types = summaryItems.map { $0.requestType } // 🔴 requestType might be Optional (String?)
        var typesArray: [String] = []
        for type in types {
            if !typesArray.contains(type ?? "") {
                typesArray.append(type ?? "")
            }
        }
        return typesArray.sorted()
    }
    
    func applyFilter() {
        if selectedFilter == "All" {
            filteredItems = summaryItems
        } else {
            filteredItems = summaryItems.filter { $0.requestType == selectedFilter }
        }
    }
    
    func processFiles(in selectedFolderURL: URL) {
        isProcessing = true  // 🔄 Start Activity Indicator
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileManager = FileManager.default
                let fileURLs = try fileManager.contentsOfDirectory(at: selectedFolderURL, includingPropertiesForKeys: nil)

                var pendingRequests = fileURLs.count  // Track remaining tasks
                summaryItems = []
                for fileURL in fileURLs {
                    if fileURL.isFileURL {
                        let content = FileProcessor.extractText(from: fileURL)
                        print("File: \(fileURL.lastPathComponent)")
                        print("Content: \(content)")

                        // Send content to LLM for NER analysis
                        Services.analyzeNERWithGemini(with: content) { summaryResponse in
                            DispatchQueue.main.async {
                                if let item = summaryResponse {
                                    summaryItems.append(item)
                                }
                                
                                pendingRequests -= 1  // ✅ Reduce pending task count
                                
                                // Hide indicator when all files are processed
                                if pendingRequests == 0 {
                                    isProcessing = false  // ✅ Stop Activity Indicator
                                }
                            }
                        }
                    } else {
                        pendingRequests -= 1  // ✅ Reduce count if not a file
                    }
                }
            } catch {
                print("❌ Error reading folder contents: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    isProcessing = false  // ✅ Stop indicator on failure
                }
            }
        }
    }
}

struct SummaryRowView: View {
    let summaryItem: SummaryItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 📌 Issue Summary
            Text(summaryItem.issueSummary ?? "")
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(3)

            // 🗂️ Request Type with Icons
            HStack {
                
                Text("Request type:")
                    .font(.subheadline)
                    .foregroundColor(.white)

                Text(summaryItem.requestType ?? "")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            // 🗂️ Request Type with Icons
            HStack {
                
                Text("Subrequest type:")
                    .font(.subheadline)
                    .foregroundColor(.white)

                Text("\(summaryItem.requestSubtype ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            // 🗂️ Request Type with Icons
            HStack {
                
                Text("Confidence Score:")
                    .font(.subheadline)
                    .foregroundColor(.white)

                Text("\(summaryItem.confidenceScore ?? 0)")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray)))
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
