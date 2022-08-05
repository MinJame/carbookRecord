//
//  KeyBoardTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/07/21.
//

import UIKit


class KeyBoardTableViewCell: UITableViewCell {

    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var thirdBtn: UIButton!
    @IBOutlet weak var fourthBtn: UIButton!
    @IBOutlet weak var fifthBtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    @IBOutlet weak var zeroBtn: UIButton!
    
    @IBOutlet weak var commaBtn: UIButton!
    
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet var numBtn : [UIButton]!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
