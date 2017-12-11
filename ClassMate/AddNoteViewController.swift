//
//  AddNoteViewController.swift
//  ClassMate
//
//  Created by Jayti Lal on 12/10/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class AddNoteViewController: UIViewController {
    @IBOutlet weak var noteTopic: UITextField!
    @IBOutlet weak var noteDescription: UITextField!
    let databaseRef = Database.database().reference()
    let user = (Auth.auth().currentUser?.email)!
    var groupId : String!
    @IBOutlet weak var noteContents: UITextView!
    
    @IBAction func Back(_ sender: UIBarButtonItem) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
            print("Back")
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func addNote(){
        print("inside add note")
        print(groupId)
        let reference = databaseRef.child("groups").child(groupId).child("notes")
        let key = reference.childByAutoId().key;
        let note = ["id":key,
                    "topic": noteTopic.text!,
                    "description": noteDescription.text!,
                    "content": noteContents.text!
        ]
      
        reference.child(key).setValue(note)
        
    }
    @IBAction func addNoteToDB(_ sender: UIButton) {
        addNote()
        print("note added to Database")
        self.showToast(message: "Note Added!")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        print(groupId!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
