//
//  UpcomingAppointmentCell.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2017-08-16.
//  Copyright © 2017 com.bomane. All rights reserved.
//

import UIKit

class UpcomingAppointmentCell: UITableViewCell {

    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var stylistLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
