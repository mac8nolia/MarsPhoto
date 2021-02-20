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
    func getRandomPhotosWith(numberOfPhotos: Int, completion: @escaping ([Photo]) -> ()) { // ???

        let urlString = queryForManifest + token
        guard let url = URL(string: urlString) else { return }
        
        var photos = [Photo]()
        
        // Query for rover's manifest, which contains info about all worked days
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(ResponseWithManifest.self, from: data)
//                let daysCount = response.manifest.daysCount
                let days = response.manifest.days
//                print("DAYS = \(days)")
                
                // Create dispatch group to wait for the completion of all tasks of getting each random photo
                let group = DispatchGroup()
//                let queue = DispatchQueue(label: "com.macnolia.queue", attributes: .concurrent)
                
                // Select random days and get a random photo of each day
                for _ in 1...numberOfPhotos {
//                    group.enter()
//                    queue.async {
                    let randomInt = Int.random(in: 0..<days.count)
                    let randomDay = days[randomInt]
//                    let dayNumber = randomDay.dayNumber
//                    let numberOfPhotos = randomDay.numberOfPhotos
//                    print("---------------")
//                    print("SOL = \(dayNumber)")
//                    print("TOTAL PHOTOS = \(randomDay.numberOfPhotos)")
//                    print(Thread.isMainThread)
                    group.enter()
                    self.getRandomPhotoOf(day: randomDay) { (photo) in
//                        print(Thread.isMainThread)
                        photos.append(photo)
                        group.leave()
                    }
                }
//                }
                group.notify(queue: DispatchQueue.main) {
//                    print("NOTIFY")
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
        
//        print("getRandomImageOnDay \(dayNumber)")
//        print(Thread.isMainThread)
        let urlString = queryForPhotos + String(day.dayNumber) + "&api_key=" + token
//        print(urlString)
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
//        print(link)
//        print(Thread.isMainThread)
        guard let url = URL(string: link) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            print(image.size) // ???
//            print(Thread.isMainThread)
            completion(image)
        }.resume()
    }
    
    func testGetRandomPhotosWith(completion: @escaping ([Photo]) -> ()) { // ???
        
        var photos = [Photo]()
        let group = DispatchGroup()
        
        let links = [
            "https://mars.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/02678/opgs/edr/fcam/FLB_635225853EDR_F0790000FHAZ00341M_.JPG",
            "http://mars.jpl.nasa.gov/msl-raw-images/msss/01614/mhli/1614MH0006550020602444I01_DXXX.jpg",
            "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01840/opgs/edr/rcam/RRB_560846102EDR_F0661332RHAZ00341M_.JPG",
            "http://mars.jpl.nasa.gov/msl-raw-images/msss/01698/mhli/1698MH0001520020604192I01_DXXX.jpg",
            "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/00954/opgs/edr/fcam/FRB_482197473EDR_F0460000FHAZ00206M_.JPG",
            "http://mars.jpl.nasa.gov/msl-raw-images/msss/01087/mcam/1087ML0047770880500117E01_DXXX.jpg",
            "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01045/opgs/edr/ncam/NRB_490270269EDR_M0482200NCAM00536M_.JPG",
            "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01672/opgs/edr/ncam/NLB_545928819EDR_F0621314NCAM00312M_.JPG",
            "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01999/opgs/edr/ccam/CR0_574948538EDR_F0682484CCAM01999M_.JPG",
            "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01636/opgs/edr/ncam/NRB_542734337EDR_F0612232NCAM00283M_.JPG",
            "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01851/opgs/edr/ncam/NRB_561824940EDR_M0661804NCAM00578M_.JPG",
            "http://mars.jpl.nasa.gov/msl-raw-images/msss/00938/mcam/0938ML0041190200402958I01_DXXX.jpg",
            "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/02050/soas/rdr/ccam/CR0_579481009PRC_F0701538CCAM05049L1.PNG",
            "http://mars.jpl.nasa.gov/msl-raw-images/msss/01675/mhli/1675MH0003210020603477I01_DXXX.jpg",
            "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01577/opgs/edr/ncam/NLB_537494400EDR_D0600552TRAV00531M_.JPG",
            "http://mars.jpl.nasa.gov/msl-raw-images/msss/00055/mcam/0055MR0002510100103068I01_DXXX.jpg",
            "https://mars.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/02486/opgs/edr/fcam/FLB_618182129EDR_S0763002FHAZ00214M_.JPG",
            "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01144/opgs/edr/ncam/NRB_499051008EDR_D0500676TRAV00381M_.JPG"
        ]
        
        links.forEach {
//            print($0)
            var photo = Photo(link: $0)
            group.enter()
            self.getImageWith(link: $0) { (image) in
                photo.image = image
                photos.append(photo)
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            completion(photos)
        }
    }
}
