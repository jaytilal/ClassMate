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
    var groupName : String = ""
    
    @IBAction func EditGroup(_ sender: UIButton) {
        groupName = (sender.layer.value(forKey: "GroupName") as! String)
        print("Going to Edit")
        print(groupName)
        performSegue(withIdentifier: "toEditGroup", sender: sender)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.GroupsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CollectionViewCell
        
        cell.title.text = self.GroupsList[indexPath.item]
        cell.Edit.layer.setValue(cell.title.text, forKey: "GroupName")
        cell.Edit.addTarget(self, action: "EditGroup:", for: UIControlEvents.touchUpInside)

        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAllNotes" {
            if let toViewController = segue.destination as? NotesViewController {
                toViewController.groupId = groupName
                print(toViewController.groupId)
            }
        }
        if segue.identifier == "toEditGroup"{
            if let toViewController = segue.destination as? EditGroupViewController {
                toViewController.groupId = groupName
                print(toViewController.groupId)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        print(cell.title.text!)
        groupName = cell.title.text!
        self.performSegue(withIdentifier: "toAllNotes", sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.GroupsList = [String]()
        databaseRef.child("groups").queryOrdered(byChild: "name").observeSingleEvent(of: .value, with: { (snapShot) in
            if let snapDict = snapShot.value as? [String:AnyObject]{
                
                for each in snapDict{
                    let name = each.value["name"] as! String
                    let members = each.value["members"]! as! [String]!
                    if (members?.contains(self.user))!{
                        self.GroupsList.append(name)
                    }
                    self.collectionView.reloadSections(IndexSet(integer : 0))
                }
                print("Home")
                print(self.GroupsList)
            }
        }, withCancel: {(Err) in
            print(Err.localizedDescription)
            
        })
    }
    
    
    @IBAction func SignOut(_ sender: UIBarButtonItem) {
        
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "toLogin", sender: sender)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
