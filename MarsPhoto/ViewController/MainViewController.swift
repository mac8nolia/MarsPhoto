//
//  MainViewController.swift
//  MarsPhoto
//
//  Created by Ольга on 17.02.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    /**
     Collection view for photos
     */
    var collectionView: UICollectionView!
    
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
        layout.minimumLineSpacing = 15
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
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.backgroundColor = .black
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAction))
        navigationItem.rightBarButtonItem = refreshButton
        self.refreshButton = refreshButton
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        loadPhotos()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
}
    
// MARK: - Collection View Data Source

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)) as! PhotoViewCell
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

// MARK: - Collection View Delegate Flow Layout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let photo = photos[indexPath.row]
        
        // If photo is widescreen - place one photo (cell) in a row, else place two photos in a row
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
     Loads random photos and refresh interface after.
     Shows activity indicator while photos are loading.
     */
    func loadPhotos() {
        activityIndicator.startAnimating()
        NetworkService.shared.getRandomPhotosWith(numberOfPhotos: numberOfPhotos) { (photos) in
            self.photos = self.mix(photos: photos)
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
            self.refreshButton.isEnabled = true
        }
    }
    
    /**
     Shuffles photos so as to alternate one widescreen photo and two non-widescreen photos for subsequent displaying in the collection view
     */
    func mix(photos: [Photo]) -> [Photo] {
        var squarePhotos = [Photo]()
        var widescreenPhotos = [Photo]()
        
        // Separate photos into two arrays - widescreen and non-widescreen
        photos.forEach {
            $0.isWidescreen ? widescreenPhotos.append($0) : squarePhotos.append($0)
        }
        
        // Create result array based on array with non-widescreen photos
        var mixPhotos = squarePhotos
        
        // Calculate minimal possible number of times of adding widescreen photo to array with non-widescreen photos
        let count1 = (squarePhotos.count - 1) / 2
        let count2 = widescreenPhotos.count
        var minCount = min(count1, count2)
        
        // First possible index of array with non-widescreen photos where can be added first widescreen photo
        var index = 2
        
        // Transfer photos from one array to another.
        // Put each widescreen photo after two non-widescreen photos.
        while minCount > 0 {
            mixPhotos.insert(widescreenPhotos.first!, at: index)
            widescreenPhotos.removeFirst()
            minCount -= 1
            index += 3
        }
        
        // If there are elements in the array with widescreen photos, put them at the end of result array
        mixPhotos += widescreenPhotos
        
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
