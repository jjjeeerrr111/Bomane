//
//  CreateAccountPasswordViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-12-17.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit

class CreateAccountPasswordViewController: UIViewController {
    
    var createAccountButton:UIButton!
    var password:UITextField!
    var confirmPassword:UITextField!
    var createBottomConstraint:NSLayoutConstraint!
    var user:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
        setUpNavigationBar()
        setUpUI()
        setUpNotifications()
        setUpTapGesture()
        
        //get an access token first
        NetworkController.shared.getAccessToken() {
            optionalToken in
            
            guard let token = optionalToken else {return}
            self.user.apiKey = token
        }
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
        createBottomConstraint.constant = newFrame.origin.y - view.frame.height
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
        
        var size:CGFloat = 50.0
        if view.frame.size.width == 320 {
            size = 40.0
        }
        
        hello.text = "Almost"
        hello.textAlignment = .center
        hello.font = UIFont(name: "AvenirNext-Regular", size: size)
        hello.textColor = UIColor(red: 210/255, green: 185/255, blue: 163/255, alpha: 1)
        hello.numberOfLines = 2
        
        again.text = "there"
        again.textAlignment = .center
        again.font = UIFont(name: "AvenirNext-Regular", size: size)
        again.textColor = UIColor(red: 210/255, green: 185/255, blue: 163/255, alpha: 1)
        again.numberOfLines = 2
        
        password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(password)
        
        let separator1 = UIView()
        separator1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator1)
        
        confirmPassword = UITextField()
        confirmPassword.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmPassword)
        
        let separator2 = UIView()
        separator2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator2)
        
        let secConstraints:[NSLayoutConstraint] = [
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            password.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            password.topAnchor.constraint(equalTo: again.bottomAnchor, constant: 5),
            password.heightAnchor.constraint(equalToConstant: 40),
            separator1.topAnchor.constraint(equalTo: password.bottomAnchor),
            separator1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            separator1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            separator1.heightAnchor.constraint(equalToConstant: 0.5),
            confirmPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            confirmPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            confirmPassword.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 10),
            confirmPassword.heightAnchor.constraint(equalToConstant: 40),
            separator2.topAnchor.constraint(equalTo: confirmPassword.bottomAnchor),
            separator2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            separator2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            separator2.heightAnchor.constraint(equalToConstant: 0.5),
            ]
        NSLayoutConstraint.activate(secConstraints)
        
        password.placeholder = "Password"
        confirmPassword.placeholder = "Confirm Password"
        
        password.font = UIFont(name: "AvenirNext-Regular", size: 18)
        confirmPassword.font = UIFont(name: "AvenirNext-Regular", size: 18)
        
        password.textColor = UIColor.white
        confirmPassword.textColor = UIColor.white
        
        password.placeholderColor = UIColor.white
        confirmPassword.placeholderColor = UIColor.white
        
        password.delegate = self
        password.isSecureTextEntry = true
        password.clearButtonMode = .whileEditing
        password.returnKeyType = .next
        password.autocorrectionType = .no
        password.autocapitalizationType = .none
        
        confirmPassword.delegate = self
        confirmPassword.isSecureTextEntry = true
        confirmPassword.clearButtonMode = .whileEditing
        confirmPassword.returnKeyType = .done
        confirmPassword.autocorrectionType = .no
        confirmPassword.autocapitalizationType = .none
        
        separator1.backgroundColor = UIColor.white
        separator2.backgroundColor = UIColor.white
        separator1.alpha = 0.5
        separator2.alpha = 0.5
        
        createAccountButton = UIButton()
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createAccountButton)
        
        createBottomConstraint = createAccountButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        createBottomConstraint.isActive = true
        
        let btnConstraints:[NSLayoutConstraint] = [
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            createAccountButton.heightAnchor.constraint(equalToConstant: 54)
        ]
        NSLayoutConstraint.activate(btnConstraints)
        
        createAccountButton.setTitle("Create Account", for: .normal)
        createAccountButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        createAccountButton.setTitleColor(UIColor.black, for: .normal)
        createAccountButton.backgroundColor = UIColor.white
        createAccountButton.addTarget(self, action: #selector(createAccountButtonButtonPressed), for: .touchUpInside)
        
    }
    
    func createAccountButtonButtonPressed() {
        
        if (password.text?.isEmpty)! || (confirmPassword.text?.isEmpty)! {
            showErrorAlert(title: "Password required", body: "Please do not leave any fields blank!")
            return
        } else if let pass1 = password.text, let pass2 = confirmPassword.text {
            
            if pass1.characters.count < 8 {
                showErrorAlert(title: "Password too short", body: "Your password should be 8 characters or longer.")
                return
            }
            
            if !checkForNumberInPass(text: pass1) {
                showErrorAlert(title: "Error", body: "Make sure your password has at least one number.")
                return
            }
            
            if pass1 != pass2 {
                showErrorAlert(title: "Passwords do not match", body: "Make sure your passwords match!")
                return
            } else {
                //everything is good here
                createAccount()
                resignKeyboard()
                
            }
            
        }
    }
    
    func checkForNumberInPass(text : String) -> Bool{
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        return numberresult
    }
    
    func createAccount() {
        //1. assign the password to the user
        self.user.password = password.text!
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.shared.createUserAccount(with: self.user) {
            (success,customerId) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if success {
                //this is where you push log in and create user
                guard let id = customerId else {return}
                self.user.customerId = id
                DatabaseController.shared.saveUser(user: self.user)
                AppDelegate.shared().initWindow(controller: "Book Appointment")
            } else {
                if let msg = customerId {
                    self.showErrorAlert(title: "Error", body: msg)
                } else {
                    self.showErrorAlert(title: "Whoops...", body: "Something went wrong while creating your account. Please try again.")
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
        if password.isFirstResponder {
            password.resignFirstResponder()
        } else if confirmPassword.isFirstResponder {
            confirmPassword.resignFirstResponder()
        }
    }
    
}

extension CreateAccountPasswordViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if password.isFirstResponder {
            confirmPassword.becomeFirstResponder()
        } else if confirmPassword.isFirstResponder {
            resignKeyboard()
            createAccountButtonButtonPressed()
        }
        return true
    }
}
