//
//  CurrencyModel.swift
//  StockViewer
//
//  Created by Alpay Ozer on 25/12/2024.
//

import Foundation

struct CurrencyModel: Identifiable {
    let currencyCode: String
    let currencyName: String
    
    var id: String {
        return currencyCode
    }
}
