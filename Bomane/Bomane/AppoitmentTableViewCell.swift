//
//  AppoitmentTableViewCell.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-12-25.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit

class AppoitmentTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var selectedOvalImage: UIImageView!
    @IBOutlet weak var unselectedImage: UIImageView!
    
    @IBOutlet weak var serviceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(sender: Bool) {
        if sender {
            self.selectedOvalImage.isHidden = false
        } else {
            self.selectedOvalImage.isHidden = true
        }
    }
    
}
