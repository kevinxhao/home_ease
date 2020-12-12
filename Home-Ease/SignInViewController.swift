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
        self.errorLogInlabel.alpha = 0
    }
    //check fields and validate. if correct return nil, otherwise return error
    func validate() -> String?{
        
        //check all fields are filled in
        if emailLogInTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordLogInTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields"
        }
        
        return nil
    }
    @IBAction func logInTapped(_ sender: Any) {
        
        //validate field
        let email = emailLogInTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).lowercased();
        let docRef = Firestore.firestore().collection("users").document(email )
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        //create cleaned versions
        let password = passwordLogInTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //sign in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                //sign in fail
                self.errorLogInlabel.text = error!.localizedDescription
                self.errorLogInlabel.alpha = 1
            }
            else{
                //TRANSITION TO GROUP INSTEAD OF HOME PAGE
                let vc = self.storyboard?.instantiateViewController(identifier: "InitialTabBar") as! UITabBarController
                self.navigationController?.pushViewController(vc, animated: true)
                print(Auth.auth().currentUser!.email!)
            }
        }
    }
    


}
