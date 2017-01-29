//
//  ForgotPasswordViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-01-29.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    var sendButton:UIButton!
    var nameField:UITextField!
    var emailField:UITextField!
    var loginBottomConstraint:NSLayoutConstraint!
    
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
        loginBottomConstraint.constant = newFrame.origin.y - view.frame.height
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    func setUpNavigationBar() {
        navigationItem.title = "RESET"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:UIFont(name: "Baskerville", size: 20)!]
        
        
        //This line sets the back button title to "" so that it doesnt show up at < Messages when pushing
        //the next view controller
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    func setUpUI() {
        let hello = UILabel()
        hello.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hello)
        
        let again = UILabel()
        again.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(again)
        
        let constraints:[NSLayoutConstraint] = [
            hello.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0),
            hello.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            again.topAnchor.constraint(equalTo: hello.bottomAnchor, constant: -20),
            again.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ]
        NSLayoutConstraint.activate(constraints)
        
        hello.text = "Forgot"
        hello.textAlignment = .center
        hello.font = UIFont(name: "AvenirNext-Regular", size: 40)
        hello.textColor = UIColor(red: 210/255, green: 185/255, blue: 163/255, alpha: 1)
        hello.numberOfLines = 2
        
        again.text = "Password"
        again.textAlignment = .center
        again.font = UIFont(name: "AvenirNext-Regular", size: 40)
        again.textColor = UIColor(red: 210/255, green: 185/255, blue: 163/255, alpha: 1)
        again.numberOfLines = 2
        
        nameField = UITextField()
        nameField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameField)
        
        let separator1 = UIView()
        separator1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator1)
        
        emailField = UITextField()
        emailField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailField)
        
        let separator2 = UIView()
        separator2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator2)
        
        let secConstraints:[NSLayoutConstraint] = [
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            nameField.topAnchor.constraint(equalTo: again.bottomAnchor, constant: 5),
            nameField.heightAnchor.constraint(equalToConstant: 40),
            separator1.topAnchor.constraint(equalTo: nameField.bottomAnchor),
            separator1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            separator1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            separator1.heightAnchor.constraint(equalToConstant: 0.5),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            emailField.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 10),
            emailField.heightAnchor.constraint(equalToConstant: 40),
            separator2.topAnchor.constraint(equalTo: emailField.bottomAnchor),
            separator2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            separator2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            separator2.heightAnchor.constraint(equalToConstant: 0.5)
        ]
        NSLayoutConstraint.activate(secConstraints)
        
        nameField.placeholder = "Name"
        emailField.placeholder = "Email"
        
        nameField.font = UIFont(name: "AvenirNext-Regular", size: 18)
        emailField.font = UIFont(name: "AvenirNext-Regular", size: 18)
        
        nameField.textColor = UIColor.white
        emailField.textColor = UIColor.white
        
        nameField.placeholderColor = UIColor.white
        emailField.placeholderColor = UIColor.white
        
        nameField.delegate = self
        nameField.clearButtonMode = .whileEditing
        nameField.returnKeyType = .next
        nameField.autocorrectionType = .no
        nameField.autocapitalizationType = .words
        
        emailField.delegate = self
        emailField.clearButtonMode = .whileEditing
        emailField.returnKeyType = .done
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        
        separator1.backgroundColor = UIColor.white
        separator2.backgroundColor = UIColor.white
        separator1.alpha = 0.5
        separator2.alpha = 0.5
        
        sendButton = UIButton()
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        
        loginBottomConstraint = sendButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        loginBottomConstraint.isActive = true
        
        let btnConstraints:[NSLayoutConstraint] = [
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 54)
        ]
        NSLayoutConstraint.activate(btnConstraints)
        
        sendButton.setTitle("Send email", for: .normal)
        sendButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        sendButton.setTitleColor(UIColor.black, for: .normal)
        sendButton.backgroundColor = UIColor.white
        sendButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    func forgotPasswordButtonPressed(sender: UIButton) {
        let forgotVC = ForgotPasswordViewController()
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    func loginButtonPressed() {
        if (nameField.text?.isEmpty)! {
            showErrorAlert(title: "Name required", body: "Please enter your name to continue.")
            return
        } else if (emailField.text?.isEmpty)! {
            showErrorAlert(title: "Email required", body: "Please enter your email to continue.")
            return
        }
        resignKeyboard()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.shared.getAccessToken() {
            optToken in
            
            guard let token = optToken else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return
            }
            NetworkController.shared.forgotPassword(email: self.emailField.text!, token: token,name: self.nameField.text!) {
                success in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if success {
                    self.showErrorAlert(title: "Email sent", body: "A password reset email was sent to you. Check your inbox and follow the steps to reset your account password.")
                } else {
                    self.showErrorAlert(title: "Error", body: "An error has occured while trying to send you a password reset email. Please try again.")
                }
            }
        }
        
        
    }
    
    func setUpTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    func tap(sender: UITapGestureRecognizer) {
        resignKeyboard()
    }
    
    func resignKeyboard() {
        if nameField.isFirstResponder {
            nameField.resignFirstResponder()
        } else if emailField.isFirstResponder {
            emailField.resignFirstResponder()
        }
    }
}

extension ForgotPasswordViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameField.isFirstResponder {
            emailField.becomeFirstResponder()
        } else if emailField.isFirstResponder {
            resignKeyboard()
            loginButtonPressed()
        }
        return true
    }
}
