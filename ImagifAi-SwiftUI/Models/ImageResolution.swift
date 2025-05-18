//
//  ImageResolution.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 18/12/24.
//

import Foundation

enum ImageResolution: CaseIterable {
    case small256x256
    case medium512x512
    case large1024x1024
    case portrait1024x1792
    case landscape1792x1024
    
    var string: String {
        switch self {
        case .small256x256:
            "256x256"
        case .medium512x512:
            "512x512"
        case .large1024x1024:
            "1024x1024"
        case .portrait1024x1792:
            "1024x1792"
        case .landscape1792x1024:
            "1792x1024"
        }
    }
    
    var size: CGSize {
        switch self {
        case .small256x256:
            CGSize(width: 256, height: 256)
        case .medium512x512:
            CGSize(width: 512, height: 512)
        case .large1024x1024:
            CGSize(width: 1024, height: 1024)
        case .portrait1024x1792:
            CGSize(width: 1024, height: 1792)
        case .landscape1792x1024:
            CGSize(width: 1792, height: 1024)
        }
    }
}
