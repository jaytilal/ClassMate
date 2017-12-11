//
//  HomeViewController.swift
//  ClassMate
//
//  Created by Jayti Lal on 12/3/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
   
    let reuseIdentifier = "Cell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    let databaseRef = Database.database().reference()
    let user = (Auth.auth().currentUser?.email)!
    var GroupsList = [String]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.GroupsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
   
        cell.title.text = self.GroupsList[indexPath.item]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef.child("groups").queryOrdered(byChild: "name").observeSingleEvent(of: .value, with: { (snapShot) in
            
            if let snapDict = snapShot.value as? [String:AnyObject]{
                
                for each in snapDict{
                    let name = each.value["name"] as! String
                    let members = each.value["members"] as! [String]
                    if members.contains(self.user){
                        self.GroupsList.append(name)
                    }
                
                    print(self.GroupsList)
                    self.collectionView.reloadSections(IndexSet(integer : 0))
                }
            }
        }, withCancel: {(Err) in
            print(Err.localizedDescription)
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
