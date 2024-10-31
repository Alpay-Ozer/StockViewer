//
//  StockViewerApp.swift
//  StockViewer
//
//  Created by Alpay Ozer on 28/10/2024.
//

import SwiftUI
import SwiftData

@main
struct StockViewerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().modelContainer(for: BestMatch.self)
        }
    }
}
