//
//  SettingsTableViewController.swift
//  Home-Ease
//
//  Created by Krishna Vaidyanathan on 11/29/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SettingsTableViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signOutButtonTapped(_ sender: Any) {
      let firebaseAuth = Auth.auth()
        do {
        try firebaseAuth.signOut()
        } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
        }
       
        let vc = storyboard?.instantiateViewController(identifier: "WelcomeVC") as! WelcomePageViewController
        navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    

}
