//
//  WebViewController.swift
//  TextKit
//
//  Created by Albert Zhu on 16/10/26.
//  Copyright © 2016年 Albert Zhu. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    lazy var webView = UIWebView(frame: UIScreen.main.bounds)
    
    var urlString: String? {
        didSet {
            guard let urlStr = urlString,
                let url = URL(string: urlStr)
            else {return}
            
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
    }
}
