//
//  HomeViewController.swift
//  Home-Ease
//
//  Created by Snow Hao on 11/29/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    var tasks: [String] = []
    //var taskUsers: [String] = []
    var count: Int = 1
    var finances: [Int] = []
    var groupName: String = ""
    var userTotal: Float = 0
    var nextTask = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    let infoLabels = ["Next Task", "Your Balance", "Group"]
    let backgroundColors:[UIColor] = [UIColor.init(red: 224/255, green: 187/255, blue: 228/255, alpha: 1),UIColor.init(red: 149/255, green: 125/255, blue: 173/155, alpha: 1),UIColor.init(red: 210/255, green: 145/255, blue: 188/255, alpha: 1)]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 340, height: 180)
    }
    func getUserInfo(){
        let currentUser = Auth.auth().currentUser?.email ?? ""
        let userInfo = Firestore.firestore().collection("users").document(currentUser)
        userInfo.getDocument { (document, error) in
            if let document = document, document.exists{
                let group = document.data()!["group"] ?? ""
                let groupInfo = Firestore.firestore().collection("groups").document(group as! String)
                groupInfo.getDocument { (groupDocument, groupError) in
                    if let groupDocument = groupDocument, groupDocument.exists{
                        self.tasks = (groupDocument.data()!["namesOfPendingTasks"] ?? []) as! [String]
                        //self.taskUsers = (groupDocument.data()!["usersOfPendingTasks"] ?? []) as! [String]
                        self.count = groupDocument.data()?["count"] as! Int
                        self.finances = (groupDocument.data()!["finances"] ?? []) as! [Int]
                        self.groupName = (document.data()!["group"] ?? []) as! String
                    
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    //set labels here
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCollectionViewCell
        cell.homeInfoView.bounds = cell.bounds
        cell.homeInfoView.backgroundColor = backgroundColors[indexPath.row]
        cell.homeInfoView.layer.cornerRadius = 8
        cell.homeInfoLabel.text = infoLabels[indexPath.row]
        
        let sum = finances.reduce(0, +)
        
        let userTotal = sum / self.count
        
        
        if indexPath.row == 0 {
            if(tasks.count != 0){
            cell.homeExtraInfoLabel.text = "\(tasks[0])"
            }
            else{
            cell.homeExtraInfoLabel.text = "No Tasks To Do"
            }
        }
        if indexPath.row == 1 {
            cell.homeExtraInfoLabel.text = "\(userTotal)"
             }
        if indexPath.row == 2 {
            cell.homeExtraInfoLabel.text = groupName
             }
        
        
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           //tasks to complete lead to task tab
             if indexPath.row == 0 {
           let listTasksVC = storyboard?.instantiateViewController(withIdentifier: "listTask") as! listOfTasksViewController
           navigationController?.pushViewController(listTasksVC, animated: true)
           }
           if indexPath.row == 1{
               let vc = storyboard?.instantiateViewController(identifier: "finances") as! FinancesViewController
               navigationController?.pushViewController(vc, animated: true)
           }
           if indexPath.row == 2{
               let vc = storyboard?.instantiateViewController(identifier: "roommateView") as! RoommateViewController
               navigationController?.pushViewController(vc, animated: true)
           }
           
       }
       
    

    override func viewDidLoad() {
        DispatchQueue.global(qos: .background).async {
        self.getUserInfo()
        DispatchQueue.main.async {
            super.viewDidLoad()
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.reloadData()
        }
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
}
