//
//  StylistSelectionViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-12-25.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit

class StylistSelectionViewController: UIViewController {
    
    weak var delegate:StylistSelectionDelegate?
    private var titleLabel = UILabel()
    var closeButton:UIButton!
    var applyButton:UIButton!
    var titleText:String!
    var bottomConstraint:NSLayoutConstraint!
    var tableView:UITableView!
    var containerView:UIView!
    var backgroundView:UIView!
    
    var previouslySelectedIndexPath:IndexPath?
    var activityIndicator:UIActivityIndicatorView!
    
    var selectedStylist:Stylist?
    var stylists:[Stylist] = []
    var token:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setUpBGView()
        setUpHolderView()
        setUpNavBar()
        setUpApplyButton()
        setUpTableView()
        setUpActivityIndicator()
        
        guard DatabaseController.shared.loadUser() != nil else {
            fetchStylistsWithoutUser()
            return
        }
        fetchStylists()
    }
    
    func setUpActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        let const:[NSLayoutConstraint] = [
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(const)
    }
    
    func fetchStylistsWithoutUser() {
        guard let tok = self.token else {return}
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
        NetworkController.shared.getEmployeesAsGuest(token: tok) {
            optionalStylists in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let theStylists = optionalStylists else {return}
            self.stylists = theStylists
            self.tableView.reloadData()
            
        }
    }
    
    func fetchStylists() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
        NetworkController.shared.getEmployees() {
            optionalStylists in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let theStylists = optionalStylists else {return}
            self.stylists = theStylists
            self.tableView.reloadData()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpBGView() {
        backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        let cons:[NSLayoutConstraint] = [
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ]
        NSLayoutConstraint.activate(cons)
        
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0
    }
    
    func setUpHolderView() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        let height = self.view.frame.size.height
        
        bottomConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: height)
        bottomConstraint.isActive = true
        
        let constraints:[NSLayoutConstraint] = [
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9)
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
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        titleLabel.text = "STYLISTS"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Baskerville", size: 20)!
        
        closeButton.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        closeButton.addTarget(self, action: #selector(self.closeButtonPressed), for: .touchUpInside)
        
        closeButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        
        
        
    }
    
    func closeButtonPressed() {
        self.dismissView()
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
        tableView.estimatedRowHeight = 65.0
        
    }
    
    func setUpApplyButton() {
        applyButton = UIButton()
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(applyButton)
        
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
        guard let sty = self.selectedStylist else {
            self.showErrorAlert(title: "Select a stylist", body: "Please select a stylist to continue.")
            return
        }
        delegate?.getStylistSelection(stylist: sty)
        self.dismissView()
    }
    
    func dismissView() {
        animateBackground(presented: false)
    }
    
    func animateStack(presented: Bool) {
        if presented {
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.bottomConstraint.constant = self.view.frame.size.height
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: [], animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func animateBackground(presented: Bool) {
        if presented {
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundView.alpha = 0.75
            }, completion: { _ in
                self.animateStack(presented: true)
            })
        } else {
            self.animateStack(presented: false)
            UIView.animate(withDuration: 0.3, delay: 0.15,animations: {
                self.backgroundView.alpha = 0
            }, completion:nil)
        }
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
        cell.serviceLabel.text = stylists[indexPath.row].firstName + " " + stylists[indexPath.row].lastName
        if let serv = self.selectedStylist, serv.id == self.stylists[indexPath.row].id {
            cell.configure(sender: true)
        } else {
            cell.configure(sender: false)
        }
        return cell
    }
    
}

extension StylistSelectionViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lastIndexPath = previouslySelectedIndexPath,let previousCell = tableView.cellForRow(at: lastIndexPath) as? AppoitmentTableViewCell {
            previousCell.configure(sender: false)
        }
        let cell = tableView.cellForRow(at: indexPath) as! AppoitmentTableViewCell
        cell.configure(sender: true)
        previouslySelectedIndexPath = indexPath
        selectedStylist = self.stylists[indexPath.row]
    }
}

protocol StylistSelectionDelegate : class {
    func getStylistSelection(stylist:Stylist)
}

