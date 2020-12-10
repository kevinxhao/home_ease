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
    @IBAction func saveDate(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
