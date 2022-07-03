//
//  rePairListTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/04/20.
//

import UIKit

class rePairListTableViewCell: UITableViewCell {
    @IBOutlet weak var fuelStatusLabel: UILabel!
    @IBOutlet weak var fuelCostLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var otherrePairCosts: UILabel!
    @IBOutlet weak var otherrePairitemTitleLabel: UILabel!
    @IBOutlet weak var rePairItemTitleLabel: UILabel!
    @IBOutlet weak var rePairItemListView: UIView!
    @IBOutlet weak var rePairDateLabel: UILabel!
    @IBOutlet weak var rePairExpenseCost: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var rePairLocationLabel: UILabel!
    @IBOutlet weak var changeItemButton: UIButton!
    @IBOutlet weak var rePairItemImageView: UIImageView!
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var otherrePairCostLabel: UILabel!
    
    @IBOutlet weak var rePairItmeStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        rePairItemImageView.layer.cornerRadius = 10
        memoView.layer.cornerRadius = 10
        memoTextView.layer.cornerRadius = 10
        fuelStatusLabel.layer.cornerRadius = 10
        
        //        otherrePairitemTitleLabel.text = ""
//        otherrePairCostLabel.text = ""
//        rePairItemTitleLabel.text = ""
//        otherrePairCosts.text = ""
//
        
        // Initialization code
    }

    @IBAction func addMemoView(_ sender: Any) {
  
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
