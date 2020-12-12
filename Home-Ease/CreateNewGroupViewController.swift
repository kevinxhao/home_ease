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
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var groupPassword: UITextField!
    
    //function definition borrowed from create new user view controller
    func validate() -> String? {
        //check all fields are filled in
        if groupName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            groupPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""        {
            return "Please fill in all fields."
        }
        //error label?
        return nil
    }
    
    @IBAction func CreateNewGroup(_ sender: Any) {
        let error = validate()
        if let error = error {
            errorLabel.text = error
            errorLabel.isHidden = false
        }
        else{
            let newGroupName = groupName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let db = Firestore.firestore().collection("groups")
            db.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }
                else {
                    for document in querySnapshot!.documents {
                        print(document.documentID)
                        print(newGroupName)
                        if (document.documentID == newGroupName) {
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = "This group name already exists."
                            return
                        }
                    }
                    let newPassword = self.groupPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let database = Firestore.firestore()
                    //            database.collection("groups").addDocument(data: ["groupName": newGroupName,"password":newPassword,"taskNames":[],"taskUsers":[]])
                    var arr: [String] = []
                    let finances: [Double] = [0,0,0]
                    let completion: [Bool] = []
                    let taskRoommates: [String] = []
                    let namesOfTasks: [String] = []
                    let email = Auth.auth().currentUser?.email
                    let docRef = Firestore.firestore().collection("users").document(email ?? "")
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            print("Document uid: \(document.data()!["firstName"] ?? "")")
                            arr.append(document.data()!["firstName"] as! String)
                            database.collection("groups").document(newGroupName).setData(["password": newPassword, "count": 1, "roommateNames": arr, "finances": finances, "taskCompletion": completion, "taskRoommates": taskRoommates, "namesOfTasks": namesOfTasks])
                            { (error) in
                                if error != nil {
                                    self.errorLabel.isHidden = false
                                    self.errorLabel.text = error?.localizedDescription
                                    //todo: display error message here
                                    // also, check if group already exists
                                }
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                    let vc = self.storyboard?.instantiateViewController(identifier: "InitialTabBar") as! UITabBarController
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func joinExistingGroup(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
}
