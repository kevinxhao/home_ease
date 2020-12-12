//
//  CreateNewGroupViewController.swift
//  Home-Ease
//
//  Created by Jackson Tidland on 12/10/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CreateNewGroupViewController: UIViewController {
    
    @IBOutlet weak var groupName: UITextField!
    
    @IBOutlet weak var groupPassword: UITextField!
    
    //function definition borrowed from create new user view controller
    func validate() -> String?{
        
        //check all fields are filled in
        if groupName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            groupPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""        {
            return "Please fill in all fields"
        }
     
        //error label?
     
        return nil
    }
    
    @IBAction func CreateNewGroup(_ sender: Any) {
        if(validate() != nil){
            //todo: add alert message
        }
        else{
            let newGroupName = groupName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let newPassword = groupPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let database = Firestore.firestore()
            database.collection("groups").addDocument(data: ["groupName": newGroupName,"password":newPassword,"taskNames":[],"taskUsers":[]])
            { (error) in
                if error != nil {
                    //todo: display error message here
                    // also, check if group already exists
                }
            }
            let vc = storyboard?.instantiateViewController(identifier: "InitialTabBar") as! UITabBarController
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
