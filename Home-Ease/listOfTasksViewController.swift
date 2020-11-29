//
//  listOfTasksViewController.swift
//  Home-Ease
//
//  Created by Jackson Tidland on 11/28/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit

class listOfTasksViewController: UIViewController {
    
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
