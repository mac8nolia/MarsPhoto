//
//  Manifest.swift
//  MarsPhoto
//
//  Created by Ольга on 19.02.2021.
//

import Foundation

struct Manifest: Decodable {
    
//    let daysCount: Int
    let days: [Day]
    
    private enum CodingKeys: String, CodingKey {
//        case daysCount = "max_sol"
        case days = "photos"
    }
}
