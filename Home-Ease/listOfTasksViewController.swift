//
//  listOfTasksViewController.swift
//  Home-Ease
//
//  Created by Jackson Tidland on 11/28/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import Firebase

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

class listOfTasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var showOnlyMine: Bool = false;
        
    var myCompletedTasksNames: [String] = []
    var myPendingTasksNames: [String] = []
    
    @IBAction func exitAddNewTask(_ sender: Any) {
        addTaskView.isHidden = true;
        taskField.text = ""
        roommateField.text = ""
    }
    
    
    
    
    
    //@IBOutlet weak var markAllAsCompletedBtn: UIButton!
    
    @IBOutlet weak var addTaskView: UIView!
    
    @IBOutlet weak var pendingTableView: UITableView!
    
    @IBOutlet weak var completedTableView: UITableView!
    
    var pendingCount = 0;
    var completedCount = 0;
    
    func updateCounts(){
        let currentUser = Auth.auth().currentUser?.email ?? ""
        let docRef = Firestore.firestore().collection("users").document(currentUser)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let groupName = (document.data()!["group"] ?? "")
                    let docRef2 = Firestore.firestore().collection("groups").document(groupName as! String)
                    docRef2.getDocument { (document2, error) in
                        if let document2 = document2, document2.exists {
                            let pendingTasks: [String] = (document2.data()!["namesOfPendingTasks"] ?? []) as! [String]
                            let completedTasks: [String] = (document2.data()!["namesOfCompletedTasks"] ?? []) as! [String]
                            self.pendingCount = pendingTasks.count
                            self.completedCount = completedTasks.count
                            self.completedTableView.reloadData()
                            self.pendingTableView.reloadData()
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
    }
    
        
//    var completedTasksRoommates: [String] = UserDefaults.standard.object(forKey: "tasksRoommatesCompleted") as? [String] ?? []
//
//    var completedTasksNames: [String] = UserDefaults.standard.object(forKey: "tasksNamesCompleted") as? [String] ?? []
//
//    var pendingTasksRoommates: [String] = UserDefaults.standard.object(forKey: "tasksRoommatesPending") as? [String] ?? []
//
//     var pendingTasksNames: [String] = UserDefaults.standard.object(forKey: "tasksNamesPending") as? [String] ?? []
       
    struct Task {
        var roommateName: String!
        var taskName: String!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //I consulted this when I was unsure about how to set up multiple table cells within the same view controller: https://stackoverflow.com/questions/37447124/how-do-i-create-two-table-views-in-one-view-controller-with-two-custom-uitablevi
        if tableView == self.completedTableView{
            return self.completedCount
        }
        else if tableView == self.pendingTableView{
            return self.pendingCount
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        DispatchQueue.global(qos: .background).async{
            let currentUser = Auth.auth().currentUser?.email ?? ""
            let docRef = Firestore.firestore().collection("users").document(currentUser)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let groupName = (document.data()!["group"] ?? "")
                    let docRef2 = Firestore.firestore().collection("groups").document(groupName as! String)
                    docRef2.getDocument { (document2, error) in
                        if let document2 = document2, document2.exists {
                            let pendingTasks: [String] = (document2.data()!["namesOfPendingTasks"] ?? []) as! [String]
                            let completedTasks: [String] = (document2.data()!["namesOfCompletedTasks"] ?? []) as! [String]
                            DispatchQueue.main.async{
                                if tableView == self.completedTableView{
                                    myCell.textLabel!.text = "\(completedTasks[indexPath.row])"
                                    let loopMax: Int = document2.data()!["count"] as! Int
                                    let emails: [String] = document2.data()!["emailsOfCompletedTasks"] as! [String]
                                    let allEmails: [String] = document2.data()!["roommateEmails"] as! [String]
                                    let cellEmail = emails[indexPath.row]
                                    let colors: [String] = document2.data()!["roommateColors"] as! [String]
                                    for i in 0..<loopMax{
                                        if(allEmails[i] == cellEmail){
                                            myCell.backgroundColor = UIColor(hex: colors[i])
                                        }
                                    }
                                    
                                    //completedEmails
                                }
                                else if tableView == self.pendingTableView{
                                    myCell.textLabel!.text = "\(pendingTasks[indexPath.row])"
                                    let loopMax: Int = document2.data()!["count"] as! Int
                                    let emails: [String] = document2.data()!["emailsOfPendingTasks"] as! [String]
                                    let allEmails: [String] = document2.data()!["roommateEmails"] as! [String]
                                    let cellEmail = emails[indexPath.row]
                                    let colors: [String] = document2.data()!["roommateColors"] as! [String]
                                    for i in 0..<loopMax{
                                        if(allEmails[i] == cellEmail){
                                            myCell.backgroundColor = UIColor(hex: colors[i])
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        return myCell
    }
    
    
    
    @IBOutlet weak var scopeOfTaksButton: UIButton!
    
    
    @IBOutlet weak var weekLabel: UILabel!

    
    @IBAction func scopeOfTasksChange(_ sender: Any) {
        if scopeOfTaksButton.titleLabel?.text == "Show Only My Tasks"{
            scopeOfTaksButton.titleLabel?.text = "Show All Tasks"
        //        markAllAsCompletedBtn.isHidden = false;
            }
        else if scopeOfTaksButton.titleLabel?.text == "Show All Tasks"{
            scopeOfTaksButton.titleLabel?.text = "Show Only My Tasks"
               // markAllAsCompletedBtn.isHidden = true
            }
    }
    
    
    @IBOutlet weak var taskField: UITextField!
    
    @IBOutlet weak var roommateField: UITextField!
    
    @IBAction func addNewTask(_ sender: Any) {
        addTaskView.isHidden = false
    }
    
    @IBAction func addTaskAndCloseSubview(_ sender: Any) {
        addTaskView.isHidden = true
        if(self.taskField.text ?? "" != ""){
            let currentUser = Auth.auth().currentUser?.email ?? ""
            let docRef = Firestore.firestore().collection("users").document(currentUser)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let groupName = (document.data()!["group"] ?? "")
                    let docRef2 = Firestore.firestore().collection("groups").document(groupName as! String)
                    docRef2.getDocument { (document2, error) in
                        if let document2 = document2, document2.exists {
                            //make sure that user exists. if they do not, return
                            let emailsInGroup: [String] = (document2.data()!["roommateEmails"] ?? []) as! [String]
                            for i in 0..<emailsInGroup.count{
                                if(emailsInGroup[i] == self.roommateField.text!){
                                    var pendingTasks: [String] = (document2.data()!["namesOfPendingTasks"] ?? []) as! [String]
                                    //var pendingUsers: [String] = (document2.data()!["usersOfPendingTasks"] ?? []) as! [String]
                                    var pendingEmails: [String] = (document2.data()!["emailsOfPendingTasks"] ?? []) as! [String]
                                    if((pendingTasks.count == 1 && pendingEmails[0] == "")){
                                        pendingEmails[0] = self.taskField.text!
                                    }
                                    else{
                                        pendingTasks.append(self.taskField.text!)
                                    }
                                    if((pendingEmails.count == 1 && pendingEmails[0] == "")){
                                        pendingEmails[0] = self.roommateField.text!
                                    }
                                    else{
                                        pendingEmails.append(self.roommateField.text!)
                                    }
                                    self.pendingCount = pendingTasks.count
                                    docRef2.updateData(["namesOfPendingTasks" : pendingTasks])
                                    docRef2.updateData(["emailsOfPendingTasks" : pendingEmails])
                                    self.taskField.text = ""
                                    self.roommateField.text = ""
                                    self.pendingTableView.reloadData()
                                }
                            }
                            //todo: maybe put error statement here, saying that roommate is not in group
                        }
                    }
                } else {
                    print("Document does not exist")
                    self.taskField.text = ""
                    self.roommateField.text = ""
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == self.pendingTableView && editingStyle == .delete{
            DispatchQueue.global(qos: .background).async{
                //move table view cell from pending to collection. the easier way to do this would be exclusively through firebase
                let indexOfCell = indexPath.row;
                let currentUser = Auth.auth().currentUser?.email ?? ""
                let docRef = Firestore.firestore().collection("users").document(currentUser)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let groupName = (document.data()!["group"] ?? "")
                        let docRef2 = Firestore.firestore().collection("groups").document(groupName as! String)
                        docRef2.getDocument { (document2, error) in
                            if let document2 = document2, document2.exists {
                                var pendingTasks: [String] = (document2.data()!["namesOfPendingTasks"] ?? []) as! [String]
                                //var pendingUsers: [String] = (document2.data()!["usersOfPendingTasks"] ?? []) as! [String]
                                var pendingEmails: [String] = (document2.data()!["emailsOfPendingTasks"] ?? []) as! [String]
                                var completedTasks: [String] = (document2.data()!["namesOfCompletedTasks"] ?? []) as! [String]
                                //var completedUsers: [String] = (document2.data()!["usersOfCompletedTasks"] ?? []) as! [String]
                                var completedEmails: [String] = (document2.data()!["emailsOfCompletedTasks"] ?? []) as! [String]
                                completedTasks.append(pendingTasks[indexOfCell])
                                completedEmails.append(pendingEmails[indexOfCell])
                                pendingTasks.remove(at: indexOfCell)
                                pendingEmails.remove(at: indexOfCell)
                                docRef2.updateData(["namesOfPendingTasks" : pendingTasks])
                               // docRef2.updateData(["usersOfPendingTasks" : pendingUsers])
                                docRef2.updateData(["namesOfCompletedTasks" : completedTasks])
                                //docRef2.updateData(["usersOfCompletedTasks" : completedUsers])
                                docRef2.updateData(["emailsOfPendingTasks" : pendingEmails])
                                docRef2.updateData(["emailsOfCompletedTasks" : completedEmails])
                                self.pendingCount -= 1
                                self.completedCount += 1
                                self.pendingTableView.reloadData()
                                self.completedTableView.reloadData()
                                DispatchQueue.main.async{
                                    //the above cause the code to crash
                                }
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
        else if editingStyle == .delete{
            //deleting from completed table view, so we want to delete permanently
            DispatchQueue.global(qos: .background).async{
                //move table view cell from pending to collection. the easier way to do this would be exclusively through firebase
                let indexOfCell = indexPath.row;
                let currentUser = Auth.auth().currentUser?.email ?? ""
                let docRef = Firestore.firestore().collection("users").document(currentUser)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let groupName = (document.data()!["group"] ?? "")
                        let docRef2 = Firestore.firestore().collection("groups").document(groupName as! String)
                        docRef2.getDocument { (document2, error) in
                            if let document2 = document2, document2.exists {
                                var completedTasks: [String] = (document2.data()!["namesOfCompletedTasks"] ?? []) as! [String]
                                var completedEmails: [String] = (document2.data()!["emailsOfCompletedTasks"] ?? []) as! [String]
                                completedTasks.remove(at: indexOfCell)
                                completedEmails.remove(at: indexOfCell)
                                //completedUsers.remove(at: indexOfCell)
                                docRef2.updateData(["namesOfCompletedTasks" : completedTasks])
                                docRef2.updateData(["emailsOfCompletedTasks" : completedEmails])
                                self.completedCount -= 1
                                self.completedTableView.reloadData()
                                DispatchQueue.main.async{
                                   // self.completedTableView.reloadData()
                                    //the above cause the program to crash
                                }
                            }
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        self.addTaskView.isHidden = true
        DispatchQueue.global(qos: .background).async{
            self.updateCounts();
            DispatchQueue.main.async{
                super.viewDidLoad()
                self.pendingTableView.dataSource = self;
                self.pendingTableView.delegate = self;
                self.completedTableView.dataSource = self;
                self.completedTableView.delegate = self;
                self.pendingTableView.reloadData();
                self.completedTableView.reloadData();
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if tableView == pendingTableView{
            return "Mark as Completed"
        }
        else{
            return "Delete Task"
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        updateCounts();
        completedTableView.reloadData();
        pendingTableView.reloadData();
    }

    override func viewDidAppear(_ animated: Bool) {
        completedTableView.reloadData();
        pendingTableView.reloadData();
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
