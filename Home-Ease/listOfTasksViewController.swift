//
//  listOfTasksViewController.swift
//  Home-Ease
//
//  Created by Jackson Tidland on 11/28/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import Firebase



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
                            print("pending count is now: \(self.pendingCount)")
                            self.completedCount = completedTasks.count
                            print("completed count is now: \(self.completedCount)")
                            print(self.completedCount)
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
//        completedTasksNames = UserDefaults.standard.object(forKey:"tasksNamesCompleted") as? [String] ?? []
//        completedTasksRoommates = UserDefaults.standard.object(forKey:"tasksRoommatesCompleted") as? [String] ?? []
//        pendingTasksNames = UserDefaults.standard.object(forKey:"tasksNamesPending") as? [String] ?? []
//        pendingTasksRoommates = UserDefaults.standard.object(forKey:"tasksRoommatesPending") as? [String] ?? []
//        myCompletedTasksNames = []
//        myPendingTasksNames = []
        DispatchQueue.global(qos: .background).async{
            self.updateCounts()
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
                                }
                                else if tableView == self.pendingTableView{
                                    myCell.textLabel!.text = "\(pendingTasks[indexPath.row])"
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
    
    
    
    
    @IBOutlet weak var scopeOfTasksButton: UIBarButtonItem!
    
    @IBOutlet weak var weekLabel: UILabel!
    
    @IBAction func changeTasksShown(_ sender: Any) {
        if scopeOfTasksButton.title == "Show Only My Tasks"{
            scopeOfTasksButton.title = "Show All Tasks"
    //        markAllAsCompletedBtn.isHidden = false;
        }
        else if scopeOfTasksButton.title == "Show All Tasks"{
            scopeOfTasksButton.title = "Show Only My Tasks"
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
        let currentUser = Auth.auth().currentUser?.email ?? ""
        let docRef = Firestore.firestore().collection("users").document(currentUser)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let groupName = (document.data()!["group"] ?? "")
                let docRef2 = Firestore.firestore().collection("groups").document(groupName as! String)
                docRef2.getDocument { (document2, error) in
                    if let document2 = document2, document2.exists {
                        //make sure that user exists. if they do not, return
                        let roommatesInGroup: [String] = (document2.data()!["roommateNames"] ?? []) as! [String]
                        for i in 0..<roommatesInGroup.count{
                            if(roommatesInGroup[i] == self.roommateField.text!){
                                var pendingTasks: [String] = (document2.data()!["namesOfPendingTasks"] ?? []) as! [String]
                                var pendingUsers: [String] = (document2.data()!["usersOfPendingTasks"] ?? []) as! [String]
                                
                                if((pendingTasks.count == 1 && pendingUsers[0] == "")){
                                    pendingTasks[0] = self.taskField.text!
                                }
                                else{
                                    pendingTasks.append(self.taskField.text!)
                                }
                                if((pendingUsers.count == 1 && pendingUsers[0] == "")){
                                    pendingUsers[0] = self.roommateField.text!
                                }
                                else{
                                    pendingUsers.append(self.roommateField.text!)
                                }
                                self.pendingCount = pendingTasks.count
                                docRef2.updateData(["namesOfPendingTasks" : pendingTasks])
                                docRef2.updateData(["usersOfPendingTasks" : pendingUsers])
                                print("pending count is now: \(self.pendingCount)")
                                print(self.completedCount)
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
                                var pendingUsers: [String] = (document2.data()!["usersOfPendingTasks"] ?? []) as! [String]
                                var completedTasks: [String] = (document2.data()!["namesOfCompletedTasks"] ?? []) as! [String]
                                var completedUsers: [String] = (document2.data()!["usersOfCompletedTasks"] ?? []) as! [String]
                                completedTasks.append(pendingTasks[indexOfCell])
                                completedUsers.append(pendingUsers[indexOfCell])
                                pendingTasks.remove(at: indexOfCell)
                                pendingUsers.remove(at: indexOfCell)
                                docRef2.updateData(["namesOfPendingTasks" : pendingTasks])
                                docRef2.updateData(["usersOfPendingTasks" : pendingUsers])
                                docRef2.updateData(["namesOfCompletedTasks" : completedTasks])
                                docRef2.updateData(["usersOfCompletedTasks" : completedUsers])
                                self.updateCounts()
                                DispatchQueue.main.async{
                                    self.pendingTableView.reloadData()
                                    self.completedTableView.reloadData()
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
                                var completedUsers: [String] = (document2.data()!["usersOfCompletedTasks"] ?? []) as! [String]
                                completedTasks.remove(at: indexOfCell)
                                completedUsers.remove(at: indexOfCell)
                                docRef2.updateData(["namesOfCompletedTasks" : completedTasks])
                                docRef2.updateData(["usersOfCompletedTasks" : completedUsers])
                                self.updateCounts()
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
        super.viewDidLoad()
        scopeOfTasksButton.title = "Show Only My Tasks"
        addTaskView.isHidden = true
        pendingTableView.dataSource = self;
        updateCounts();
        pendingTableView.reloadData();
        pendingTableView.delegate = self;
        completedTableView.dataSource = self;
        completedTableView.reloadData();
        completedTableView.delegate = self;
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        scopeOfTasksButton.title = "Show Only My Tasks"
        updateCounts();
        completedTableView.reloadData();
        pendingTableView.reloadData();
    }

    override func viewDidAppear(_ animated: Bool) {
        scopeOfTasksButton.title = "Show Only My Tasks"
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
