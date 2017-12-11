//
//  ShowNoteViewController.swift
//  ClassMate
//
//  Created by Jayti Lal on 12/11/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//

import UIKit

class ShowNoteViewController: UIViewController {

    @IBOutlet weak var Topic: UILabel!
    @IBOutlet weak var Content: UITextView!
    @IBOutlet weak var Description: UILabel!
    
    var DisplayNote = Note()
    override func viewDidLoad() {
        super.viewDidLoad()
        Topic.text = DisplayNote.noteLabel
        Content.text = DisplayNote.noteContent
        Description.text = DisplayNote.noteDesc
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
