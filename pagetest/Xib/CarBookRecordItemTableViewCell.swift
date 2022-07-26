//
//  CarBookRecordItemTableViewCell.swift
//  infoCar
//
//  Created by min on 2022/07/20.
//  Copyright © 2022 mureung. All rights reserved.
//

import UIKit

class CarBookRecordItemTableViewCell: UITableViewCell {

    @IBOutlet weak var selectRecordItemBtn: UIButton!
    @IBOutlet weak var fillItemCostBtn: UIButton!
    @IBOutlet weak var fillFuelLiterBtn: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectItemLocationLabel: UILabel!
    @IBOutlet weak var selectDateBtn: UIButton!
    @IBOutlet weak var selectPlaceBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
