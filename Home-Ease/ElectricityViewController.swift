//
//  ElectricityViewController.swift
//  Home-Ease
//
//  Created by Dhruv Patel on 11/25/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import Firebase

class ElectricityViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var users = ["Roommate 1", "Roommate 2", "Roommate 3"]
    var curr = 0.0

    @IBOutlet weak var currentBalance: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBAction func compose(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "popup") as! PopUpViewController
        var balance = currentBalance.text ?? ""
        balance.remove(at: balance.startIndex)
        if let bal = Double(balance) {
            vc.amount = bal
            vc.type = 1
            navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "electricityCell", for: indexPath) as! DetailedFinancesCollectionViewCell
        cell.nameLabel.text = users[indexPath.row]
        cell.mainView.layer.cornerRadius = 8
        if (curr > 0) {
            cell.amountLabel.textColor = .red
        }
        else {
            cell.amountLabel.textColor = .black
        }
        cell.amountLabel.text = "$" + String(format:"%.02f", round(curr/Double(users.count)*100)/100)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         CGSize(width: 340, height: 138)
    }
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let dbGroups = Firestore.firestore().collection("groups")
        let dbUsers = Firestore.firestore().collection("users")
        let currentUser = Auth.auth().currentUser?.email
        let docRefUsers = dbUsers.document(currentUser ?? "")
        docRefUsers.getDocument { (document, error) in
            if let document = document, document.exists {
                let groupName = document.data()?["group"] as! String
                let docRefGroups = dbGroups.document(groupName)
                docRefGroups.getDocument { (document2, error2) in
                    if let document2 = document2, document2.exists {
                        let finances = document2.data()?["finances"] as! [Double]
                        self.curr = finances[1]
                        self.users = document2.data()?["roommateNames"] as! [String]
                        let strAmount = String(format:"%.02f", round(finances[1]*100)/100)
                        self.currentBalance.text = "$" + strAmount
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
}
