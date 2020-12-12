//
//  RentViewController.swift
//  Home-Ease
//
//  Created by Dhruv Patel on 11/25/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import Firebase

class RentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    @IBOutlet weak var currentBalance: UILabel!
    let users = ["Roommate 1", "Roommate 2", "Roommate 3"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    @IBAction func compose(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "popup") as! PopUpViewController
        var balance = currentBalance.text ?? ""
        balance.remove(at: balance.startIndex)
        if let bal = Double(balance) {
            vc.amounts[0] = bal
            vc.type = "Rent"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rentCell", for: indexPath) as! DetailedFinancesCollectionViewCell
        cell.nameLabel.text = users[indexPath.row]
        cell.mainView.layer.cornerRadius = 8
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 340, height: 138)
    }
    
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
}
