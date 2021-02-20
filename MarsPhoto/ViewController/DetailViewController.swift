//
//  DetailViewController.swift
//  MarsPhoto
//
//  Created by Ольга on 18.02.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    /**
     Link of photo that should be opened
     */
    var link: String!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create web view for viewing of photo
        let webView = WKWebView(frame: CGRect.zero)

        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        guard let url = URL(string: link) else { return }
        let request = URLRequest(url: url as URL)
        webView.load(request)
    }
}
