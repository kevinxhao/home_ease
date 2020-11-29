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
        
    var completedTasks: [Task] = UserDefaults.standard.object(forKey: "tasksCompleted") as? [Task] ?? []
    
    var pendingTasks: [Task] = UserDefaults.standard.object(forKey: "tasksPending") as? [Task] ?? []
       
    struct Task {
        let roommateName: String!
        let taskName: String!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.completedTableView{
            return completedTasks.count
        }
        else if tableView == self.pendingTableView{
            return pendingTasks.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if tableView == self.completedTableView{
            myCell.textLabel!.text = "\(completedTasks[indexPath.row].roommateName ?? "") \(completedTasks[indexPath.row].taskName ?? "")"
        }
        else if tableView == self.pendingTableView{
            myCell.textLabel!.text = "\(pendingTasks[indexPath.row].roommateName ?? "") \(pendingTasks[indexPath.row].taskName ?? "")"
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
    
    @IBAction func addNewTask(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        
        completedTasks = UserDefaults.standard.object(forKey:"tasksCompleted") as? [Task] ?? []
        
        pendingTasks = UserDefaults.standard.object(forKey: "tasksPending") as? [Task] ?? []
        
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
