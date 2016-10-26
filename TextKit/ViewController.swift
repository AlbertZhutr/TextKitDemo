//
//  ViewController.swift
//  TextKit
//
//  Created by Albert Zhu on 16/10/26.
//  Copyright © 2016年 Albert Zhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AZLabelDelegate {
    @IBOutlet weak var label: AZLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.delegate = self
        
//        label.text = "https://www.sina.cn"
    }

    func didSelectUrl(urlString: String?) {
        print(urlString)
        
        let vc = WebViewController()
        vc.urlString = urlString
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

