//
//  EditGroupViewController.swift
//  ClassMate
//
//  Created by Jayti Lal on 12/12/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EditGroupViewController: UIViewController {
    var groupId : String = ""
    @IBOutlet weak var GroupName: UITextField!
    @IBOutlet weak var Member: UITextField!
    @IBOutlet weak var GroupDescription: UITextField!
    let databaseRef = Database.database().reference()
    let user = (Auth.auth().currentUser?.email)!
    var members = [String]()
    var newMembers = [String]()
    
    @IBOutlet weak var AddMember: UIButton!
    @IBOutlet weak var Save: UIButton!
    
    @IBAction func addMember(_ sender: UIButton) {
        if Member.text! != ""{
            let memberId = Member.text!
            databaseRef.child("users").queryOrdered(byChild: "emailId").observeSingleEvent(of: .value, with: { (snapShot) in
                
                if let snapDict = snapShot.value as? [String:AnyObject]{
                var count = 0
                    for each in snapDict{
                        let key  = each.key
                        let email = each.value["emailId"] as! String
                        if self.Member.text! == email{
                            if self.members.contains(email){
                                self.showToast(message: "Member already exists")
                                self.Member.text! = ""
                                return
                            }
                            else{
                                self.members.append(email)
                                self.Member.text! = ""
                                self.showToast(message: "Member Added!")
                            }
                        }
                        else{
                            count = count + 1
                        }
                    }
                   
                    if count == snapDict.count{
                        self.showToast(message: "User not found")
                    }
                }
            }, withCancel: {(Err) in
                print(Err.localizedDescription)
                
            })
        }
       
    }
    
    @IBAction func SaveChanges(_ sender: UIButton) {
        let ref = self.databaseRef.child("groups").child(groupId)
        ref.child("members").setValue(members)
        print(members)
        ref.child("hashtags").setValue(GroupDescription.text!)
        ref.child("name").setValue(GroupName.text!)
        self.showToast(message: "Saved Changes!")
        reloadInputViews()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AddMember.layer.cornerRadius = 15
        self.Save.layer.cornerRadius = 15
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
     
        self.reloadInputViews()
        databaseRef.child("groups").child(groupId).observeSingleEvent(of: .value, with: { (snapShot) in
            let snap = snapShot.value as?  [String: AnyObject]
            if snapShot.hasChild("name"){
                let name = snap!["name"] as? String ?? ""
                self.GroupName.text = name
            }
            if snapShot.hasChild("hashtags"){
                let desc = snap!["hashtags"] as? String ?? ""
                self.GroupDescription.text = desc
            }
            if snapShot.hasChild("members"){
                if let val =  snapShot.childSnapshot(forPath: "members").value as? [String]{
                    self.members = val
                }
            }
            

        }, withCancel: {(Err) in
            print(Err.localizedDescription)
            
        })
        
        self.reloadInputViews()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
