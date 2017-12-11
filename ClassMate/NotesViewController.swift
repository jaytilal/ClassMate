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


class NotesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    let databaseRef = Database.database().reference()
    let user = (Auth.auth().currentUser?.email)!
    var NotesList = [String]()
     let reuseIdentifier = "NoteCell"
    @IBOutlet weak var collectionView: UICollectionView!
    var groupId : String = "" 
    
        
    @IBAction func addNewNote(_ sender: UIButton) {
        print("prepared")
        performSegue(withIdentifier: "toAddNote", sender: sender)
        print("sent")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing to add new note")
        if segue.identifier == "toAddNote" {
            if let toViewController = segue.destination as? AddNoteViewController {
                toViewController.groupId = self.groupId
                print(toViewController.groupId)
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
        
        cell.label.text = self.NotesList[indexPath.item]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef.child("groups").child(groupId).child("notes").observeSingleEvent(of: .value, with: { (snapShot) in
            
            if let snapDict = snapShot.value as? [String:AnyObject]{
                
                for each in snapDict{
                    let name = each.value["topic"] as! String
                    self.NotesList.append(name)
                    self.collectionView.reloadSections(IndexSet(integer : 0))
                }
            }
        }, withCancel: {(Err) in
            print(Err.localizedDescription)
            
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
