//
//  listOfTasksViewController.swift
//  Home-Ease
//
//  Created by Jackson Tidland on 11/28/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit



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
        
    var completedTasksRoommates: [String] = UserDefaults.standard.object(forKey: "tasksRoommatesCompleted") as? [String] ?? []
    
    var completedTasksNames: [String] = UserDefaults.standard.object(forKey: "tasksNamesCompleted") as? [String] ?? []
    
    var pendingTasksRoommates: [String] = UserDefaults.standard.object(forKey: "tasksRoommatesPending") as? [String] ?? []
    
     var pendingTasksNames: [String] = UserDefaults.standard.object(forKey: "tasksNamesPending") as? [String] ?? []
       
    struct Task {
        var roommateName: String!
        var taskName: String!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       /* if showOnlyMine{
            let currentUser = "Jackson"
            for i in 0..<completedTasksNames.count{
                if(completedTasksRoommates[i] == currentUser){
                    myCompletedTasksNames.append(completedTasksNames[i])
                }
            }
            for i in 0..<pendingTasksNames.count{
                if(pendingTasksRoommates[i] == currentUser){
                    myPendingTasksNames.append(pendingTasksNames[i])
                }
            }
            if tableView == self.completedTableView{
                return myCompletedTasksNames.count;
            }
            else if tableView == self.pendingTableView{
                return myPendingTasksNames.count;
            }
        }
        else{*/
        //I consulted this when I was unsure about how to set up multiple table cells within the same view controller: https://stackoverflow.com/questions/37447124/how-do-i-create-two-table-views-in-one-view-controller-with-two-custom-uitablevi
            if tableView == self.completedTableView{
                return completedTasksRoommates.count
            }
            else if tableView == self.pendingTableView{
                return pendingTasksRoommates.count
            }
        //}
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        completedTasksNames = UserDefaults.standard.object(forKey:"tasksNamesCompleted") as? [String] ?? []
        completedTasksRoommates = UserDefaults.standard.object(forKey:"tasksRoommatesCompleted") as? [String] ?? []
        pendingTasksNames = UserDefaults.standard.object(forKey:"tasksNamesPending") as? [String] ?? []
        pendingTasksRoommates = UserDefaults.standard.object(forKey:"tasksRoommatesPending") as? [String] ?? []
        myCompletedTasksNames = []
        myPendingTasksNames = []
        let currentUser = "Jackson"
        for i in 0..<completedTasksRoommates.count{
            if(completedTasksRoommates[i] == currentUser){
                myCompletedTasksNames.append(completedTasksNames[i])
            }
        }
        for i in 0..<pendingTasksRoommates.count{
            if(pendingTasksRoommates[i] == currentUser){
                myPendingTasksNames.append(pendingTasksNames[i])
            }
        }
     /*   if showOnlyMine{
            if tableView == self.completedTableView{
                myCell.textLabel!.text = "\(myCompletedTasksNames[indexPath.row])"
            }
            else if tableView == self.pendingTableView{
                myCell.textLabel!.text = "\(myPendingTasksNames[indexPath.row])"
            }
        }
        else{*/
            if tableView == self.completedTableView{
                myCell.textLabel!.text = "\(completedTasksNames[indexPath.row])"
            }
            else if tableView == self.pendingTableView{
                myCell.textLabel!.text = "\(pendingTasksNames[indexPath.row])"
            }
        //}
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
    /*
    @IBAction func markAllAsCompleted(_ sender: Any) {
        completedTasksNames = UserDefaults.standard.object(forKey:"tasksNamesCompleted") as? [String] ?? []
        completedTasksRoommates = UserDefaults.standard.object(forKey:"tasksRoommatesCompleted") as? [String] ?? []
        pendingTasksNames = UserDefaults.standard.object(forKey:"tasksNamesPending") as? [String] ?? []
        pendingTasksRoommates = UserDefaults.standard.object(forKey:"tasksRoommatesPending") as? [String] ?? []
        
        for i in 0..<pendingTasksRoommates.count-1{
            if(pendingTasksRoommates[i] == "Jackson"){
                completedTasksRoommates.append(pendingTasksRoommates[i])
                completedTasksNames.append(pendingTasksNames[i])
                pendingTasksRoommates.remove(at: i)
                pendingTasksNames.remove(at: i)
            }
        }
        UserDefaults.standard.set(pendingTasksRoommates, forKey: "tasksRoommatesPending")
        UserDefaults.standard.set(pendingTasksNames, forKey: "tasksNamesPending")
        UserDefaults.standard.set(completedTasksRoommates, forKey: "tasksRoommatesCompleted")
        UserDefaults.standard.set(completedTasksNames, forKey: "tasksNamesCompleted")
        pendingTableView.reloadData()
        completedTableView.reloadData()
    }*/
    
    @IBOutlet weak var taskField: UITextField!
    
    @IBOutlet weak var roommateField: UITextField!
    
    @IBAction func addNewTask(_ sender: Any) {
        addTaskView.isHidden = false
    }
    
    @IBAction func addTaskAndCloseSubview(_ sender: Any) {
        pendingTasksRoommates = UserDefaults.standard.object(forKey: "tasksRoommatesPending") as? [String] ?? []
        pendingTasksNames = UserDefaults.standard.object(forKey: "tasksNamesPending") as? [String] ?? []
        let newRoommateName = roommateField.text
        let newTaskName = taskField.text
        pendingTasksRoommates.append(newRoommateName!)
        pendingTasksNames.append(newTaskName!)
        print("pending Tasks roommates:  \(pendingTasksRoommates)")
        print("pending Tasks Names:  \(pendingTasksNames)")
        UserDefaults.standard.set(pendingTasksRoommates, forKey: "tasksRoommatesPending")
        UserDefaults.standard.set(pendingTasksNames, forKey: "tasksNamesPending")
        addTaskView.isHidden = true
        taskField.text = ""
        roommateField.text = ""
        pendingTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /*UserDefaults.standard.set([], forKey: "tasksRoommatesPending")
        UserDefaults.standard.set([], forKey: "tasksNamesPending")
        UserDefaults.standard.set([], forKey: "tasksRoommatesCompleted")
        UserDefaults.standard.set([], forKey: "tasksNamesCompleted")*/
        scopeOfTasksButton.title = "Show Only My Tasks"
        addTaskView.isHidden = true
   //     markAllAsCompletedBtn.isHidden = true
        pendingTableView.dataSource = self;
        pendingTableView.reloadData();
        pendingTableView.delegate = self;
        completedTableView.dataSource = self;
        completedTableView.reloadData();
        completedTableView.delegate = self;
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        scopeOfTasksButton.title = "Show Only My Tasks"
       // markAllAsCompletedBtn.isHidden = true
        completedTasksNames = UserDefaults.standard.object(forKey:"tasksNamesCompleted") as? [String] ?? []
        completedTasksRoommates = UserDefaults.standard.object(forKey:"tasksRoommatesCompleted") as? [String] ?? []
        pendingTasksNames = UserDefaults.standard.object(forKey:"tasksNamesPending") as? [String] ?? []
        pendingTasksRoommates = UserDefaults.standard.object(forKey:"tasksRoommatesPending") as? [String] ?? []
        
        completedTableView.reloadData();
        pendingTableView.reloadData();
    }

    override func viewDidAppear(_ animated: Bool) {
     //   markAllAsCompletedBtn.isHidden = true
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
