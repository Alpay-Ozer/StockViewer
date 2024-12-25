//
//  ExchangeView.swift
//  StockViewer
//
//  Created by Alpay Ozer on 25/12/2024.
//

import SwiftUI

struct ExchangeView: View {
    
    @State private var exchangeViewModel: ExchangeViewModel = ExchangeViewModel(stockService: StockService())
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(exchangeViewModel.selectedCurrency)
                    Image(systemName: "chevron.down").onTapGesture {
                        exchangeViewModel.isFirstToggle.toggle()
                    }
                    TextField("Enter amount", text: $exchangeViewModel.firstTextField).textFieldStyle(RoundedBorderTextFieldStyle()).frame(maxWidth: UIScreen.main.bounds.width * 0.6)
                }.padding(.bottom, 16)
                
                HStack {
                    Text(exchangeViewModel.secondSelectedCurrency)
                    Image(systemName: "chevron.down").onTapGesture {
                        exchangeViewModel.isSecondToggle.toggle()
                    }
                    TextField("Enter amount", text: $exchangeViewModel.secondTextField).textFieldStyle(RoundedBorderTextFieldStyle()).frame(maxWidth: UIScreen.main.bounds.width * 0.6).disabled(true)
                }
                
                Text("\(exchangeViewModel.exchangeValue, specifier: "%.2f")")
                
                if(exchangeViewModel.errorMessage.isEmpty) {
                    Text(exchangeViewModel.errorMessage)
                }
                
                Spacer()
            }.onChange(of: [exchangeViewModel.firstTextField, exchangeViewModel.secondTextField], initial: true) {
                exchangeViewModel.calculateRate()
            }
        }.sheet(isPresented: $exchangeViewModel.isFirstToggle, content: {
            customBottomSheet(exchangeViewModel: $exchangeViewModel, selectedCurrency: $exchangeViewModel.selectedCurrency)
        }).sheet(isPresented: $exchangeViewModel.isSecondToggle, content: {
            customBottomSheet(exchangeViewModel: $exchangeViewModel, selectedCurrency: $exchangeViewModel.secondSelectedCurrency)
        }).onAppear(perform: {
            exchangeViewModel.readCsv(inputFile: "physicalCurrencyList.csv")
        }).navigationTitle("Exchange").onChange(of: [exchangeViewModel.selectedCurrency, exchangeViewModel.secondSelectedCurrency], initial: true) {
            Task {
                await exchangeViewModel.currencyExchangeRate()
            }
        }
    }
}

struct customBottomSheet: View {
    @Binding var exchangeViewModel: ExchangeViewModel
    @Binding var selectedCurrency: String
    
    var body: some View {
        Picker("Picker", selection: $selectedCurrency) {
            ForEach(exchangeViewModel.currencyModel, id: \.id) { currency in
                HStack {
                    Text(currency.currencyName)
                    Text(currency.currencyCode)
                }
            }.presentationDetents([.medium])
        }.pickerStyle(.wheel)
    }
}

#Preview {
    NavigationStack {
        ExchangeView()
    }
}
