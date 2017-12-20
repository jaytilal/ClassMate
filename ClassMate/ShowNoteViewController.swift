//
//  ShowNoteViewController.swift
//  ClassMate
//
//  Created by Jayti Lal on 12/11/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ShowNoteViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    @IBOutlet weak var Content: UITextView!
    @IBOutlet weak var thumbnails: UICollectionView!
    @IBOutlet weak var Topic: UILabel!
    @IBOutlet weak var Description: UITextField!
    
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var AddButton: UIButton!
    var url = [String]()
    var DisplayNote = Note()
    let reuseidentifier = "thumbnail"
    var downloadLink = ""
    var group = ""
    var key = ""
    let databaseRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Topic.text = DisplayNote.noteLabel
        Content.text = DisplayNote.noteContent
        Description.text = DisplayNote.noteDesc
        group = DisplayNote.group
        key = DisplayNote.key
        url = DisplayNote.downloadUrl
        self.AddButton.layer.cornerRadius = 15
        self.SaveButton.layer.cornerRadius = 15
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.reloadInputViews()
        self.thumbnails.reloadSections(IndexSet(integer : 0))
    }
    
    @IBAction func UploadAttachment(_ sender: UIButton) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addNote(){
        print("inside add note")
        let reference = databaseRef.child("groups").child(self.group).child("notes").child(self.key)
       
        
        let note = ["id":self.key,
                    "topic": Topic.text!,
                    "description": Description.text!,
                    "content": Content.text!,
                    "downloadURL" : self.url
            ] as [String : Any]
        
        reference.setValue(note)
        
    }
    @IBAction func SaveChanges(_ sender: UIButton) {
        addNote()
        showToast(message: "Saved Changes!")
        thumbnails.reloadData()
        thumbnails.reloadSections(IndexSet(integer : 0))
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
    
    func uploadImage(_ image: UIImage, progressBlock: @escaping (_ percentage: Double) -> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let imageName = "\(Date().timeIntervalSince1970).jpg"
        let imagesReference = storageReference.child(Constants.Images.imagesFolder).child(imageName)
        
        if let imageData = UIImageJPEGRepresentation(image, 0.8) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = imagesReference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    self.showToast(message: "Image Uploaded! Click save to retain changes.")
                    completionBlock(metadata.downloadURL(), nil)
                } else {
                    completionBlock(nil, error?.localizedDescription)
                }
            })
            uploadTask.observe(.progress, handler: { (snapshot) in
                guard let progress = snapshot.progress else {
                    return
                }
                
                let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
                progressBlock(percentage)
            })
        } else {
            completionBlock(nil, "Image couldn't be converted to Data.")
        }
        thumbnails.reloadData()
        thumbnails.reloadSections(IndexSet(integer : 0))
        reloadInputViews()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension ShowNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            print("Image Selected")
            self.uploadImage(image, progressBlock: { (percentage) in
                print(percentage)
            }, completionBlock: { [weak self] (fileURL, errorMessage) in
                guard self != nil else {
                    return
                }
                self?.url.append(fileURL!.absoluteString)
                print((fileURL?.absoluteString)!)
                print(errorMessage ?? "No error")
                
            })
        }
    }
    
}

