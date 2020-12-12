//
//  PopUpViewController.swift
//  Home-Ease
//
//  Created by Dhruv Patel on 12/10/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {


    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var inputAmount: UITextField!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var date: UILabel!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func saveDate(_ sender: Any) {
        let date = datePicker.date
        dismiss(animated: true)
    }
    @IBAction func textField(_ sender: Any) {
        if let amount = Double(inputAmount.text ?? "") {
            
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
