//
//  StockDetailViewModel.swift
//  StockViewer
//
//  Created by Alpay Ozer on 29/10/2024.
//

import Foundation
import Observation


enum StockDetailState {
 case Initial
    case Loading
    case Loaded(data:StockDetailModel,previousClose:StockDetailModel)
    case error(error:String)
}
 
@Observable class StockDetailViewModel {
    
    private let stockService:StockService
    var stockDetailState:StockDetailState = StockDetailState.Initial
    
    
    init(stockService: StockService) {
        self.stockService = stockService
    }
    
    func getStockDetail(ticker:String) async {
        self.stockDetailState = StockDetailState.Loading
        do{
            let data = try await self.stockService.StockDetail(ticker: ticker)
            let previousClose = try await self.stockService.previousClose(ticker: ticker)
            self.stockDetailState = StockDetailState.Loaded(data: data,previousClose: previousClose)
            
        }catch let error {
            self.stockDetailState = StockDetailState.error(error: error.localizedDescription)
        }
    }
    
    
}

