//
//  CreateNewUserViewController.swift
//  Home-Ease
//
//  Created by Snow Hao on 12/9/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CreateNewUserViewController: UIViewController {

    @IBOutlet weak var createNewUserLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
    }
    
    func validate() -> String? {
       //check all fields are filled in
       if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
           passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
           return "Please fill in all fields."
       }
       //error label?
        return nil
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        //validate field
        let error = validate()
        if let error = error {
            //error exists
            showError(error)
        }
        else {
            //create users
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check for errors
                if err != nil {
                    self.showError("Error creating user.")
                }
                else {
                    //create the database and add the document into it
                    let db = Firestore.firestore()
                    //db.collection("users").addDocument(data: ["firstName": firstName,"uid": result!.user.uid ]) { (error) in
                    db.collection("users").document(email).setData(["firstName": firstName,"uid": result!.user.uid ]) { (error) in
                        if error != nil {
                            self.showError("User data could not be saved.")
                        }
                    }
                    //transition to home screen
                    self.transitionToHome()
                }
            }
        }
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    func transitionToHome(){
        //TRANSITION TO GROUP INSTEAD OF HOME PAGE
        //let vc = storyboard?.instantiateViewController(identifier: "InitialTabBar") as! UITabBarController
        let vc = storyboard?.instantiateViewController(identifier: "CreateNewGroupViewController") as! CreateNewGroupViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
