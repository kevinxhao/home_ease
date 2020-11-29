//
//  HomeViewController.swift
//  Home-Ease
//
//  Created by Snow Hao on 11/29/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    let infoLabels = ["Tasks to Complete", " Upcoming Bills", "Roommates"]
    let backgroundColors:[UIColor] = [UIColor.init(red: 224/255, green: 187/255, blue: 228/255, alpha: 1),UIColor.init(red: 149/255, green: 125/255, blue: 173/155, alpha: 1),UIColor.init(red: 210/255, green: 145/255, blue: 188/255, alpha: 1)]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 340, height: 138)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
        cell.homeInfoView.bounds = cell.bounds
        cell.homeInfoView.backgroundColor = backgroundColors[indexPath.row]
        cell.homeInfoView.layer.cornerRadius = 8
        cell.homeInfoLabel.text = infoLabels[indexPath.row]
       
        return cell

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //tasks to complete lead to task tab
          if indexPath.row == 0 {
        let listTasksVC = storyboard?.instantiateViewController(withIdentifier: "listTask") as! listOfTasksViewController
        navigationController?.pushViewController(listTasksVC, animated: true)
        }
        if indexPath.row == 1{
            let vc = storyboard?.instantiateViewController(identifier: "rent") as! RentViewController
            navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 2{
            let vc = storyboard?.instantiateViewController(identifier: "rommateTableView") as! RentViewController
            navigationController?.pushViewController(vc, animated: true)
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
