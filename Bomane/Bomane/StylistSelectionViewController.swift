//
//  StylistSelectionViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-12-25.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit

class StylistSelectionViewController: UIViewController {
    
    private var titleLabel = UILabel()
    var closeButton:UIButton!
    var applyButton:UIButton!
    var tableView:UITableView!
    
    var stylists:[String] = ["Stephanie","Jane","Erica","Monica","Andrea","Susan","Debbie","Kelly"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpNavBar()
        setUpApplyButton()
        setUpTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpNavBar() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        
        let constraints:[NSLayoutConstraint] = [
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        titleLabel.text = "STYLISTS"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Baskerville", size: 20)!
        
        closeButton.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
        
    }
    
    func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let constraints:[NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        tableView.register(AppoitmentTableViewCell.self)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = UIColor.clear
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func setUpApplyButton() {
        applyButton = UIButton()
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(applyButton)
        
        let constraints:[NSLayoutConstraint] = [
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            applyButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        applyButton.setTitle("Apply", for: .normal)
        applyButton.backgroundColor = UIColor.black
        applyButton.setTitleColor(UIColor(red:210/255,green:186/255,blue:162/255,alpha:1), for: .normal)
        applyButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        applyButton.addTarget(self, action: #selector(self.applyButtonPressed(sender:)), for: .touchUpInside)
    }
    
    func applyButtonPressed(sender: UIButton) {
        
    }
    
}

extension StylistSelectionViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stylists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AppoitmentTableViewCell
        cell.serviceLabel.text = stylists[indexPath.row]
        return cell
    }
}

extension StylistSelectionViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row")
    }
}
