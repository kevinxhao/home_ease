//
//  WelcomePageViewController.swift
//  Home-Ease
//
//  Created by Snow Hao on 12/13/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 21/255, green: 50/255, blue: 104/255, alpha: 1)
        // Do any additional setup after loading the view.
    }
}
