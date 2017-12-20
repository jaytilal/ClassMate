//
//  DisplayImageViewController.swift
//  ClassMate
//
//  Created by Jayti Lal on 12/11/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//

import UIKit

class DisplayImageViewController: UIViewController {

    @IBOutlet weak var Image: UIImageView!
    var Url = ""
    var queue = DispatchQueue(label: "responseQueue", qos: .utility)
    
    @IBOutlet weak var SaveButton: UIButton!
    @IBAction func SaveImage(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(Image.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "The image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Url != ""{
            //getImage(url: Url)
            Image.imageFromServerURL(urlString: Url)
            
            Image.layer.borderWidth = 5
            Image.layer.cornerRadius = 9.0

            reloadInputViews()
            print("Done")
        }
        self.SaveButton.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}
