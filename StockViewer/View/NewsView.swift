//
//  NewsView.swift
//  StockViewer
//
//  Created by Alpay Ozer on 31/10/2024.
//

import SwiftUI

struct NewsView: View {
    @State private var newsViewModel = NewsViewModel(stockService: StockService())
    
    var body: some View {
        VStack {
            switch newsViewModel.newsViewState {
            case .initial:
                ProgressView()
            case .loading:
                ProgressView()
            case .loaded(let data):
                if let feed = data.feed {
                    List(feed, id: \.timePublished) { feedItem in
                        
                        if let urlString = feedItem.url, let url = URL(string: urlString) {
                            Link(destination: url) {
                                VStack(alignment: .leading) {
                                    if let bannerImageUrl = feedItem.bannerImage,
                                       let imageUrl = URL(string: bannerImageUrl) {
                                        AsyncImage(url: imageUrl) { image in
                                            image.resizable().frame(maxWidth: .infinity, maxHeight: 150)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                    Text(feedItem.title ?? "No title available")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                        .padding(.bottom, 6)
                                    
                                    Text(feedItem.summary ?? "No summary available")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .lineLimit(2)
                                }
                            }
                        } else {
                            Text("Invalid URL")
                        }
                    }.listStyle(.plain)
                } else {
                    Text("No news data available")
                }
            case .error(let error):
                Text(error)
            }
        }.navigationTitle("News").task {
            await newsViewModel.getNewsAndSentiment()
        }
    }
}

#Preview {
    NavigationStack {
        NewsView()
    }
}
