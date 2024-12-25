//
//  NewsViewModel.swift
//  StockViewer
//
//  Created by Alpay Ozer on 31/10/2024.
//

import Foundation
import Observation

enum NewsViewState {
    case initial
    case loading
    case loaded(data : NewsModel)
    case error(error: String)
}

@Observable class NewsViewModel {
    var newsViewState = NewsViewState.initial
    
    private let stockService: StockService
    
    init(stockService: StockService) {
        URLCache.shared.memoryCapacity = 80_000_000
        self.stockService = stockService
    }
    
    func getNewsAndSentiment()  async{
            self.newsViewState = NewsViewState.loading
            do{
                let data =  try await self.stockService.newsSentiment()
                self.newsViewState = NewsViewState.loaded(data: data)
            }catch let decodingError as DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Key '\(key)' not found: \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("Type '\(type)' mismatch: \(context.debugDescription)")
                case .valueNotFound(let value, let context):
                    print("Value '\(value)' not found: \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context.debugDescription)")
                default:
                    print("Decoding error: \(decodingError.localizedDescription)")
                }
                self.newsViewState = NewsViewState.error(error: decodingError.localizedDescription)
            } catch {
                self.newsViewState = NewsViewState.error(error: error.localizedDescription)
        }
    }
}
