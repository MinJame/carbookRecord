//
//  FillOilItemTableViewCell.swift
//  infoCar
//
//  Created by min on 2022/07/20.
//  Copyright © 2022 mureung. All rights reserved.
//

import UIKit

class FillOilItemTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceLabelField: UIButton!
    @IBOutlet weak var fuelCostLabel: UITextField!
    @IBOutlet weak var fuelTypeBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
