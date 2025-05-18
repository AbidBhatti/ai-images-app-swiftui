//
//  ContentView.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 14/12/24.
//

import SwiftUI

struct ContentView: View {
            
    var body: some View {
        TabView {
            Tab(Tabs.generate.title, systemImage: Tabs.generate.icon) {
                GenerateImageView()
            }
            
            Tab(Tabs.collection.title, systemImage: Tabs.collection.icon) {
                GenerationsCollectionView()
            }
        }
        .onAppear {
            setupTabBarAppearance()
            setupNavBarAppearance()
        }
    }
}

extension ContentView {
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private func setupNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
}
