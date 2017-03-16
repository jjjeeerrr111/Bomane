//
//  FileViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-03-16.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import UIKit

class FileViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var url:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let request = URLRequest(url: url)
        self.webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    

}
