//
//  CreateAccountNameViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-12-17.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit

class CreateAccountNameViewController: UIViewController {
    
    var nextButton:UIButton!
    var firstName:UITextField!
    var lastName:UITextField!
    var email:UITextField!
    var number:UITextField!
    var nextBottomConstraint:NSLayoutConstraint!
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
        setUpNavigationBar()
        setUpUI()
        setUpNotifications()
        setUpTapGesture()
    }
    
    func setUpNotifications() {
        //add nsnotification center listener for keyboard popping up
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //add nsnotification center listener for keyboard going down
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    deinit {
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
        nextBottomConstraint.constant = newFrame.origin.y - view.frame.height
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    func setUpNavigationBar() {
        navigationItem.title = "SIGN UP"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:UIFont(name: "Baskerville", size: 20)!]
        
        
        //This line sets the back button title to "" so that it doesnt show up at < Messages when pushing
        //the next view controller
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    func setUpUI() {
        let create = UILabel()
        create.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(create)
        
        let again = UILabel()
        again.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(again)
        
        let constraints:[NSLayoutConstraint] = [
            create.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0),
            create.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            again.topAnchor.constraint(equalTo: create.bottomAnchor, constant: -20),
            again.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ]
        NSLayoutConstraint.activate(constraints)
        
        var size:CGFloat = 50.0
        if self.view.frame.width == 320 {
            size = 35.0
        }
        
        create.text = "Create your"
        create.textAlignment = .center
        create.font = UIFont(name: "AvenirNext-Regular", size: size)
        create.textColor = UIColor(red: 210/255, green: 185/255, blue: 163/255, alpha: 1)
        create.numberOfLines = 2
        
        again.text = "account"
        again.textAlignment = .center
        again.font = UIFont(name: "AvenirNext-Regular", size: size)
        again.textColor = UIColor(red: 210/255, green: 185/255, blue: 163/255, alpha: 1)
        again.numberOfLines = 2
        
        firstName = UITextField()
        firstName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstName)
        
        let separator1 = UIView()
        separator1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator1)
        
        lastName = UITextField()
        lastName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lastName)
        
        let separator2 = UIView()
        separator2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator2)
        
        email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(email)
        
        let separator3 = UIView()
        separator3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator3)
        
        number = UITextField()
        number.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(number)
        
        let separator4 = UIView()
        separator4.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator4)
        
        let secConstraints:[NSLayoutConstraint] = [
            firstName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            firstName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            firstName.topAnchor.constraint(equalTo: again.bottomAnchor, constant: 5),
            firstName.heightAnchor.constraint(equalToConstant: 40),
            separator1.topAnchor.constraint(equalTo: firstName.bottomAnchor),
            separator1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            separator1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            separator1.heightAnchor.constraint(equalToConstant: 0.5),
            lastName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            lastName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            lastName.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 10),
            lastName.heightAnchor.constraint(equalToConstant: 40),
            separator2.topAnchor.constraint(equalTo: lastName.bottomAnchor),
            separator2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            separator2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            separator2.heightAnchor.constraint(equalToConstant: 0.5),
            email.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            email.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            email.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 10),
            email.heightAnchor.constraint(equalToConstant: 40),
            separator3.topAnchor.constraint(equalTo: email.bottomAnchor),
            separator3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            separator3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            separator3.heightAnchor.constraint(equalToConstant: 0.5),
            number.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            number.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            number.topAnchor.constraint(equalTo: separator3.bottomAnchor, constant: 10),
            number.heightAnchor.constraint(equalToConstant: 40),
            separator4.topAnchor.constraint(equalTo: number.bottomAnchor),
            separator4.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            separator4.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            separator4.heightAnchor.constraint(equalToConstant: 0.5),
        ]
        
        NSLayoutConstraint.activate(secConstraints)
        
        firstName.placeholder = "First name"
        lastName.placeholder = "Last name"
        
        firstName.font = UIFont(name: "AvenirNext-Regular", size: 18)
        lastName.font = UIFont(name: "AvenirNext-Regular", size: 18)
        
        firstName.textColor = UIColor.white
        lastName.textColor = UIColor.white
        
        firstName.placeholderColor = UIColor.white
        lastName.placeholderColor = UIColor.white
        
        firstName.delegate = self
        firstName.clearButtonMode = .whileEditing
        firstName.returnKeyType = .next
        firstName.autocorrectionType = .no
        firstName.autocapitalizationType = .words
        
        lastName.delegate = self
        lastName.clearButtonMode = .whileEditing
        lastName.returnKeyType = .next
        lastName.autocorrectionType = .no
        lastName.autocapitalizationType = .words
        
        email.placeholder = "Email"
        email.placeholderColor = UIColor.white
        email.font = UIFont(name: "AvenirNext-Regular", size: 18)
        email.textColor = UIColor.white
        email.delegate = self
        email.clearButtonMode = .whileEditing
        email.returnKeyType = .next
        email.autocorrectionType = .no
        email.autocapitalizationType = .none
        
        number.placeholder = "Phone number"
        number.placeholderColor = UIColor.white
        number.font = UIFont(name: "AvenirNext-Regular", size: 18)
        number.textColor = UIColor.white
        number.delegate = self
        number.keyboardType = .numberPad
        number.clearButtonMode = .whileEditing
        number.returnKeyType = .done
        number.autocorrectionType = .no
        number.autocapitalizationType = .none
        
        separator1.backgroundColor = UIColor.white
        separator2.backgroundColor = UIColor.white
        separator3.backgroundColor = UIColor.white
        separator4.backgroundColor = UIColor.white
        separator1.alpha = 0.5
        separator2.alpha = 0.5
        separator3.alpha = 0.5
        separator4.alpha = 0.5
        
        nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        nextBottomConstraint = nextButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        nextBottomConstraint.isActive = true
        
        let btnConstraints:[NSLayoutConstraint] = [
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 54)
        ]
        NSLayoutConstraint.activate(btnConstraints)
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        nextButton.setTitleColor(UIColor.black, for: .normal)
        nextButton.backgroundColor = UIColor.white
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
    }
    
    func nextButtonPressed() {
        if (firstName.text?.isEmpty)! {
            self.showErrorAlert(title: "First name missing", body: "Please enter your first name to create your account.")
            return
        } else if (lastName.text?.isEmpty)! {
            self.showErrorAlert(title: "Last name missing", body: "Please enter your first name to create your account.")
            return
        } else if (email.text?.isEmpty)! || !email.text!.isValidEmail() {
            self.showErrorAlert(title: "Email required", body: "Please enter a valid email to continue.")
            return
        } else if (number.text?.isEmpty)! || !self.validate(phoneNumber: number.text!) || self.number.text?.characters.count != 10 {
            self.showErrorAlert(title: "Phone number required", body: "Please enter a valid phone number and area code to continue.")
            return
        }
        resignKeyboard()
        
        self.user = User(first: firstName.text!, last: lastName.text!, email: email.text!, phone: number.text!)
        
        let passVC = CreateAccountPasswordViewController()
        passVC.user = self.user
        navigationController?.pushViewController(passVC, animated: true)
    }
    
    
    func validate(phoneNumber: String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }
    
    func setUpTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    func tap(sender: UITapGestureRecognizer) {
        resignKeyboard()
    }
    
    func resignKeyboard() {
        if email.isFirstResponder {
            email.resignFirstResponder()
        } else if firstName.isFirstResponder {
            firstName.resignFirstResponder()
        } else if lastName.isFirstResponder {
            lastName.resignFirstResponder()
        }
    }
    
}

extension CreateAccountNameViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if firstName.isFirstResponder {
            lastName.becomeFirstResponder()
        } else if lastName.isFirstResponder {
            email.becomeFirstResponder()
        } else if email.isFirstResponder {
            resignKeyboard()
            nextButtonPressed()
        }
        return true
    }
}
