//
//  OilMonthTotalTableViewCelll.swift
//  pagetest
//
//  Created by min on 2022/04/14.
//

import UIKit

class OilMonthTotalTableViewCell: UITableViewHeaderFooterView {
    @IBOutlet weak var firstView: UIView!
  
    @IBOutlet weak var totalFuelEfficiencyLabel: UILabel!
    @IBOutlet weak var totalFuelCostLabel: UILabel!
    @IBOutlet weak var totalFuelLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var totalDistacneLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
