//
//  SearchJobTableViewCell.swift
//  Final5280
//
//  Created by Adwait Tathe on 12/7/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit

class SearchJobTableViewCell: UITableViewCell {

    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var jobLocationLabel: UILabel!
    
    func setValue(_ jobObj : job) {
        self.jobTitleLabel.text = jobObj.title
        self.priceLabel.text = jobObj.price
        self.jobLocationLabel.text = jobObj.location
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
