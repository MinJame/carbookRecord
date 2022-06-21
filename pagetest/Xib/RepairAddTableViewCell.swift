//
//  repairaddTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/03/21.
//

import Foundation
import UIKit

class RepairAddTableViewCell: UITableViewCell {

    @IBOutlet weak var fuelTypeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fuelTypeButton.titleLabel!.text = UserDefaults.standard.string(forKey: "oiltypes")
        fuelTypeButton.setTitleColor(.black, for: .normal)
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func changeFuelTypeButton(_ sender: Any) {

            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)
            let gasoline = UIAlertAction(title: "휘발유", style: UIAlertAction.Style.default, handler:{[self]
                action in
                fuelTypeButton.setTitle("휘발유", for: .normal)
                fuelTypeButton.setTitleColor(.black, for: .normal)
                UserDefaults.standard.set(fuelTypeButton.currentTitle,forKey: "oiltypes")
               
            })
            let diesel = UIAlertAction(title: "경유", style: UIAlertAction.Style.default, handler:{[self]
                action in
                fuelTypeButton.setTitle("경유", for: .normal)
                fuelTypeButton.setTitleColor(.black, for: .normal)
                UserDefaults.standard.set(fuelTypeButton.currentTitle,forKey: "oiltypes")
            })
        let LPG = UIAlertAction(title: "LPG", style: UIAlertAction.Style.default, handler:{[self]
                action in
                fuelTypeButton.setTitle("LPG", for: .normal)
                fuelTypeButton.setTitleColor(.black, for: .normal)
                UserDefaults.standard.set(fuelTypeButton.currentTitle,forKey: "oiltypes")
            })
            let cancel = UIAlertAction(title: "취소", style: .destructive, handler:nil)
            
            
            alert.addAction(gasoline)
            alert.addAction(diesel)
            alert.addAction(LPG)
            alert.addAction(cancel)
          
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
        
        
    }
}
