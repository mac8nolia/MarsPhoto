//
//  DetailViewController.swift
//  MarsPhoto
//
//  Created by Ольга on 18.02.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, UIWebViewDelegate, WKNavigationDelegate {
    
    var link: String! // optional???
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        view.backgroundColor = .black
        
        

            let myWebView: WKWebView = WKWebView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height))
        myWebView.isOpaque = false
        myWebView.backgroundColor = .black
        self.view.addSubview(myWebView)
        myWebView.navigationDelegate = self

//        myWebView.loadHTMLString("<html><body><p>Hello!</p></body></html>", baseURL: nil)
        
        myWebView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            myWebView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            myWebView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
            
            
            let url = URL (string: link);
            let request = URLRequest(url: url! as URL);
        myWebView.load(request);
//        myWebView.loadHTMLString(link, baseURL: nil)
        webView = myWebView
       

        }


}
