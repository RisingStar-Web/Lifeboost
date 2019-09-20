//
//  tableCell.swift
//  TasksMe
//
//  Created by Valeriy PETRENKO on 13/10/2017.
//  Copyright © 2017 Slavamax BVBA. All rights reserved.
//

import UIKit
//import QuartzCore

class tableCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var cellTextField: UITextField!
    
     override func awakeFromNib() {
        super.awakeFromNib()
        let imageView = UIImageView()
        let image = UIImage(named: "S2")
        imageView.image = image
        self.backgroundView = imageView
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
      
    }

}
