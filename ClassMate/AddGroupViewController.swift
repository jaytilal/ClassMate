//
//  AddGroupViewController.swift
//  ClassMate
//
//  Created by Jayti Lal on 12/10/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class AddGroupViewController: UIViewController {

    @IBOutlet weak var GroupName: UITextField!
    @IBOutlet weak var Hashtags: UITextField!
    @IBOutlet weak var Members: UITextField!
    let databaseRef = Database.database().reference()
    var MembersList = [String]()
    
    @IBOutlet weak var CreateButton: UIButton!
    
    @IBOutlet weak var AddButton: UIButton!
    @IBAction func CreateGroup(_ sender: UIButton) {
        MembersList.append((Auth.auth().currentUser?.email)!)
        let reference = databaseRef.child("groups")
        let key = reference.childByAutoId().key;
        let group = ["id":key,
                    "name": GroupName.text!,
                    "hashtags": Hashtags.text!,
                    "members" : MembersList
            ] as [String : Any]
        print("Group added to Database")
        reference.child(GroupName.text!).setValue(group)
        self.showToast(message: "Group Created!")
    }
    
    
    @IBAction func SearchMembers(_ sender: UIButton) {
        if Members.text! != ""{
            let memberId = Members.text!
            databaseRef.child("users").queryOrdered(byChild: "emailId").observeSingleEvent(of: .value, with: { (snapShot) in
                
                if let snapDict = snapShot.value as? [String:AnyObject]{
                    var count = 0
                    for each in snapDict{
                        let key  = each.key
                        let email = each.value["emailId"] as! String
                        if self.Members.text! == email{
                            if self.MembersList.contains(email){
                                self.showToast(message: "Member already exists")
                                self.Members.text! = ""
                                return
                            }
                            else{
                                self.MembersList.append(email)
                                self.Members.text! = ""
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CreateButton.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
        self.AddButton.layer.cornerRadius = 15
    }

    @IBAction func Back(_ sender: UIBarButtonItem) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
            print("Back")
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
