//
//  CollectionViewCell.swift
//  ClassMate
//
//  Created by Jayti Lal on 12/10/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//
import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var Edit: UIButton!
    func displayContent(img : UIImage,name : String){
        title.text = name
        image.image = img
    }
}

