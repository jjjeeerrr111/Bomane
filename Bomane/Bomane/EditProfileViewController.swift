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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTapGesture()
        // Do any additional setup after loading the view.
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
        
    }
    
    func saveButtonPressed(sender: UIBarButtonItem) {
        guard let newName = self.nameTextField.text, newName != "", let newEmail = self.emailTextField.text, newEmail != "" else {
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
        if !newEmail.isValidEmail() {
            self.showErrorAlert(title: "Email required", body: "Please enter a valid email to continue.")
            return
        }
        
        delegate?.updateProfile(name: newName, email: newEmail)
        _ = self.navigationController?.popViewController(animated: true)
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
        }
    }

}

extension EditProfileViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.nameTextField.isFirstResponder {
            self.emailTextField.becomeFirstResponder()
        } else if self.emailTextField.isFirstResponder {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
