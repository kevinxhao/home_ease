//
//  FinancesViewController.swift
//  Home-Ease
//
//  Created by Dhruv Patel on 11/25/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import Firebase

class FinancesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let expenses = ["Total", "Rent", "Electricity", "Utility"]
    var count = 0
    var finances:[Double] = [0,0,0,0]
    var owed:[Double] = [0,0,0,0]
    let amounts = 0.00
    let backgroundColors:[UIColor] = [UIColor.init(red: 141/255, green: 144/255, blue: 226/255, alpha: 1),UIColor.init(red: 224/255, green: 187/255, blue: 228/255, alpha: 1),UIColor.init(red: 189/255, green: 152/255, blue: 224/155, alpha: 1),UIColor.init(red: 210/255, green: 145/255, blue: 188/255, alpha: 1)]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 340, height: 138)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "financeCell", for: indexPath) as! FinancesCollectionViewCell
        cell.mainView.bounds = cell.bounds
        cell.mainView.backgroundColor = backgroundColors[indexPath.row]
        cell.mainView.layer.cornerRadius = 8
        cell.label.text = expenses[indexPath.row]
        cell.label2.text = "Balance: "
        cell.label3.text = "You Owe: "
        if finances[indexPath.row] > 0 {
            cell.amount1.textColor = .red
            cell.amount2.textColor = .red
        }
        else {
            cell.amount1.textColor = .white
            cell.amount2.textColor = .white
        }
        cell.amount1.text = "$" + String(format:"%.02f", round(finances[indexPath.row]*100)/100)
        cell.amount2.text = "$" + String(format:"%.02f", round(owed[indexPath.row]*100)/100)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let vc = storyboard?.instantiateViewController(identifier: "rent") as! RentViewController
            navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2 {
            let vc = storyboard?.instantiateViewController(identifier: "electricity") as! ElectricityViewController
            navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3 {
            let vc = storyboard?.instantiateViewController(identifier: "utility") as! UtilityViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
                        self.finances = document2.data()?["finances"] as! [Double]
                        self.count = document2.data()?["count"] as! Int
                        self.finances.insert(self.finances[0]+self.finances[1]+self.finances[2], at: 0)
                        var owe:[Double] = []
                        for d in self.finances {
                            owe.append(d/Double(self.count))
                        }
                        self.owed = owe
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        
        // Do any additional setup after loading the view.
    }
}
