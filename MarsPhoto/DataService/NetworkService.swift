//
//  NetworkService.swift
//  MarsPhoto
//
//  Created by Ольга on 17.02.2021.
//

import UIKit

class NetworkService {
    
    static let shared = NetworkService()
    
    /**
     Query's part for manifest of curiosity rover
     */
    let queryForManifest = "https://api.nasa.gov/mars-photos/api/v1/manifests/Curiosity?api_key="
    
    /**
     Query's part for photos of curiosity rover
     */
    let queryForPhotos = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol="
    
    /**
     Author's API key. You can generate another key here: https://api.nasa.gov/
     */
    let token = "1CE6j9n7suRe1xUBcVhIedJUB6YRZfENn0TzAN9h"
    
    /**
     Returns given number of random photos
     */
    func getRandomPhotosWith(numberOfPhotos: Int, completion: @escaping ([Photo]) -> ()) {

        let urlString = queryForManifest + token
        guard let url = URL(string: urlString) else { return }
        var photos = [Photo]()
        
        // Query for rover's manifest, which contains info about all worked days
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(ResponseWithManifest.self, from: data)
                let days = response.manifest.days
                
                // Create dispatch group to wait for the completion of all tasks of getting each random photo
                let group = DispatchGroup()
                
                // Select random days and get a random photo of each day
                for _ in 1...numberOfPhotos {
                    let randomInt = Int.random(in: 0..<days.count)
                    let randomDay = days[randomInt]
                    group.enter()
                    self.getRandomPhotoOf(day: randomDay) { (photo) in
                        photos.append(photo)
                        group.leave()
                    }
                }
                group.notify(queue: DispatchQueue.main) {
                    completion(photos)
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    /**
     Returns a random photo of the given day
     */
    func getRandomPhotoOf(day: Day, completion: @escaping (Photo) -> ()) {
        
        let urlString = queryForPhotos + String(day.dayNumber) + "&api_key=" + token
        guard let url = URL(string: urlString) else { return }
        
        // Query for all photos of the day
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(ResponseWithPhotos.self, from: data)
                
                // Choose random photo
                let randomInt = Int.random(in: 0..<day.numberOfPhotos)
                var randomPhoto = response.photos[randomInt]
                
                // Get image of the photo
                self.getImageWith(link: randomPhoto.link) { (image) in
                    randomPhoto.image = image
                    completion(randomPhoto)
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    /**
     Returns image for given link
     */
    func getImageWith(link: String, completion: @escaping (UIImage) -> ()) {
        
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            completion(image)
        }.resume()
    }
}
