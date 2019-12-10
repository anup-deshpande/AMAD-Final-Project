//
//  interestedUserTableViewCell.swift
//  Final5280
//
//  Created by Anup Deshpande on 12/10/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit

class interestedUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bidPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
