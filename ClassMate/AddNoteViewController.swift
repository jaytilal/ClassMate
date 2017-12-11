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
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var hashtags: UITextField!
    @IBOutlet weak var content: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func UploadAttachment(_ sender: UIButton) {
        
    }    
}
