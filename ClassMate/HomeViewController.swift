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

class HomeViewController: UIViewController {
    
    let databaseRef = Database.database().reference()
    let user = (Auth.auth().currentUser?.email)!
    var GroupsList = [String]()
    
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
