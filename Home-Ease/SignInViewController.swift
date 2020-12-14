//
//  SignInViewController.swift
//  Home-Ease
//
//  Created by Snow Hao on 12/9/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var signInLogInLabel: UILabel!
    @IBOutlet weak var emailLogInTextField: UITextField!
    @IBOutlet weak var passwordLogInTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var errorLogInlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorLogInlabel.isHidden = true
    }
    
    //check fields and validate. if correct return nil, otherwise return error
    func validate() -> String?{
        //check all fields are filled in
        if emailLogInTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordLogInTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        return nil
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        //validate field
        let email = (emailLogInTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let password = (passwordLogInTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let docRef = Firestore.firestore().collection("users").document(email)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        //create cleaned versions
        //sign in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                //sign in fail
                self.errorLogInlabel.text = error.localizedDescription
                self.errorLogInlabel.isHidden = false
            }
            else{
                //TRANSITION TO GROUP INSTEAD OF HOME PAGE
                let vc = self.storyboard?.instantiateViewController(identifier: "InitialTabBar") as! UITabBarController
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
