//
//  StockView.swift
//  StockViewer
//
//  Created by Alpay Ozer on 28/10/2024.
//

import SwiftUI
import SwiftData

struct StockView: View {
    
    @State private var stockViewModel = StockViewModel(stockService: StockService())
    @EnvironmentObject var appNavigation: AppNavigation
    
    @State var task: Task<Void, Never>? = nil
    
    @Environment(\.modelContext) private var modelContext
    
    @Query
    var localBestMatch: [BestMatch]
    
    var body: some View {
        VStack {
            switch stockViewModel.stockViewState {
            case .initial:
                if localBestMatch.isEmpty {
                    Text("Search stock")
                } else {
                    List(localBestMatch) { value in
                        HStack {
                            Text(value.the1Symbol)
                            Spacer()
                            Text(value.the2Name)
                        }.onTapGesture {
                            appNavigation.stockNavigation.append(StockViewRoute.stockDetail(sym: value.the1Symbol))
                        }
                    }
                }
            case .loading:
                ProgressView()
            case .loaded(let data):
                List(data.bestMatches, id: \.self) { stock in
                    HStack {
                        VStack {
                            Text(stock.the1Symbol)
                                .padding(.bottom, 4)
                            Text(stock.the2Name)
                        }.onTapGesture {
                            appNavigation.stockNavigation.append(StockViewRoute.stockDetail(sym: stock.the1Symbol))
                        }
                        Spacer()
                        Button {
                            if let index = localBestMatch.firstIndex(where: { $0.the1Symbol == stock.the1Symbol }) {
                                modelContext.delete(localBestMatch[index])
                            } else {
                                modelContext.insert(stock)
                            }
                        } label: {
                            Image(systemName: localBestMatch.contains(where: { $0.the1Symbol == stock.the1Symbol }) ? "heart.fill" : "heart")
                        }
                    }
                }
            case .error(let error):
                Text(error)
            }
        }
        .searchable(text: $stockViewModel.searchSymbol, prompt: "Search Stock")
        .navigationTitle("Symbol")
        .onChange(of: stockViewModel.searchSymbol, initial: false) { oldValue, newValue in
            self.task?.cancel()
            self.task = Task {
                await stockViewModel.getSearchStock()
            }
        }
    }
}

#Preview {
    NavigationStack {
        StockView()
    }
}
