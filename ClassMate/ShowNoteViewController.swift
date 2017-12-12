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
    @IBOutlet weak var Image: UIImageView!
    var url = ""
    var DisplayNote = Note()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Topic.text = DisplayNote.noteLabel
        Content.text = DisplayNote.noteContent
        Description.text = DisplayNote.noteDesc
        url = DisplayNote.downloadUrl
        if url != ""{
            getImage(url: url)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ShowNoteViewController.imageTapped(gesture:)))
            Image.addGestureRecognizer(tapGesture)
            Image.isUserInteractionEnabled = true
        }
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            self.performSegue(withIdentifier: "toShowImage", sender: self)
        }
    }
    func getImage(url : String) {
        let PictureURL = URL(string: url)!
    
        let session = URLSession(configuration: .default)
        var image = UIImage()
       let downloadPicTask = session.dataTask(with:PictureURL) { (data, response, error) in
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded  picture with response code \(res.statusCode)")
                    if let imageData = data {
                        image = UIImage(data: imageData)!
                         self.Image.image = image
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing to go to image")
        if segue.identifier == "toShowImage" {
            if let toViewController = segue.destination as? DisplayImageViewController {
                toViewController.Url = self.url
            }
        }
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
