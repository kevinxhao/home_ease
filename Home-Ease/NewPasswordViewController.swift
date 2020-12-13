//
//  NewPasswordViewController.swift
//  Home-Ease
//
//  Created by Krishna Vaidyanathan on 12/13/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class NewPasswordViewController: UIViewController {

    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func newPasswordConfirmed(_ sender: Any) {
        
        if (newPassword.text != repeatPassword.text)
        {
            let alert = UIAlertController(title: "Error", message: "Password did not match ", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
            
              self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Success", message: "Password Updated", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                         self.present(alert, animated: true, completion: nil)
            
            Auth.auth().currentUser?.updatePassword(to: newPassword.text ?? "") { (error) in
              // ...
            }
        }
        
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
