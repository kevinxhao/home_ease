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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func validate() -> String?{
           
           //check all fields are filled in
           if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
               emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
               passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
           {
               return "Please fill in all fields"
           }
        
           //error label?
        
           return nil
       }
       @IBAction func logInTapped(_ sender: Any) {
           //validate field
           // let error = validate()
            
        
           //create users
            Auth.auth().createUser(withEmail: <#T##String#>, password: <#T##String#>) { (result, err) in
                //check for errors
                //implement if we implement error message
//                if let err = err{
//                    //error exists
//
                }
                
        let db = Firestore.firestore()
           //transition to home screen
        
       }
        



}
