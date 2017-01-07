//
//  ProfileViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-01-07.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    static let shared = ProfileViewController()

    @IBOutlet weak var addCreditCardButton: UIButton!
    @IBOutlet weak var creditCardLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        // Do any additional setup after loading the view.
        creditCardLabel.text = ""
        if (creditCardLabel.text?.isEmpty)! {
            creditCardLabel.isHidden = true
            addCreditCardButton.isHidden = false
        } else {
            creditCardLabel.isHidden = false
            addCreditCardButton.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont(name: "Baskerville", size: 20)!]
        navigationController?.navigationBar.isTranslucent = false
    }

    func setUpNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.title = "PROFILE"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont(name: "Baskerville", size: 20)!]
        navigationController?.navigationBar.isTranslucent = false
        
        //This line sets the back button title to "" so that it doesnt show up at < Messages when pushing
        //the next view controller
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburgerIcon"), style: .plain, target: self, action: #selector(self.menuButtonPressed(sender:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        let rightButton = UIBarButtonItem(title: "edit", style: .done, target: self, action: #selector(self.editButtonPressed(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont(name: "AvenirNext-Regular", size: 15)!], for: .normal)
        
    }
    
    func editButtonPressed(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func addCreditCardButtonPressed(_ sender: UIButton) {
        print("add credit card button pressed")
    }
    
    func menuButtonPressed(sender: UIBarButtonItem) {
        let menu = ScreenMenuViewController.shared
        let navVC = UINavigationController(rootViewController: menu)
        navVC.transitioningDelegate = self
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    

    @IBAction func bookedAppointmentButtonPressed(_ sender: UIButton) {
        AppDelegate.shared().initWindow(controller: "Book Appointment")
    }

}

extension ProfileViewController:UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SlideAnimator()
        animator.presenting = false
        return animator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimator()
    }
}
