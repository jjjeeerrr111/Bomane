//
//  SignUpViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-11-27.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit
import WebKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountButton.contentHorizontalAlignment = .left
        createAccountButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        
        setUpNavBar()

    }

    @IBAction func termsOfServicePressed(_ sender: UIButton) {
        
        if let pdf = Bundle.main.url(forResource: "BomaneTerms", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let vc = FileViewController()
            vc.url = pdf
            self.present(vc, animated: true, completion: nil)
        } else {
            print("cannot find terms")
        }
        
    }
    
    
    @IBAction func privacyPolicyPressed(_ sender: UIButton) {
        if let pdf = Bundle.main.url(forResource: "BomanePrivacy", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let vc = FileViewController()
            vc.url = pdf
            self.present(vc, animated: true, completion: nil)
        } else {
            print("cannot find privacy")
        }
    }
    
    func setUpNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        let createVC = CreateAccountNameViewController()
        navigationController?.pushViewController(createVC, animated: true)
    }
}
