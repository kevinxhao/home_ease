//
//  SignInViewController.swift
//  Home-Ease
//
//  Created by Snow Hao on 12/9/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //check fields and validate. if correct return nil, otherwise return error
    func validate() -> String?{
        
        //check all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields"
        }
        
        return nil
    }
    @IBAction func logInTapped(_ sender: Any) {
        //validate field
        //create users
        //transition to home screen
    }
    


}
