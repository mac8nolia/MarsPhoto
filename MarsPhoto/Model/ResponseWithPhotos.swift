//
//  ResponseWithPhotos.swift
//  MarsPhoto
//
//  Created by Ольга on 19.02.2021.
//

struct ResponseWithPhotos: Decodable {
    
    let photos: [Photo]
    
    private enum CodingKeys: String, CodingKey {
        case photos = "photos"
    }
}
