//
//  StockService.swift
//  StockViewer
//
//  Created by Alpay Ozer on 28/10/2024.
//

import Foundation

class StockService: StockProtocol {
    
    struct Constants {
        static let API_KEY = "E3Y6F2SG1ML7D0O6"
        static let POLYGON_API_KEY = "cjqDNG3_ukyOSXDZUx4VOzOJWgBETpgF"
    }
    
    func SearchStocks(ticker: String) async throws -> SearchStock {
            guard let url = URL(string: "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(ticker)&apikey=\(Constants.API_KEY)") else {
                throw URLError(.badURL)
            }
            let (data,response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                    
            else { throw URLError(.badServerResponse) }
            
            let decodeResponse = try JSONDecoder().decode(SearchStock.self, from: data)
            return decodeResponse
        }
    
    func StockDetail(ticker: String) async throws -> StockDetailModel {
            guard let url = URL(string: "https://api.polygon.io/v2/aggs/ticker/\(ticker)/range/5/day/1673089582/1688727933326?adjusted=true&sort=asc&limit=120&apiKey=\(Constants.POLYGON_API_KEY)")
                else {  throw URLError(.badURL) }
                
                let (data,response) = try await URLSession.shared.data(from: url)
                
                
                guard let response = response as? HTTPURLResponse,
                      
                        response.statusCode == 200
                        
                        
                else { throw URLError(.badServerResponse) }
                
                
            let decodeResponse = try JSONDecoder().decode(StockDetailModel.self, from: data)
                
            return decodeResponse
            }
    
    func previousClose(ticker: String) async throws -> StockDetailModel {
                guard let url = URL(string: "https://api.polygon.io/v2/aggs/ticker/\(ticker)/prev?adjusted=true&apiKey=\(Constants.POLYGON_API_KEY)")
                else {  throw URLError(.badURL) }
                
                let (data,response) = try await URLSession.shared.data(from: url)
                
                
                guard let response = response as? HTTPURLResponse,
                      
                        response.statusCode == 200
                        
                        
                else { throw URLError(.badServerResponse) }
                
                
                let decodeResponse = try JSONDecoder().decode(StockDetailModel.self, from: data)
                
                return decodeResponse
            }
}
