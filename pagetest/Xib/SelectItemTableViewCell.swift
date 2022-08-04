//
//  SelectItemTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/07/29.
//

import UIKit

class SelectItemTableViewCell: UITableViewCell {
 
    @IBOutlet weak var itemTypeLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
