//
//  StockDetailView.swift
//  StockViewer
//
//  Created by Alpay Ozer on 29/10/2024.
//

import SwiftUI
import Charts

struct StockDetailView: View {
    
    @State private var stockDetailViewModel: StockDetailViewModel = StockDetailViewModel(stockService: StockService())
    
    var sym: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            switch stockDetailViewModel.stockDetailState {
            case .Initial:
                ProgressView()
            case .Loading:
                ProgressView()
            case .Loaded(let data, let previousClose):
                Chart {
                    ForEach(data.results) { value in
                        LineMark(
                            x: .value("Shape Type", value.customDate),
                            y: .value("Total Count", value.c)
                        ).foregroundStyle(.blue)
                        
                        AreaMark(x: .value("x", value.customDate), yStart: .value("start", data.results.map{$0.c}.min()!), yEnd: .value("end", value.c)).foregroundStyle(.blue.opacity(0.2))
                    }
                }.clipShape(Rectangle()).chartYScale(domain: data.results.map{$0.c}.min()! ... (data.results.map{$0.c}.max()!)).frame(height: 350)
                
                Spacer().frame(height: 10)
                VStack(alignment: .center) {
                    Text("High: \(previousClose.results.first!.h)")
                    Text("Low: \(previousClose.results.first!.l)")
                    Text("Open: \(previousClose.results.first!.o)")
                    Text("Close: \(previousClose.results.first!.c)")
                    Text("Volume: \(previousClose.results.first!.v)")
                    Divider().frame(height: 2).background(Color.black).padding(.bottom)
                    Text("\(Date(timeIntervalSince1970: Double((previousClose.results.first!.t)/1000)))").multilineTextAlignment(.center)
                }.font(.subheadline).fontWeight(.semibold).padding()
                
                Spacer()
            case .error(let error):
                Text(error)
            }
        }.navigationTitle(sym).task {
            await stockDetailViewModel.getStockDetail(ticker: sym)
        }
    }
}

#Preview {
    NavigationStack {
        StockDetailView(sym: "GOOG")
    }
}
