//
//  TopPremiumCell.swift
//  TrackApp
//
//  Created by Ankit  Jain on 16/07/20.
//  Copyright © 2020 Sanganan. All rights reserved.
//

import UIKit

class TopPremiumCell: UITableViewCell {

    @IBOutlet weak var premiumUserLbl: UILabel!
    @IBOutlet weak var midLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        premiumUserLbl.text = "Track_001".localized()
        self.midLbl.text = "Track_002".localized()
        self.bottomLbl.text = "Track_003".localized()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
