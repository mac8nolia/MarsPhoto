//
//  MainViewController.swift
//  MarsPhoto
//
//  Created by Ольга on 17.02.2021.
//

import UIKit

class MainViewController: UIViewController {

    weak var collectionView: UICollectionView!
    
    /**
     Loaded from server photos
     */
    var photos = [Photo]()
    
    /**
     Number of loaded photos
     */
    let numberOfPhotos = 16
    
    /**
     Button for refresh of photos
     */
    var refreshButton: UIBarButtonItem!
    
    /**
     Indicator that activates when photos are uploaded
     */
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

    // MARK: - View controller life cycle
    
    override func loadView() {
        super.loadView()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: collectionView.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
        ])
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .red
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.backgroundColor = .black
//        self.view.addSubview(collectionView)
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAction))
        self.navigationItem.rightBarButtonItem = refreshButton
        self.refreshButton = refreshButton
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        loadPhotos()
    }
    
//    override func viewWillLayoutSubviews() {
//        print("viewWillLayoutSubviews")
//        super.viewWillLayoutSubviews()
//        collectionView.collectionViewLayout.invalidateLayout()
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("viewWillTransition")
        super.viewWillTransition(to: size, with: coordinator)
//        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
}
    
// MARK: - Collection View Data Source

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection = \(self.photos.count)")
        return self.photos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt \(indexPath.row)")
        
//        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
//        myCell.backgroundColor = .clear
//        myCell.subviews.forEach {
//            $0.removeFromSuperview()
//        }
//        let imView = UIImageView(frame: CGRect(x:0, y:0, width:myCell.frame.size.width, height:myCell.frame.size.height))
//        imView.backgroundColor = .clear
//        DispatchQueue.main.async(execute: { () -> Void in
//            imView.image = self.photos[indexPath.row].image
//            imView.contentMode = .scaleAspectFit
//        })
//        myCell.addSubview(imView)
//        return myCell
        
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)) as! PhotoViewCell
//        DispatchQueue.main.async(execute: { () -> Void in
//            cell.imageView.image = self.photos[indexPath.row].image
//        })
        DispatchQueue.main.async {
            cell.imageView.image = self.photos[indexPath.row].image
        }
        return cell
    }
}

// MARK: - Collection View Delegate

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.link = photos[indexPath.row].link
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("sizeForItemAt \(indexPath.row)")
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let photo = photos[indexPath.row]
        
        if photo.isWidescreen {
            let cellWidth = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right))
                        return CGSize(width: cellWidth, height: cellWidth / 2)
            
            
        } else {
            let cellWidth = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right) - flowLayout.minimumInteritemSpacing) / 2
                        return CGSize(width: cellWidth, height: cellWidth)
        }
    }
}

// MARK: - Load Data

extension MainViewController {
    
    /**
     
     */
    func loadPhotos() {
        let startingPoint = Date()
        activityIndicator.startAnimating()
        
//        NetworkService.shared.getRandomPhotosWith(numberOfPhotos: numberOfPhotos) { (photos) in
//                print("LOADED")
//            self.photos = self.mix(photos: photos)
//                self.collectionView.reloadData()
//                print("\(startingPoint.timeIntervalSinceNow * -1) seconds elapsed")
//            self.activityIndicator.stopAnimating()
//            self.refreshButton.isEnabled = true
//        }
        
        NetworkService.shared.testGetRandomPhotosWith { (photos) in
            print("LOADED")
            self.photos = self.mix(photos: photos)
            self.collectionView.reloadData()
            print("\(startingPoint.timeIntervalSinceNow * -1) seconds elapsed")
            self.activityIndicator.stopAnimating()
            self.refreshButton.isEnabled = true
        }
    }
    
    /**
     
     */
    func mix(photos: [Photo]) -> [Photo] {
        var squarePhotos = [Photo]()
        var rectanglePhotos = [Photo]()
        
        photos.forEach {
            if $0.isWidescreen {
                rectanglePhotos.append($0)
                
            } else {
                
                squarePhotos.append($0)
            }
        }

        let count1 = (squarePhotos.count - 1) / 2
        let count2 = rectanglePhotos.count
        var n = min(count1, count2)
        
        var mixPhotos = squarePhotos
        
        var i = 2
        while n > 0 {
            mixPhotos.insert(rectanglePhotos.first!, at: i)
            rectanglePhotos.removeFirst()
            n -= 1
            i += 3
        }
        mixPhotos += rectanglePhotos
        
        return mixPhotos
    }
}

// MARK: - Action handlers

extension MainViewController {
    
    @objc func refreshAction() {
        refreshButton.isEnabled = false
        loadPhotos()
    }
}
