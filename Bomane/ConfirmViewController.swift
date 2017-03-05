//
//  ConfirmViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-02-05.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import UIKit
import PopupDialog

protocol ConfirmAppointmentDelegate:class {
    func confirmAppointment()
}

class ConfirmViewController: UIViewController {

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var addCreditCardLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var stylistLabel: UILabel!
    
    weak var delegate:ConfirmAppointmentDelegate?
    var creditCard:CreditCard?
    var user:User!
    var appointment:Appointment!
    var activity:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let auser = DatabaseController.shared.loadUser() {
            self.user = auser
        }
        
        updateButton()
        setUpActivityIndicator()
        setUpNavBar()
        self.stylistLabel.text = self.appointment.stylist.firstName + " " + self.appointment.stylist.lastName
        self.serviceLabel.text = self.appointment.service.name
        self.dateLabel.text = self.appointment.timeslot.startDate!.dateString(ofStyle: .full) + "\n" + self.appointment.timeslot.startDate!.timeString(ofStyle: .short) + "-" + self.appointment.timeslot.startDate!.adding(.minute, value: self.appointment.timeslot.duraton!).timeString(ofStyle: .short)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateButton), name: Notifications.kCreditCardAdded, object: nil)
    }
    
    func setUpActivityIndicator() {
        activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activity)
        
        let const:[NSLayoutConstraint] = [
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(const)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notifications.kCreditCardAdded, object: nil)
    }
    
    func updateButton() {
        if let card = DatabaseController.shared.loadCard() {
            self.addCreditCardLabel.text = "By reserving a stylist's time please note you will be charged in full for no show appointments or if less than 24 notice given prior to appointment."
            self.creditCard = card
            self.confirmButton.setTitle("Confirm", for: .normal)
        } else {
            self.addCreditCardLabel.text = "**You will need to add a credit card to book an appointment."
            self.confirmButton.setTitle("Add Credit Card", for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont(name: "Baskerville", size: 20)!]
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setUpNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.title = "CONFIRM"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont(name: "Baskerville", size: 20)!]
        navigationController?.navigationBar.isTranslucent = false
        
        //This line sets the back button title to "" so that it doesnt show up at < Messages when pushing
        //the next view controller
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "Confirm" {
            self.confirm()
        } else if sender.titleLabel?.text == "Add Credit Card" {
            let addVC = AddCreditCardViewController()
            self.navigationController?.pushViewController(addVC, animated: true)
        }
        
    }
    
    func confirm() {
        self.activity.startAnimating()
        guard let card = self.creditCard else {return}
        self.confirmButton.isEnabled = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.shared.confirmAppointment(appointment: self.appointment, user: self.user, card: card) {
            success in
            self.activity.stopAnimating()
            self.confirmButton.isEnabled = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if success {
                self.addServiceOrHome()
            } else {
                self.showErrorAlert(title: "Error", body: "Could not confirm booking, please try again.")
            }
        }
    }
    
    func addServiceOrHome() {
        let alert = PopupDialog(title: "Appointment Confirmed", message: "We will see you very soon!")
        alert.buttonAlignment = .horizontal
        let buttonOne = DefaultButton(title: "Add a service?") {
            self.navigationController?.popViewController()
        }
        
        let buttonTwo = CancelButton(title: "Home") {
            AppDelegate.shared().initWindow(controller: "Home")
            self.navigationController?.popViewController() 
        }
        
        NotificationCenter.default.post(name: Notifications.kClearAllBookingData, object: nil)
        alert.addButtons([buttonTwo, buttonOne])
        alert.transitionStyle = .zoomIn
        // Present dialog
        self.present(alert, animated: true, completion: nil)
    }

}
