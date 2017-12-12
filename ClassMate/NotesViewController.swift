//
//  NotesViewController.swift
//  ClassMate
//
//  Created by Jayti Lal on 12/10/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class Note{
    var noteLabel = ""
    var noteDesc = ""
    var noteContent = ""
    var downloadUrl = ""
}

class NotesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    let databaseRef = Database.database().reference()
    let user = (Auth.auth().currentUser?.email)!
    var NotesList = [Note]()
     let reuseIdentifier = "NoteCell"
    var showNote = Note()
    @IBOutlet weak var collectionView: UICollectionView!
    var groupId : String = "" 
    
    @IBAction func LeaveGroup(_ sender: UIBarButtonItem) {
        databaseRef.child("groups").child(groupId).child("members").observe(.value, with: { snapshot in
            if let members = snapshot.value as? [String] {
                for i in 0..<members.count {
                    if members[i] == self.user {
                        self.databaseRef.child("groups").child(self.groupId).child("members").child("\(i)").removeValue()
                        self.showToast(message: "Left " + self.groupId)
                       self.performSegue(withIdentifier: "backToHome", sender: sender)
                    }
                }
            }
            
        })
        
    }
    
    @IBAction func addNewNote(_ sender: UIButton) {
        print("prepared")
        performSegue(withIdentifier: "toAddNote", sender: sender)
        print("sent")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddNote" {
            if let toViewController = segue.destination as? AddNoteViewController {
                toViewController.groupId = self.groupId
                print(toViewController.groupId)
            }
        }
        if segue.identifier == "toShowNote" {
            if let toViewController = segue.destination as? ShowNoteViewController {
                toViewController.DisplayNote = self.showNote
                print(toViewController.DisplayNote.noteLabel)
            }
        }
    }
    
    @IBAction func Back(_ sender: UIBarButtonItem) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
            print("Back")
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.NotesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! NoteViewCell
        
        cell.label.text = self.NotesList[indexPath.item].noteLabel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! NoteViewCell
        print(cell.label.text!)
        self.showNote = self.NotesList[indexPath.item]
        self.performSegue(withIdentifier: "toShowNote", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.NotesList = [Note]()
        databaseRef.child("groups").child(groupId).child("notes").observeSingleEvent(of: .value, with: { (snapShot) in
            
            if let snapDict = snapShot.value as? [String:AnyObject]{
                
                for each in snapDict{
                    let note = Note()
                    note.noteLabel = each.value["topic"] as! String
                    note.noteDesc = each.value["description"] as! String
                    note.noteContent = each.value["content"] as! String
                    note.downloadUrl = each.value["downloadURL"] as! String
                    self.NotesList.append(note)
                }
                self.collectionView.reloadSections(IndexSet(integer : 0))
            }
        }, withCancel: {(Err) in
            print(Err.localizedDescription)
            
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
