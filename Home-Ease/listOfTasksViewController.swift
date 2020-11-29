//
//  listOfTasksViewController.swift
//  Home-Ease
//
//  Created by Jackson Tidland on 11/28/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit



class listOfTasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        if tableView == self.completedTableView{
            return completedTasksRoommates.count
        }
        else if tableView == self.pendingTableView{
            return pendingTasksRoommates.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if tableView == self.completedTableView{
            myCell.textLabel!.text = "\(completedTasksRoommates[indexPath.row] ): \(completedTasksNames[indexPath.row] )"
        }
        else if tableView == self.pendingTableView{
            myCell.textLabel!.text = "\(pendingTasksRoommates[indexPath.row] ):  \(pendingTasksNames[indexPath.row] )"
        }
        return myCell
    }
    
    
    
    
    @IBOutlet weak var scopeOfTasksButton: UIBarButtonItem!
    
    @IBOutlet weak var weekLabel: UILabel!
    
    @IBAction func changeTasksShown(_ sender: Any) {
        if scopeOfTasksButton.title == "Show Only My Tasks"{
            scopeOfTasksButton.title = "Show All Tasks"
        }
        else if scopeOfTasksButton.title == "Show All Tasks"{
            scopeOfTasksButton.title = "Show Only My Tasks"
        }
    }
    @IBOutlet weak var taskField: UITextField!
    
    @IBAction func addNewTask(_ sender: Any) {
        addTaskView.isHidden = false
    }
    
    @IBAction func addTaskAndCloseSubview(_ sender: Any) {
        pendingTasksRoommates = UserDefaults.standard.object(forKey: "tasksRoommatesPending") as? [String] ?? []
        pendingTasksNames = UserDefaults.standard.object(forKey: "tasksNamesPending") as? [String] ?? []
        let newRoommateName = "Roommate"
        let newTaskName = taskField.text
        pendingTasksRoommates.append(newRoommateName)
        pendingTasksNames.append(newTaskName!)
        UserDefaults.standard.set(pendingTasksRoommates, forKey: "tasksRoommatesPending")
        UserDefaults.standard.set(pendingTasksNames, forKey: "tasksNamesPending")
        addTaskView.isHidden = true
        pendingTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        
        completedTasksNames = UserDefaults.standard.object(forKey:"tasksNamesCompleted") as? [String] ?? []
        completedTasksRoommates = UserDefaults.standard.object(forKey:"tasksRoommatesCompleted") as? [String] ?? []
        pendingTasksNames = UserDefaults.standard.object(forKey:"tasksNamesPending") as? [String] ?? []
        pendingTasksRoommates = UserDefaults.standard.object(forKey:"tasksRoommatesPending") as? [String] ?? []
        
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
