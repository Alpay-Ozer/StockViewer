//
//  StockProtocol.swift
//  StockViewer
//
//  Created by Alpay Ozer on 28/10/2024.
//

import Foundation

protocol StockProtocol {
    func SearchStocks(ticker: String) async throws -> SearchStock
    
    func StockDetail(ticker: String) async throws -> StockDetailModel
}
