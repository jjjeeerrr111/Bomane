//
//  ProtfolioViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-12-18.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit

class ProtfolioViewController: UIViewController {
    
    static let shared = ProtfolioViewController()
    
    var activityIndicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        // Do any additional setup after loading the view.
        setUpUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont(name: "Baskerville", size: 20)!]
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setUpNavBar() {
        navigationItem.title = "PORTFOLIO"
        //This line sets the back button title to "" so that it doesnt show up at < Messages when pushing
        //the next view controller
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburgerIcon"), style: .plain, target: self, action: #selector(self.menuButtonPressed(sender:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    func menuButtonPressed(sender: UIBarButtonItem) {
        let menu = ScreenMenuViewController.shared
        let navVC = UINavigationController(rootViewController: menu)
        navVC.transitioningDelegate = self
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    func setUpUI() {
        let webview = UIWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webview)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        let constraints:[NSLayoutConstraint] = [
            webview.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            webview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webview.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        guard let url = URL(string: "https://instagram.com/Bomanesalon/") else {return}
       
        let request = URLRequest(url: url)
        webview.loadRequest(request)
        webview.delegate = self
        
    }
    
}

extension ProtfolioViewController:UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
    }
}

extension ProtfolioViewController:UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SlideAnimator()
        animator.presenting = false
        return animator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimator()
    }
}
