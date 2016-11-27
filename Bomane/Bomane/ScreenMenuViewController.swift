//
//  ScreenMenuViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-11-27.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit

class ScreenMenuViewController: UIViewController {
    
    var closeButton:UIButton!
    var tableView:UITableView!
    var logOutButton:UIButton!
    
    var menuTitles:[String] = ["Book Appointment","Services","Portfolio","Profile","Contact","Pay"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        setUpNavBar()
        setUpLogOutButton()
        setUpTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpLogOutButton() {
        logOutButton = UIButton()
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        
        let constraints:[NSLayoutConstraint] = [
            logOutButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            logOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logOutButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(constraints)
        
        logOutButton.setTitle("Log out", for: .normal)
        logOutButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        logOutButton.contentHorizontalAlignment = .left
        logOutButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        logOutButton.addTarget(self, action: #selector(self.logOutButtonPressed(sender:)), for: .touchUpInside)
        
    }
    
    func logOutButtonPressed(sender: UIButton) {
        AppDelegate.shared().showLogin()
    }
    
    func setUpNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationItem.title = "B Ō M A N E"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:UIFont(name: "Baskerville", size: 20)!]
        navigationController?.navigationBar.isTranslucent = false
        
        //This line sets the back button title to "" so that it doesnt show up at < Messages when pushing
        //the next view controller
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "closeIcon"), style: .plain, target: self, action: #selector(self.closeButtonPressed(sender:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
    }
    
    func closeButtonPressed(sender: UIBarButtonItem) {
        print("close pressed")
    }
    
    func setUpTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let constraints:[NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: logOutButton.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        tableView.register(MenuTableViewCell.self)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = .none
    }

}

extension ScreenMenuViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell selected")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension ScreenMenuViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MenuTableViewCell
        cell.titleLabel.text = menuTitles[indexPath.row]
        return cell
    }
}
