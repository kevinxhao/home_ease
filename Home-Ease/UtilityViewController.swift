//
//  UtilityViewController.swift
//  Home-Ease
//
//  Created by Dhruv Patel on 11/25/20.
//  Copyright © 2020 Dhruv Patel. All rights reserved.
//

import UIKit

class UtilityViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let users = ["Roommate 1", "Roommate 2", "Roommate 3"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "utilityCell", for: indexPath) as! DetailedFinancesCollectionViewCell
//        cell.imageView.layer.cornerRadius = 0.5*cell.imageView.bounds.size.width
//        cell.imageView.clipsToBounds = true
//        cell.imageView.image = UIImage.init(named: "Profile")
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
        // Do any additional setup after loading the view.
        setUpCollectionView()
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
