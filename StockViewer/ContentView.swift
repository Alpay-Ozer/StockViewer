//
//  ContentView.swift
//  StockViewer
//
//  Created by Alpay Ozer on 28/10/2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var appNavigation = AppNavigation()
    
    var body: some View {
        
        TabView {
            
            NavigationStack(path:$appNavigation.stockNavigation){
                            StockView().environmentObject(appNavigation).navigationDestination(for: StockViewRoute.self) { route in
                                switch route {
                                case .stockDetail(let sym):
                                    StockDetailView(sym: sym)
                                }
                            }
                        }.tabItem{Label("Stocks", systemImage: "chart.bar.xaxis")}
            
        }.onAppear() {
            UITabBar.appearance().backgroundColor = .black
            UITabBar.appearance().unselectedItemTintColor = .white
        }
    }
}

#Preview {
    ContentView()
}
