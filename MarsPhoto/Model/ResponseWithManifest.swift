//
//  ResponseWithManifest.swift
//  MarsPhoto
//
//  Created by Ольга on 19.02.2021.
//

import Foundation

struct ResponseWithManifest: Decodable {
    
    let manifest: Manifest
    
    private enum CodingKeys: String, CodingKey {
        case manifest = "photo_manifest"
    }
}
