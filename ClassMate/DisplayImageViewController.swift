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
    override func viewDidLoad() {
        super.viewDidLoad()
        if Url != ""{
            getImage(url: Url)
            print("Done")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
}
