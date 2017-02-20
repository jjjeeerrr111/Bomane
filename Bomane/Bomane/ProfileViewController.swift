//
//  ProfileViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-01-07.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
//    static let shared = ProfileViewController()

    @IBOutlet weak var addCreditCardButton: UIButton!
    @IBOutlet weak var creditCardLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user:User?
    var creditCard:CreditCard?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let aUser = DatabaseController.shared.loadUser() {
            self.user = aUser
            self.nameLabel.text = self.user!.firstName + " " + self.user!.lastName
            self.emailLabel.text = self.user!.email
        }
        
        checkCreditCard()
        
        setUpNavBar()

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkCreditCard), name: Notifications.kCreditCardAdded, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notifications.kCreditCardAdded, object: nil)
    }
    
    func checkCreditCard() {
        if let card = DatabaseController.shared.loadCard() {
            self.creditCard = card
            addCreditCardButton.isHidden = true
            creditCardLabel.isHidden = false
            creditCardLabel.text = "XXXX XXXX XXXX " + card.last4
        } else {
            addCreditCardButton.isHidden = false
            creditCardLabel.isHidden = true
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
        navigationItem.title = "ACCOUNT"
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
        let editVC = EditProfileViewController()
        editVC.delegate = self
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @IBAction func addCreditCardButtonPressed(_ sender: UIButton) {
        let addVC = AddCreditCardViewController()
        navigationController?.pushViewController(addVC, animated: true)
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

extension ProfileViewController:EditProfileDelegate {
    func updateProfile(name: String, email: String) {
        nameLabel.text = name
        emailLabel.text = email
    }
}
