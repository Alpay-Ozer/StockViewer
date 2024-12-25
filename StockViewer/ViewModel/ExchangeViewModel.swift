//
//  ExchangeViewModel.swift
//  StockViewer
//
//  Created by Alpay Ozer on 25/12/2024.
//

import Foundation
import Observation

@Observable class ExchangeViewModel {
    var currencyModel: [CurrencyModel] = []
    var selectedCurrency: String = "USD"
    var secondSelectedCurrency: String = "EUR"
    var isFirstToggle = false
    var isSecondToggle = false
    var firstTextField = ""
    var secondTextField = ""
    var isLoading = false
    var errorMessage  = ""
    var exchangeValue = 0.0
    
    private let stockService: StockService
    
    init(stockService: StockService) {
        self.stockService = stockService
    }
    
    func readCsv(inputFile: String) {
        if let filePath = Bundle.main.path(forResource: inputFile, ofType: nil) {
            do {
                let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
                let lines = fileContent.components(separatedBy: "\n")
                lines.dropFirst().forEach { line in
                    let data = line.components(separatedBy: ",")
                    if data.count == 2 {
                        currencyModel.append(CurrencyModel(currencyCode: data[0], currencyName: data[1]))
                    }
                }
            } catch {
                print("Error")
            }
        } else {
            print("Error: could not find file")
        }
    }
    
    func currencyExchangeRate() async {
        do {
            self.errorMessage = ""
            self.isLoading = true
            self.firstTextField = "1"
            let data = try await self.stockService.exchange(fromCurrency: selectedCurrency, toCurrency: secondSelectedCurrency)
            self.secondTextField = String(format: "%.2f", data.myResult.first?.c ?? 0)
            self.isLoading = false
        } catch let myError {
            self.errorMessage = myError.localizedDescription
            self.isLoading = false
        }
    }
    
    func calculateRate() {
        let doubleFirstRate = Double(firstTextField) ?? 0.0
        let doubleSecondRate = Double(secondTextField) ?? 0.0
        
        exchangeValue = doubleFirstRate * doubleSecondRate
    }
}
