//
//  SearchTableViewCell.swift
//  ClassMate
//
//  Created by Jayti Lal on 12/13/17.
//  Copyright © 2017 Jayti Lal. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Subtitle: UILabel!
    @IBOutlet weak var Join: UIButton!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
