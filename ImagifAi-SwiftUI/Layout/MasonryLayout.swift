//
//  MasonryLayout.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 15/02/25.
//

import SwiftUI

struct MasonryLayout: Layout {
    let spacing: CGFloat
    let columns: Int
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        
        let width = proposal.width ?? 0
        let columnWidth = (width - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
        
        var columnHeights = Array(repeating: CGFloat.zero, count: columns)
        
        for (index, subview) in subviews.enumerated() {
            let columnIndex = index % columns
            let size = subview.sizeThatFits(.init(width: columnWidth, height: nil))
            // Always add spacing before the item (except for first row)
            if columnHeights[columnIndex] > 0 {
                columnHeights[columnIndex] += spacing
            }
            columnHeights[columnIndex] += size.height
        }
        
        return CGSize(width: width, height: columnHeights.max() ?? 0)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        
        let columnWidth = (bounds.width - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
        var columnHeights = Array(repeating: CGFloat.zero, count: columns)
        
        for (index, subview) in subviews.enumerated() {
            let columnIndex = index % columns
            let xOffset = CGFloat(columnIndex) * (columnWidth + spacing)
            let size = subview.sizeThatFits(.init(width: columnWidth, height: nil))
            
            // Add spacing before placing the item (except for first row)
            if columnHeights[columnIndex] > 0 {
                columnHeights[columnIndex] += spacing
            }
            
            let yOffset = columnHeights[columnIndex]
            columnHeights[columnIndex] += size.height
            
            let point = CGPoint(x: bounds.minX + xOffset, y: bounds.minY + yOffset)
            subview.place(at: point, proposal: .init(width: columnWidth, height: size.height))
        }
    }
}
