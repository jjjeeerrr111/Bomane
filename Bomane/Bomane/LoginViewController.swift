//
//  LoginViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-12-17.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var loginButton:UIButton!
    var emailField:UITextField!
    var passwordField:UITextField!
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
        navigationItem.title = "LOG IN"
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
        
        hello.text = "Hello"
        hello.textAlignment = .center
        hello.font = UIFont(name: "AvenirNext-Regular", size: 40)
        hello.textColor = UIColor(red: 210/255, green: 185/255, blue: 163/255, alpha: 1)
        hello.numberOfLines = 2
        
        again.text = "again"
        again.textAlignment = .center
        again.font = UIFont(name: "AvenirNext-Regular", size: 40)
        again.textColor = UIColor(red: 210/255, green: 185/255, blue: 163/255, alpha: 1)
        again.numberOfLines = 2
        
        emailField = UITextField()
        emailField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailField)
        
        let separator1 = UIView()
        separator1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator1)
        
        passwordField = UITextField()
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordField)
        
        let separator2 = UIView()
        separator2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator2)
        
        let secConstraints:[NSLayoutConstraint] = [
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            emailField.topAnchor.constraint(equalTo: again.bottomAnchor, constant: 5),
            emailField.heightAnchor.constraint(equalToConstant: 40),
            separator1.topAnchor.constraint(equalTo: emailField.bottomAnchor),
            separator1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            separator1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            separator1.heightAnchor.constraint(equalToConstant: 0.5),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            passwordField.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 10),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            separator2.topAnchor.constraint(equalTo: passwordField.bottomAnchor),
            separator2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            separator2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            separator2.heightAnchor.constraint(equalToConstant: 0.5),
        ]
        NSLayoutConstraint.activate(secConstraints)
        
        emailField.placeholder = "Email"
        passwordField.placeholder = "Password"
        
        emailField.font = UIFont(name: "AvenirNext-Regular", size: 18)
        passwordField.font = UIFont(name: "AvenirNext-Regular", size: 18)
        
        emailField.textColor = UIColor.white
        passwordField.textColor = UIColor.white
        
        emailField.placeholderColor = UIColor.white
        passwordField.placeholderColor = UIColor.white
        
        emailField.delegate = self
        emailField.clearButtonMode = .whileEditing
        emailField.returnKeyType = .next
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        
        passwordField.delegate = self
        passwordField.isSecureTextEntry = true
        passwordField.clearButtonMode = .whileEditing
        passwordField.returnKeyType = .done
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        
        separator1.backgroundColor = UIColor.white
        separator2.backgroundColor = UIColor.white
        separator1.alpha = 0.5
        separator2.alpha = 0.5
        
        loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        loginBottomConstraint = loginButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        loginBottomConstraint.isActive = true
        
        let btnConstraints:[NSLayoutConstraint] = [
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 54)
        ]
        NSLayoutConstraint.activate(btnConstraints)
        
        loginButton.setTitle("Log in", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        loginButton.setTitleColor(UIColor.black, for: .normal)
        loginButton.backgroundColor = UIColor.white
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
    }
    
    func loginButtonPressed() {
        if (emailField.text?.isEmpty)! {
            showErrorAlert(title: "Email required", body: "Please enter your email to continue.")
            return
        } else if (passwordField.text?.isEmpty)! {
            showErrorAlert(title: "Password required", body: "Please enter your password to continue.")
            return
        }
        resignKeyboard()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.shared.login(email: emailField.text!, password: passwordField.text!) {
            success in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if success {
                
            } else {
                print("failed to log in")
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
        if emailField.isFirstResponder {
            emailField.resignFirstResponder()
        } else if passwordField.isFirstResponder {
            passwordField.resignFirstResponder()
        }
    }

}

extension LoginViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailField.isFirstResponder {
            passwordField.becomeFirstResponder()
        } else if passwordField.isFirstResponder {
            resignKeyboard()
            loginButtonPressed()
        }
        return true
    }
}
