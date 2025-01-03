//
//  ExchangeModel.swift
//  StockViewer
//
//  Created by Alpay Ozer on 25/12/2024.
//

import Foundation

struct ExchangeModel: Codable {
    let ticker: String
    let queryCount, resultsCount: Int
    let adjusted: Bool
    let myResult: [MyResult]
    let status, requestID: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case myResult = "results"
        case ticker, queryCount, resultsCount, adjusted, status
        case requestID = "request_id"
        case count
    }
}

struct MyResult: Codable {
    let t: String
    let v: Int
    let vw, o, c, h: Double
    let l: Double
    let resultT, n: Int
    
    enum CodingKeys: String, CodingKey {
        case t = "T"
        case v, vw, o, c, h, l
        case resultT = "t"
        case n
    }
}
