//
//  ImageResponse.swift
//  ImagifAi-SwiftUI
//
//  Created by Abid Bhatti on 19/01/25.
//

import Foundation

struct ImageResponse: Decodable {
    let created: Date
    let data: [ImageData]

    private enum CodingKeys: String, CodingKey {
        case created
        case data
    }
    
    private enum DateCodingKeys: CodingKey {
        case created
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let createdTimestamp = try container.decode(Int.self, forKey: .created)
        self.created = Date(timeIntervalSince1970: TimeInterval(createdTimestamp))
        
        self.data = try container.decode([ImageData].self, forKey: .data)
    }
}

struct ImageData: Decodable {
    let revisedPrompt: String?
    let url: String

    private enum CodingKeys: String, CodingKey {
        case revisedPrompt = "revised_prompt"
        case url
    }
}
