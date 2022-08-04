//
//  KeyBoardTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/07/21.
//

import UIKit

protocol KeyBoardDelegate {
    func outputData(str : String)
}

class KeyBoardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    var delegate : KeyBoardDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func BtnPress(_ sender: UIButton) {
        guard let data = sender.titleLabel?.text else{
            return
        }
        delegate?.outputData(str: data)

        
    }
    
    func outputData(str: String) {
        print("테스트\(str)")
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
