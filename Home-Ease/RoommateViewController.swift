//
//  RoommateViewController.swift
//  Home-Ease
//
//  Created by Snow Hao on 11/29/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import Firebase

class RoommateViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var roommateCollectionView: UICollectionView!
    
    var users: [String] = []
    
    func getUsers(){
       let currentUser = Auth.auth().currentUser?.email ?? ""
        let userInfo = Firestore.firestore().collection("users").document(currentUser)
        userInfo.getDocument { (document, error) in
            if let document = document, document.exists{
                let group = document.data()!["group"] ?? ""
                let groupInfo = Firestore.firestore().collection("groups").document(group as! String)
                groupInfo.getDocument { (groupDocument, groupError) in
                    if let groupDocument = groupDocument, groupDocument.exists{
                        self.users = (groupDocument.data()!["roommateNames"] ?? []) as! [String]
                        self.roommateCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoommateViewCell", for: indexPath) as! RoommateCollectionViewCell
        cell.roommateNameLabel.text = users[indexPath.row]
        return cell
    }
    
    
    override func viewDidLoad() {
        DispatchQueue.global(qos: .background).async {
            self.getUsers()
            DispatchQueue.main.async {
                super.viewDidLoad()
                self.roommateCollectionView.dataSource = self
                self.roommateCollectionView.delegate = self
                self.roommateCollectionView.reloadData()
            }
            // Do any additional setup after loading the view.
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
