//
//  PopUpViewController.swift
//  Home-Ease
//
//  Created by Dhruv Patel on 12/10/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import Firebase

class PopUpViewController: UIViewController {


    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var inputAmount: UITextField!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var date: UILabel!
    var input = 0.00
    var amounts:[Double] = []
    var dates:[String] = []
    var type = ""
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func saveDate(_ sender: Any) {
        if errorLabel.isHidden == true {
            let dbGroups = Firestore.firestore().collection("groups")
            let dbUsers = Firestore.firestore().collection("users")
            let currentUser = Auth.auth().currentUser?.email
            let docRef = dbUsers.document(currentUser ?? "")
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let groupName = document.data()?["group"] as! String
                    dbGroups.document(groupName).updateData(["finances": self.amounts])
                }
                let date = self.datePicker.date
                self.dismiss(animated: true)
            }
        }
    }
    @IBAction func textField(_ sender: Any) {
        if let amount = Double(inputAmount.text ?? "") {
            input = amount
        }
        else {
            errorLabel.text = "Please enter a valid amount."
            errorLabel.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
    }
}
