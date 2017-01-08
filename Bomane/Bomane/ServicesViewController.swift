//
//  ServicesViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-11-27.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit

class ServicesViewController: UIViewController {
    
    static let shared = ServicesViewController()
    
    var tableView:UITableView!
    var bookButton:UIButton!
    
    var services:[Service] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpServices()
        setUpNavBar()
        setUpBookButton()
        setUpTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont(name: "Baskerville", size: 20)!]
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setUpServices() {
        for _ in 0...3 {
            let sub = "Aenean sagittis porttitor dolor,ac pretium eros tincidunt suscipit. Nunc ultrices arcu vel muris egestas mattis. Fusce metus velit, auctor sit amet ullamcorper in, vehicula ut nibh. Duis ut urna nulla. Sed eu luctus leo. Proin ut odio volutpat risus."
            let nam = "Haircut"
            let service = Service(name: nam, description: sub)
            services.append(service)
        }
    }
    
    func setUpBookButton() {
        bookButton = UIButton()
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bookButton)
        
        let constraints:[NSLayoutConstraint] = [
            bookButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            bookButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookButton.heightAnchor.constraint(equalToConstant: 55)
        ]
        NSLayoutConstraint.activate(constraints)
        
        bookButton.setTitle("Book Appointment", for: .normal)
        let champagne = UIColor(red: 207/255, green: 186/255, blue: 162/255, alpha: 1)
        bookButton.setTitleColor(champagne, for: .normal)
        bookButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        bookButton.addTarget(self, action: #selector(self.bookButtonPressed(sender:)), for: .touchUpInside)
        bookButton.backgroundColor = UIColor.black
        
    }
    
    func bookButtonPressed(sender: UIButton) {
       AppDelegate.shared().initWindow(controller: "Book Appointment")
    }
    
    func setUpNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.title = "SERVICES"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont(name: "Baskerville", size: 20)!]
        navigationController?.navigationBar.isTranslucent = false
        
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
    
    func setUpTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let constraints:[NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bookButton.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        tableView.register(ServicesTableViewCell.self)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 88.0
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
    }


}

extension ServicesViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell selected")
    }
}

extension ServicesViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ServicesTableViewCell
        cell.titleLabel.text = services[indexPath.row].name
        cell.subtitleLabel.text = services[indexPath.row].description
        return cell
    }
}

extension ServicesViewController:UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SlideAnimator()
        animator.presenting = false
        return animator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimator()
    }
}


