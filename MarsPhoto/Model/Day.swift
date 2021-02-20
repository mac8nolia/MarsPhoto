//
//  Day.swift
//  MarsPhoto
//
//  Created by Ольга on 19.02.2021.
//

import Foundation

struct Day: Decodable {
    
    let dayNumber: Int
    let numberOfPhotos: Int
    
    private enum CodingKeys: String, CodingKey {
        case dayNumber = "sol"
        case numberOfPhotos = "total_photos"
    }
}
