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
    
    let colorsArray: [String] = ["#fff000ff", "#f231f2ff", "6565bfff", "6efdfdff"]
    
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
                    let currentUser = Auth.auth().currentUser?.email
                    let finances: [Double] = [0,0,0]
                    let completion: [Bool] = []
                    let taskRoommates: [String] = []
                    let namesOfPendingTasks: [String] = []
                    let namesOfCompletedTasks: [String] = []
                    let dates:[String] = ["01/01/2021","01/01/2021","01/01/2021"]
                    let email = Auth.auth().currentUser?.email
                    let docRef = Firestore.firestore().collection("users").document(email ?? "")
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            print("Document uid: \(document.data()!["firstName"] ?? "")")
                            database.collection("users").document(currentUser ?? "").updateData(["group":newGroupName])
                            let arr: [String] = [(document.data()!["firstName"] as! String)]
                            let emailArr: [String] = [email!]
                            let taskEmailArr: [String] = []
                            let colorArr: [String] = [".blue"]
                            database.collection("groups").document(newGroupName).setData(["password": newPassword, "count": 1, "roommateNames": arr, "finances": finances, "dueDates":dates, "taskCompletion": completion, "taskRoommates": taskRoommates, "roommateEmails": emailArr, "roommateColors": colorArr, "emailsOfPendingTasks": taskEmailArr, "emailsOfCompletedTasks": taskEmailArr, "namesOfPendingTasks": namesOfPendingTasks, "namesOfCompletedTasks": namesOfCompletedTasks])
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
        let error = validate()
        if let error = error {
            errorLabel.text = error
            errorLabel.isHidden = false
        }
        let potentialGroupName = groupName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let potentialGroupPassword = groupPassword.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let dbGroups = Firestore.firestore().collection("groups")
        let dbUsers = Firestore.firestore().collection("users")
        dbGroups.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        }
        else {
            let currentUser = Auth.auth().currentUser?.email
            for document in querySnapshot!.documents {
                print(document.documentID)
                print(potentialGroupName)
                if (document.documentID == potentialGroupName && (document.data()["password"] as! String) == potentialGroupPassword) {
                    //the group name exists AND the password matches
                    //need to get count and roommate names array from group
                    let docRef = dbGroups.document(potentialGroupName)
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            print("Group Found")
                            var nameArray = document.data()!["roommateNames"] as! [String]
                            var emailArray = document.data()!["roommateEmails"] as! [String]
                            var currentCount = document.data()!["count"] as! Int
                            var taskColorsArray = document.data()!["roommateColors"] as! [String]
                            let docRef2 = dbUsers.document(currentUser ?? "")
                            docRef2.getDocument { (document2, error2) in
                                if let document2 = document2, document2.exists{
                                    print("User Found")
                                    nameArray.append(document2.data()!["firstName"] as! String)
                                    emailArray.append(document2.documentID)
                                    taskColorsArray.append(self.colorsArray[taskColorsArray.count%8])
                                    currentCount += 1
                                    dbGroups.document(potentialGroupName).updateData(["count": currentCount, "roommateNames": nameArray])
                                    dbUsers.document(currentUser ?? "").updateData(["group": potentialGroupName])
                                    dbGroups.document(potentialGroupName).updateData(["roommateColors": taskColorsArray])
                                    dbGroups.document(potentialGroupName).updateData(["roommateEmails": emailArray])
                                    { (error) in
                                        if error != nil {
                                            self.errorLabel.isHidden = false
                                            self.errorLabel.text = error?.localizedDescription
                                            //todo: display error message here
                                            // also, check if group already exists
                                        }
                                    }
                                    self.errorLabel.isHidden = true
                                    let vc = self.storyboard?.instantiateViewController(identifier: "InitialTabBar") as! UITabBarController
                                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                                    self.navigationController?.pushViewController(vc, animated: true)
                                    return
                                    //dbUsers.document(currentUser).updateData([""])
                                }
                            }
                        }
                    }
                } else {
                print("Document does not exist")
                }
            }
                self.errorLabel.isHidden = false
                self.errorLabel.text = "Invalid User/Password Combination"
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
}
