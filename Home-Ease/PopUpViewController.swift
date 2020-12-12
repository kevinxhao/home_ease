//
//  PopUpViewController.swift
//  Home-Ease
//
//  Created by Dhruv Patel on 12/10/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var date: UILabel!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func saveDate(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
