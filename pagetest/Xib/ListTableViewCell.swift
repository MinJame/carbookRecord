//
//  ListTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/05/03.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var secondeView: UIView!
    @IBOutlet weak var firstView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        firstView.isHidden = true
        secondeView.isHidden = true
        // Initialization code
    }
    @IBAction func showviews(_ sender: Any) {
        firstView.isHidden = true
        secondeView.isHidden = true
    }
    
    @IBAction func showhiddenView(_ sender: Any) {
        firstView.isHidden = false
        secondeView.isHidden = false
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
