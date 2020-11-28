//
//  FinancesViewController.swift
//  Home-Ease
//
//  Created by Dhruv Patel on 11/25/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit

class FinancesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let expenses = ["Rent", "Electricity", "Utility"]
    let identifiers = ["rent", "electricity", "utility"]
    let amounts = 0.01
    let backgroundColors:[UIColor] = [UIColor.init(red: 224/255, green: 187/255, blue: 228/255, alpha: 1),UIColor.init(red: 149/255, green: 125/255, blue: 173/155, alpha: 1),UIColor.init(red: 210/255, green: 145/255, blue: 188/255, alpha: 1)]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var venmoView: UIView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
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
        cell.label2.text = "Amount: "
        cell.label3.text = "You Owe: "
        if amounts > 0 {
            cell.amount1.textColor = .red
            cell.amount2.textColor = .red
        }
        cell.amount1.text = "$" + String(format:"%.02f", round(amounts*100)/100)
        cell.amount2.text = "$" + String(format:"%.02f", round(amounts*100)/100)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = storyboard?.instantiateViewController(identifier: "rent") as! RentViewController
            vc.title = "Rent"
            navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1 {
            let vc = storyboard?.instantiateViewController(identifier: "electricity") as! ElectricityViewController
            vc.title = "Electricity"
            navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2 {
            let vc = storyboard?.instantiateViewController(identifier: "utility") as! UtilityViewController
            vc.title = "Utility"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func setUpLabels() {
        venmoView.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpLabels()
        
        // Do any additional setup after loading the view.
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
