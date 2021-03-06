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


struct Constants {
    
    struct Images {
        static let imagesFolder: String = "images"
    }
    
}

class AddNoteViewController: UIViewController {
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noteTopic: UITextField!
    @IBOutlet weak var noteDescription: UITextField!
    let databaseRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    let user = (Auth.auth().currentUser?.email)!
    var groupId : String!
    @IBOutlet weak var noteContents: UITextView!
    var downloadURL = [String]()
    
    @IBOutlet weak var Submit: UIButton!
    @IBOutlet weak var AddImage: UIButton!
    
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
                    "content": noteContents.text!,
                    "downloadURL" : downloadURL
            ] as [String : Any]
      
        reference.child(key).setValue(note)
        
    }
    func uploadImage(_ image: UIImage, progressBlock: @escaping (_ percentage: Double) -> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
         let imageName = "\(Date().timeIntervalSince1970).jpg"
        let imagesReference = storageReference.child(Constants.Images.imagesFolder).child(imageName)
        
        if let imageData = UIImageJPEGRepresentation(image, 0.8) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            let uploadTask = imagesReference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata {
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
    }
    

    
    @IBAction func uploadAttachment(_ sender: UIButton) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
        
        print(self.downloadURL)
    }
    
    @IBAction func addNoteToDB(_ sender: UIButton) {
        addNote()
        print("note added to Database")
        self.showToast(message: "Note Added!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        self.activityIndicator.isHidden = true
        print(groupId!)
        self.AddImage.layer.cornerRadius = 15
        self.Submit.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension AddNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
                self?.activityIndicator.stopAnimating()
                self?.showToast(message: "Image Uploaded! Click save to retain changes.")
                self?.downloadURL.append(fileURL!.absoluteString)
                print((fileURL?.absoluteString)!)
                print(errorMessage ?? "No error")
                
                
            })
        }
    }
    
}


