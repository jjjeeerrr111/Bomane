//
//  AddCreditCardViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-01-14.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import UIKit
import Stripe

class AddCreditCardViewController: UIViewController {
    
    var nameField:UITextField!
    var addCardButton:UIButton!
    var addCardButtonBottomConstant:NSLayoutConstraint!
    var paymentField:STPPaymentCardTextField!
    var billingzipField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpUI()
        setUpReviewButton()
        setUpNotifications()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "CREDIT CARD"
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func setUpNotifications() {
        //add nsnotification center listener for keyboard popping up
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //add nsnotification center listener for keyboard going down
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    deinit {
        print("ADD CREDIT CARD VIEW CONTROLLER DEALLOACTED")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    //this will move the next button up when keyboard is shown by redrawing the view
    func keyboardWillShow(notification: NSNotification) {
        self.updateBottomConstaint(notification: notification)
    }
    
    //this will move the next button down when keyboard will hide by redrawing the view
    func keyboardWillHide(notification: NSNotification) {
        self.updateBottomConstaint(notification: notification)
    }
    
    func updateBottomConstaint(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else {return}
        let newFrame = view.convert(frame, from: (UIApplication.shared.delegate?.window)!)
        addCardButtonBottomConstant.constant = newFrame.origin.y - view.frame.height
        UIView.animate(withDuration: animationDuration, animations: {
            //self.view.layoutIfNeeded()
            self.view.layoutIfNeeded()
        })
    }
    
    
    func hideKeyboard() {
        if paymentField.isFirstResponder {
            paymentField.resignFirstResponder()
        }
    }

    
    func setUpUI() {
        nameField = UITextField()
        nameField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameField)
        
        let sep1 = UIView()
        sep1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sep1)
        
        billingzipField = UITextField()
        billingzipField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(billingzipField)
        
        let sep3 = UIView()
        sep3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sep3)
        
        paymentField = STPPaymentCardTextField()
        paymentField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(paymentField)
        
        let sep2 = UIView()
        sep2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sep2)
        
        let const:[NSLayoutConstraint] = [
            nameField.topAnchor.constraint(equalTo: view.topAnchor,constant: 12),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: 50),
            sep1.topAnchor.constraint(equalTo: nameField.bottomAnchor),
            sep1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sep1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sep1.heightAnchor.constraint(equalToConstant: 0.5),
            billingzipField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            billingzipField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            billingzipField.heightAnchor.constraint(equalToConstant: 50),
            billingzipField.topAnchor.constraint(equalTo: sep1.bottomAnchor,constant: 5),
            sep2.topAnchor.constraint(equalTo: billingzipField.bottomAnchor),
            sep2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sep2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sep2.heightAnchor.constraint(equalToConstant: 0.5),
            paymentField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            paymentField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paymentField.heightAnchor.constraint(equalToConstant: 50),
            paymentField.topAnchor.constraint(equalTo: sep2.bottomAnchor,constant: 5),
            sep3.topAnchor.constraint(equalTo: paymentField.bottomAnchor),
            sep3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sep3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sep3.heightAnchor.constraint(equalToConstant: 0.5)
        ]
        NSLayoutConstraint.activate(const)
        
        sep1.backgroundColor = UIColor.black
        sep2.backgroundColor = UIColor.black
        sep3.backgroundColor = UIColor.black
        nameField.placeholder = "Name on card"
        nameField.placeholderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        nameField.font = UIFont(name: "AvenirNext-Regular", size: 18)
        
        billingzipField.placeholder = "Billing zip code"
        billingzipField.placeholderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        billingzipField.font = UIFont(name: "AvenirNext-Regular", size: 18)
        
        paymentField.backgroundColor = UIColor.clear
        paymentField.textColor = UIColor.black
        paymentField.cursorColor = UIColor.black
        paymentField.borderColor = UIColor.clear
        paymentField.font = UIFont(name: "AvenirNext-Regular", size: 18)
        
        paymentField.delegate = self
        
    }
    
    func setUpReviewButton() {
        addCardButton = UIButton()
        addCardButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCardButton)
        
        
        addCardButtonBottomConstant = addCardButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        addCardButtonBottomConstant.isActive = true
        
        let constraints:[NSLayoutConstraint] = [
            addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addCardButton.heightAnchor.constraint(equalToConstant: 67)
        ]
        NSLayoutConstraint.activate(constraints)
        
        addCardButton.setTitle("Add Card", for: .normal)
        addCardButton.setTitle("Enter Card Number", for: .disabled)
        addCardButton.backgroundColor = UIColor.black
        addCardButton.setTitleColor(UIColor.white, for: .normal)
        addCardButton.setTitleColor(UIColor(red:245/255, green: 245/255, blue:245/255, alpha:1), for: .disabled)
        addCardButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        addCardButton.addTarget(self, action: #selector(self.addCardButtonPressed(sender:)), for: .touchUpInside)
        addCardButton.layer.zPosition = 100
        
        addCardButton.isEnabled = false
    }
    
    func addCardButtonPressed(sender: UIButton) {
        guard let billing = billingzipField.text, billing.replacingOccurrences(of: " ", with: "") != "" else {
            self.showErrorAlert(title: "Empty zip code", body: "Please enter the zip code associated with this card.")
            return
        }
        
        guard let name = nameField.text, name.replacingOccurrences(of: " ", with: "") != "" else  {
            self.showErrorAlert(title: "Name", body: "Please enter the name associated with this card.")
            return
        }
        
        guard let expirationDate = Date(year: Int(self.paymentField.cardParams.expYear), month: Int(self.paymentField.cardParams.expMonth)) else {return}
        print("expiration date: ",expirationDate)
        
        var milliExp = expirationDate.timeIntervalSince1970
        milliExp = milliExp * 1000
        let expString = "/Date(\(Int(milliExp)))/"
        
        let creditCard = CreditCard(name: name, zip: billing, numbers: self.paymentField.cardParams.number!, cvv: self.paymentField.cardParams.cvc!, expDate: expirationDate, expDateString: expString, last4: self.paymentField.cardParams.last4()!)
        
        DatabaseController.shared.saveCard(card: creditCard)
        NotificationCenter.default.post(name: Notifications.kCreditCardAdded, object: nil)
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func addCardToServer(with token: STPToken) {
        
    }


}

extension AddCreditCardViewController:STPPaymentCardTextFieldDelegate {
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        self.addCardButton.isEnabled = textField.isValid
    }
}
