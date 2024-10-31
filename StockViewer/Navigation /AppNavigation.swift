//
//  AppNavigation.swift
//  StockViewer
//
//  Created by Alpay Ozer on 28/10/2024.
//

import Foundation
import Combine
import SwiftUI

enum StockViewRoute: Hashable {
    case stockDetail(sym: String)
}

class AppNavigation: ObservableObject {
    @Published var stockNavigation = NavigationPath()
}
