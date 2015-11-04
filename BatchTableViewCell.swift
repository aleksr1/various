//
//  BatchTableViewCell.swift
//  QEMobile
//
//  Created by Justin Owens on 8/24/15.
//  Copyright (c) 2015 VisionCPS. All rights reserved.
//

import UIKit

class BatchTableViewCell: UITableViewCell {
    
    @IBOutlet var lblMemberID: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var lblGender: UILabel!
    @IBOutlet var lblStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
