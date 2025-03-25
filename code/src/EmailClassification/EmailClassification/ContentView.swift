//
//  ContentView.swift
//  EmailClassification
//
//  Created by Neha Vishnoi on 25/03/25.
//

import SwiftUI
import AppKit

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Browse") {
                browseFiles()
            }
        }
        .padding()
    }
    
    func browseFiles() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.begin { response in
            if response == .OK, let selectedURL = openPanel.url {
                print("Selected file: \(selectedURL.path)")
                print( "file content: \(FileProcessor.extractText(from: selectedURL))")
            }
        }
    }
}

#Preview {
    ContentView()
}
