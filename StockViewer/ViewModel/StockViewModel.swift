//
//  StockViewModel.swift
//  StockViewer
//
//  Created by Alpay Ozer on 28/10/2024.
//

import Foundation
import Observation
import SwiftUI

enum StockViewState {
    case initial
    case loading
    case loaded(data: SearchStock)
    case error(error: String)
}

@Observable class StockViewModel {
    var searchSymbol: String = ""
    var stockViewState: StockViewState = StockViewState.initial
    
    private let stockService: StockService
    
    init(stockService: StockService) {
        self.stockService = stockService
    }
    
    
    func getSearchStock() async {
        
        DispatchQueue.main.async {
            self.stockViewState = .loading
        }
        
        
        guard !searchSymbol.isEmpty else {
            DispatchQueue.main.async {
                self.stockViewState = .initial
            }
            return
        }
        
        
        let currentSearchSymbol = searchSymbol // Capture the current symbol
        try? await Task.sleep(nanoseconds: 500_000_000) // 500ms debounce
        
        guard currentSearchSymbol == searchSymbol else { return }
        
        if searchSymbol.count > 1 {
            do {
                try await Task.sleep(nanoseconds: 3_000_000_000) // 3 second delay
                
                let data = try await self.stockService.SearchStocks(ticker: searchSymbol.capitalized)
                
                DispatchQueue.main.async {
                    self.stockViewState = .loaded(data: data)
                }
            } catch let error {
                DispatchQueue.main.async {
                    self.stockViewState = .error(error: error.localizedDescription)
                }
            }
        }
    }
}
                                 


                                 
