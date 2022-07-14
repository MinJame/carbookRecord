//
//  rePairListTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/04/20.
//

import UIKit

class RepairListTableViewCell: UITableViewCell {
    @IBOutlet weak var fuelStatusBtn: UIButton!
    @IBOutlet weak var fuelCostBtn: UIButton!
    @IBOutlet weak var memoTextView: UITextView!
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
        fuelStatusBtn.layer.borderWidth = 0.5
        // repairButton 색은 연한 회색
        fuelStatusBtn.layer.borderColor = UIColor.lightGray.cgColor
        //repairButton 모서리 굴곡 값 5
        fuelStatusBtn.layer.backgroundColor = UIColor.white.cgColor
        fuelStatusBtn.layer.cornerRadius = 10
        //repairButton 문자색 하얀색
        fuelStatusBtn.tintColor = UIColor.white
        // selfrepairButton 두께는 1
      
      
        //        otherrePairitemTitleLabel.text = ""
//        otherrePairCostLabel.text = ""
//        rePairItemTitleLabel.text = ""
//        otherrePairCosts.text = ""
//
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
