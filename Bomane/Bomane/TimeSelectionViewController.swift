//
//  TimeSelectionViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-12-25.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit
import SwifterSwift

class TimeSelectionViewController: UIViewController {
    
    weak var delegate:TimeSelectionDelegate?
    private var titleLabel = UILabel()
    var closeButton:UIButton!
    var applyButton:UIButton!
    var titleText:String!
    var bottomConstraint:NSLayoutConstraint!
    var tableView:UITableView!
    var containerView:UIView!
    var backgroundView:UIView!
    
    var previouslySelectedIndexPath:IndexPath?
    
    var stylist:Stylist?
    var service:Service?
    var selectedDate:Date?
    var selectedTimeSlot:TimeSlot?
    var token:String?
    
    var times:[TimeSlot] = []
    var activityIndicator:UIActivityIndicatorView!
    
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
            fetchTimeSlotsWithoutUser()
            return
        }
        fetchTimeSlots()
        
        
    }
    
    func fetchTimeSlotsWithoutUser() {
        guard let sty = stylist, let serv = service, let date = selectedDate, let tok = self.token else {return}
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
        NetworkController.shared.getAvailableTimeslotsAsGuest(stylist: sty, service: serv,token:tok, date: date) {
            optionalTimes in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard let times = optionalTimes else {return}
            self.times = times
            self.tableView.reloadData()
            
        }
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
    
    func fetchTimeSlots() {
        
        guard let sty = stylist, let serv = service, let date = selectedDate else {return}
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        activityIndicator.startAnimating()
        NetworkController.shared.getAvailableTimeslots(stylist: sty, service: serv, date: date) {
            optionalTimes in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard let times = optionalTimes else {return}
            self.times = times
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
        
        titleLabel.text = titleText ?? "AVAILABLE TIMES"
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
        guard let serv = self.selectedTimeSlot else {
            self.showErrorAlert(title: "Select a time", body: "Please select a time to continue.")
            return
        }
        delegate?.getTimeSelection(time:serv)
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

extension TimeSelectionViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if times.isEmpty {
            return 1
        }
        
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if times.isEmpty {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No available times"
            cell.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AppoitmentTableViewCell
        if let date = times[indexPath.row].startDate {
            cell.serviceLabel.text = date.timeString(ofStyle: .short)
        }
        if let serv = self.selectedTimeSlot, serv.startDate == self.times[indexPath.row].startDate {
            cell.configure(sender: true)
        } else {
            cell.configure(sender: false)
        }
        return cell
    }
}

extension TimeSelectionViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if times.isEmpty {
            return
        }
        
        if let lastIndexPath = previouslySelectedIndexPath,let previousCell = tableView.cellForRow(at: lastIndexPath) as? AppoitmentTableViewCell {
            previousCell.configure(sender: false)
        }
        let cell = tableView.cellForRow(at: indexPath) as! AppoitmentTableViewCell
        cell.configure(sender: true)
        previouslySelectedIndexPath = indexPath
        selectedTimeSlot = self.times[indexPath.row]
    }
}

protocol TimeSelectionDelegate : class {
    func getTimeSelection(time:TimeSlot)
}
