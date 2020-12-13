//
//  UserSettingsViewController.swift
//  Home-Ease
//
//  Created by Krishna Vaidyanathan on 12/13/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI


class UserSettingsViewController: UIViewController {

    @IBOutlet weak var currentUsername: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayUsername()
        // Do any additional setup after loading the view.
    }
    
    func displayUsername(){
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          
          let email = user.email
        
          var multiFactorString = "MultiFactor: "
          for info in user.multiFactor.enrolledFactors {
            multiFactorString += info.displayName ?? "[DispayName]"
            multiFactorString += " "
          }
        }
        currentUsername.text = email
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
