//
//  TimeSelectionViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-12-25.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit

class TimeSelectionViewController: UIViewController {
    
    private var titleLabel = UILabel()
    var closeButton:UIButton!
    var applyButton:UIButton!
    var titleText:String!
    var tableView:UITableView!
    var containerView:UIView!
    
    var times:[String] = ["8:45-9:45am","10-11am","1:30-2:30pm","4:15-5:15pm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpBGView()
        setUpHolderView()
        setUpNavBar()
        setUpApplyButton()
        setUpTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpBGView() {
        let bg = UIView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bg)
        
        let cons:[NSLayoutConstraint] = [
            bg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bg.topAnchor.constraint(equalTo: view.topAnchor),
            bg.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ]
        NSLayoutConstraint.activate(cons)
        
        bg.backgroundColor = UIColor.black
        bg.alpha = 0.4
    }
    
    func setUpHolderView() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        let constraints:[NSLayoutConstraint] = [
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        containerView.backgroundColor = UIColor.white
    }
    
    
    func setUpNavBar() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(closeButton)
        
        
        let constraints:[NSLayoutConstraint] = [
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        titleLabel.text = titleText ?? "AVAILABLE TIMES"
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
        containerView.addSubview(tableView)
        
        let constraints:[NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
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
            applyButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            applyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            applyButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
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

extension TimeSelectionViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AppoitmentTableViewCell
        cell.serviceLabel.text = times[indexPath.row]
        return cell
    }
}

extension TimeSelectionViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row")
    }
}
