//
//  SettingsView.swift
//  StockViewer
//
//  Created by Alpay Ozer on 25/12/2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode).onChange(of: isDarkMode) {
                        updateAppAppearance(isDarkMode: isDarkMode)
                    }
                }
            }.navigationTitle("Settings").onAppear {
                updateAppAppearance(isDarkMode: isDarkMode)
            }
        }
    }
    
    private func updateAppAppearance(isDarkMode: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark: .light
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().preferredColorScheme(.light)
    }
}

