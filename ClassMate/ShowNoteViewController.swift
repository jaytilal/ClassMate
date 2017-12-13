//
//  ShowNoteViewController.swift
//  ClassMate
//
//  Created by Jayti Lal on 12/11/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//

import UIKit

class ShowNoteViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    @IBOutlet weak var Topic: UILabel!
    @IBOutlet weak var Content: UITextView!
    @IBOutlet weak var Description: UILabel!
    
    @IBOutlet weak var thumbnails: UICollectionView!
    var url = [String]()
    var DisplayNote = Note()
    let reuseidentifier = "thumbnail"
    var downloadLink = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Topic.text = DisplayNote.noteLabel
        Content.text = DisplayNote.noteContent
        Description.text = DisplayNote.noteDesc
        url = DisplayNote.downloadUrl
        self.thumbnails.reloadSections(IndexSet(integer : 0))
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing to go to image")
        if segue.identifier == "toShowImage" {
            if let toViewController = segue.destination as? DisplayImageViewController {
                toViewController.Url = self.downloadLink
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseidentifier, for: indexPath as IndexPath) as! ImageCollectionViewCell
        cell.downloadUrl = self.url[indexPath.item]
        cell.ImageThumbnail.imageFromServerURL(urlString: cell.downloadUrl)
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.url.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        print(cell.downloadUrl)
        self.downloadLink = cell.downloadUrl
        print("Image Tapped")
        self.performSegue(withIdentifier: "toShowImage", sender: self)
    }
    

}
