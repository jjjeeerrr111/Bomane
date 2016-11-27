//
//  SignUpViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-11-27.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountButton.contentHorizontalAlignment = .left
        facebookButton.contentHorizontalAlignment = .left
        createAccountButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        facebookButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print("login pressed")
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        print("create pressed")
    }

    @IBAction func facebookButtonPressed(_ sender: UIButton) {
        print("facebook pressed")
    }
}
