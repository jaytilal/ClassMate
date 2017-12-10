//
//  AddGroupViewController.swift
//  ClassMate
//
//  Created by Jayti Lal on 12/10/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddGroupViewController: UIViewController {

    @IBOutlet weak var GroupName: UITextField!
    @IBOutlet weak var Hashtags: UITextField!
    @IBOutlet weak var Members: UITextField!
    var ref:DatabaseReference!
    var MembersList = [String]()
    @IBAction func CreateGroup(_ sender: UIButton) {
    }
    
    
    @IBAction func SearchMembers(_ sender: UIButton) {
        if Members.text! != ""{
            let memberId = Members.text!
            let databaseRef = Database.database().reference()
            databaseRef.child("users").queryOrdered(byChild: "emailId").queryEqual(toValue: memberId).observeSingleEvent(of: .value, with: { (snapShot) in
                
                if let snapDict = snapShot.value as? [String:AnyObject]{
                    
                    for each in snapDict{
                        let key  = each.key
                        let email = each.value["emailId"] as! String
                        print(key)
                        print(email)
                        self.MembersList.append(email)
                        self.Members.text! = ""
                        self.showToast(message: "Member Added!")
                        
                    }
                }
            }, withCancel: {(Err) in
                
                print(Err.localizedDescription)
                
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2-125, y: self.view.frame.size.height/2-75, width: 250, height: 150))
        toastLabel.backgroundColor = UIColor.darkGray
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Calibri-Body", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}
