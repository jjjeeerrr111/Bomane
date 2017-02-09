//
//  EditProfileViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-01-08.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import UIKit

protocol EditProfileDelegate:class {
    func updateProfile(name: String, email: String)
}

class EditProfileViewController: UIViewController {

    weak var delegate:EditProfileDelegate?
    @IBOutlet weak var removeCardButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTapGesture()
        // Do any additional setup after loading the view.
        if let aUser = DatabaseController.shared.loadUser() {
            self.user = aUser
            self.nameTextField.text = self.user!.firstName
            self.emailTextField.text = self.user!.email
            self.lastNameTextField.text = self.user!.lastName
        }
        
        if let card = DatabaseController.shared.loadCard() {
            print(card)
            self.removeCardButton.isHidden = false
        } else {
            self.removeCardButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "EDIT"
        navigationController?.navigationBar.tintColor = UIColor.black
        let rightButton = UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(self.saveButtonPressed(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont(name: "AvenirNext-Regular", size: 15)!], for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeCardButtonPressed(_ sender: UIButton) {
        guard let card = DatabaseController.shared.loadCard() else {return}
        dump(card)
        DatabaseController.shared.deleteCardFile()
        NotificationCenter.default.post(name: Notifications.kCreditCardAdded, object: nil)
    }
    
    func saveButtonPressed(sender: UIBarButtonItem) {
        guard let newName = self.nameTextField.text, newName != "", let newEmail = self.emailTextField.text, newEmail != "", let newLastName = self.lastNameTextField.text, newLastName != "" else {
            self.showErrorAlert(title: "Blank fields", body: "Do not leave any blank fields")
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
        if !newEmail.isValidEmail() {
            self.showErrorAlert(title: "Email required", body: "Please enter a valid email to continue.")
            return
        }
        
        guard let aUser = self.user, let pass = aUser.password else {return}
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.shared.login(email: aUser.email, password: pass) {
            user in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let unwrappedUser = user else {
                self.showErrorAlert(title: "Failed", body: "Something went wrong please try again")
                return}
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            NetworkController.shared.updateUser(with: aUser.customerId!, firstName: newName, lastName: newLastName, email: newEmail,number: aUser.phoneNumber, token: unwrappedUser.apiKey!) {
                success in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if success {
                    self.user!.firstName = newName
                    self.user!.lastName = newLastName
                    self.user!.email = newEmail
                    DatabaseController.shared.saveUser(user: self.user!)
                    self.delegate?.updateProfile(name: "\(newName) \(newLastName)", email: newEmail)
                    _ = self.navigationController?.popViewController(animated: true)
                } else {
                    self.showErrorAlert(title: "Error", body: "Something went wrong, please try again.")
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
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder()
        } else if emailTextField.isFirstResponder {
            emailTextField.resignFirstResponder()
        } else if lastNameTextField.isFirstResponder {
            lastNameTextField.resignFirstResponder()
        }
    }

}

extension EditProfileViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.nameTextField.isFirstResponder {
            self.lastNameTextField.becomeFirstResponder()
        } else if self.lastNameTextField.isFirstResponder {
            self.emailTextField.becomeFirstResponder()
        } else if self.emailTextField.isFirstResponder {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
