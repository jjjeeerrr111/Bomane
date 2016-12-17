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
        
        setUpNavBar()

    }

    func setUpNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setUpNavBar()
//    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        print("create pressed")
    }

    @IBAction func facebookButtonPressed(_ sender: UIButton) {
        print("facebook pressed")
    }
}
