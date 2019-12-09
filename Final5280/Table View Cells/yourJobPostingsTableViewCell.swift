//
//  yourJobPostingsTableViewCell.swift
//  Final5280
//
//  Created by Anup Deshpande on 12/9/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit

class yourJobPostingsTableViewCell: UITableViewCell {

    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
