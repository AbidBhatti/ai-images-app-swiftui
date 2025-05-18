//
//  Tabs.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 15/12/24.
//

import Foundation


enum Tabs {
    case generate
    case collection
    
    var title: String {
        switch self {
        case .generate:
            "Generate"
        case .collection:
            "Collection"
        }
    }
    
    var icon: String {
        switch self {
        case .generate:
            "wand.and.sparkles"
        case .collection:
            "photo.stack"
        }
    }
}
