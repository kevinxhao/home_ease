//
//  TasksViewController.swift
//  Home-Ease
//
//  Created by Jackson Tidland on 11/27/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit
import Firebase


class TasksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var taskCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = taskCollectionView.dequeueReusableCell(withReuseIdentifier: "TaskCollectionViewCell", for: indexPath) as! TaskCollectionViewCell
        var myCellFrame = CGRect()
        if(indexPath.row == 0){
            myCellFrame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width-35, height: taskCollectionView.frame.height/2 - 10)
            myCell.weekLabel.text = "This Week"
        }
        else if(indexPath.row == 1){
            myCellFrame = CGRect(x: view.frame.minX, y: taskCollectionView.frame.height/2 + 10, width: view.frame.width-35, height: taskCollectionView.frame.height/2 - 10)
            myCell.weekLabel.text = "Next Week"
        }
        myCell.frame = myCellFrame
        myCell.backgroundColor = .white
        //I consulted https://stackoverflow.com/questions/49935711/adding-borders-on-collectionview-cell to see if there was a way to add borders to collection view cells
        myCell.layer.borderColor = UIColor.black.cgColor
        myCell.layer.borderWidth = 1
        
        return myCell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let listTasksVC = storyboard?.instantiateViewController(withIdentifier: "listTask") as! listOfTasksViewController
        navigationController?.pushViewController(listTasksVC, animated: true)
        let username = Auth.auth().currentUser!.email!
        print("username is : \(username)")
        print("query: ")
        let docRef = Firestore.firestore().collection("users").document(username)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                /*for i in 0..<dataDescription.count{
                    print("index: \(i)")
                    print("value: \(dataDescription[i])")
                }*/
                
                print("Document uid: \(document.data()!["uid"] ?? "")")
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    func setUpCollectionView(){
        taskCollectionView.dataSource = self
        taskCollectionView.delegate = self
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
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
