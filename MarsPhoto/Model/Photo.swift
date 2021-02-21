//
//  Photo.swift
//  MarsPhoto
//
//  Created by Ольга on 19.02.2021.
//

import UIKit

struct Photo: Decodable {
    
    let link: String
    
    private enum CodingKeys: String, CodingKey {
        case link = "img_src"
    }
    
    var image: UIImage?
    
    var isWidescreen: Bool {
        guard let image = image else { return false }
        if (image.size.width / image.size.height) > 1.4 {
            return true
        } else {
            return false
        }
    }
}
