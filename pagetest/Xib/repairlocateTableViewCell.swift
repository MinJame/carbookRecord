//
//  repairlocateTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/03/24.
//

import Foundation
import UIKit

class repairlocateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var oilStationLabel: UILabel!
    @IBOutlet weak var changeDistancesButtons: UIButton!
    @IBOutlet weak var changeDistanceButton: UIButton!
    @IBOutlet weak var addOilPlacebutton: UIButton!
    @IBOutlet weak var oillocaselectView: UIView!
    @IBOutlet weak var oillocationaddView: UIView!
    @IBOutlet weak var rePairConnectView: UIView!
    @IBOutlet weak var rePairStationDistance: UILabel!
    @IBOutlet weak var findPlace: UIButton!
    @IBOutlet weak var changeVIew: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addOilPlacebutton.layer.borderWidth = 2
        addOilPlacebutton.layer.borderColor = UIColor.lightGray.cgColor
        addOilPlacebutton.layer.cornerRadius = 10
        findPlace.layer.borderColor  = UIColor.black.cgColor
        findPlace.layer.borderWidth = 0.5
        rePairStationDistance.text = UserDefaults.standard.string(forKey: "distance")
        changeDistanceButton.setTitle(UserDefaults.standard.string(forKey: "distacnes"), for: .normal)
        changeDistanceButton.setTitleColor(.black, for: .normal)
        changeDistancesButtons.setTitle(UserDefaults.standard.string(forKey: "distacnes"), for: .normal)
        changeDistancesButtons.setTitleColor(.black, for: .normal)
        
    }
    @IBAction func askPlacelocation(_ sender: Any){
       
 }
    
    @IBAction func changeViews(_ sender: Any) {
        oillocaselectView.isHidden = false
        oillocationaddView.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected statev
        
    }
    @IBAction func changeLabels(_ sender: Any) {
        
        let messageitem: String? = "가까운 장소"
        let messageitem2: String? = "방문 장소"
        
      
        var messagetitle = rePairStationDistance!.text
        if  messagetitle == "방문 장소 기준" {
            messagetitle = messageitem2
        }else {
            messagetitle = messageitem
        }
       
        
        let alert = UIAlertController(title: "장소 검색 기준", message: "장소 검색 기준에 따라 자동으로 장소가 선택됩니다.\n 현재 검색 기준이 '\(messagetitle!)'로 설정되어있습니다.원하시는 기준을 설정해주세요", preferredStyle: UIAlertController.Style.alert)
        let addDistance = UIAlertAction(title: "가까운 장소", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            rePairStationDistance.text = "\(messageitem!) 기준"
            rePairStationDistance.textColor = .lightGray
            
            UserDefaults.standard.set(rePairStationDistance.text,forKey: "distance")
      
            
        })
        let selectionDistance = UIAlertAction(title: "방문 장소", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            rePairStationDistance.text = "\(messageitem2!) 기준"
            rePairStationDistance.textColor = .lightGray
            
            UserDefaults.standard.set(rePairStationDistance.text,forKey: "distance")
        
            
        })
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler:nil)
        
        alert.addAction(addDistance)
        alert.addAction(selectionDistance)
        alert.addAction(cancel)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
         }
    
    @IBAction func changeDistance(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)
        let addDistance = UIAlertAction(title: "누적주행거리", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            changeDistanceButton.setTitle("누적주행거리", for: .normal)
            changeDistanceButton.setTitleColor(.black, for: .normal)
            UserDefaults.standard.set(changeDistanceButton.currentTitle,forKey: "distacnes")
            changeDistancesButtons.setTitle("누적주행거리", for: .normal)
            changeDistancesButtons.setTitleColor(.black, for: .normal)
            UserDefaults.standard.set(changeDistancesButtons.currentTitle,forKey: "distacnes")
            
        })
        let selectionDistance = UIAlertAction(title: "구간주행거리", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            changeDistanceButton.setTitle("구간주행거리", for: .normal)
            changeDistanceButton.setTitleColor(.black, for: .normal)
            UserDefaults.standard.set(changeDistanceButton.currentTitle,forKey: "distacnes")
            changeDistancesButtons.setTitle("구간주행거리", for: .normal)
            changeDistancesButtons.setTitleColor(.black, for: .normal)
            UserDefaults.standard.set(changeDistancesButtons.currentTitle,forKey: "distacnes")
        })
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler:nil)
        
        alert.addAction(addDistance)
        alert.addAction(selectionDistance)
        alert.addAction(cancel)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
     
    }
    
    
    }


