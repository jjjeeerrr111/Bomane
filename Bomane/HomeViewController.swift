//
//  HomeViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-03-05.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var portfolioView: UIView!
    @IBOutlet weak var callView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        // Do any additional setup after loading the view.
        callView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        portfolioView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    func setUpNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //This line sets the back button title to "" so that it doesnt show up at < Messages when pushing
        //the next view controller
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburgerIcon"), style: .plain, target: self, action: #selector(self.menuButtonPressed(sender:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
    }
    
    func menuButtonPressed(sender: UIBarButtonItem) {
        let menu = ScreenMenuViewController.shared
        let navVC = UINavigationController(rootViewController: menu)
        navVC.transitioningDelegate = self
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func bookAppointmentPressed(_ sender: UIButton) {
        AppDelegate.shared().initWindow(controller: "Book Appointment")
    }

    @IBAction func portfolioButtonPressed(_ sender: UIButton) {
        AppDelegate.shared().initWindow(controller: "Portfolio")
    }

    @IBAction func callButtonPressed(_ sender: UIButton) {
        //dont have the number to call
        if let url = URL(string:"tel://4247770638"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension HomeViewController:UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SlideAnimator()
        animator.presenting = false
        return animator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimator()
    }
}
