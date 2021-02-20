//
//  Photo.swift
//  MarsPhoto
//
//  Created by Ольга on 19.02.2021.
//

import UIKit

struct Photo: Decodable {
    
    let link: String
    
    var image: UIImage!
    
    var isWidescreen: Bool {
        if (image.size.width / image.size.height) > 1.4 {
            return true
        } else {
            print("Ratio = \(image.size.width / image.size.height)")
            return false
        }
    }
    
    init(link: String) {
        self.link = link
    }
    
    private enum CodingKeys: String, CodingKey {
        case link = "img_src"
    }
}
