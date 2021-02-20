//
//  Manifest.swift
//  MarsPhoto
//
//  Created by Ольга on 19.02.2021.
//

struct Manifest: Decodable {
    
    let days: [Day]
    
    private enum CodingKeys: String, CodingKey {
        case days = "photos"
    }
}
