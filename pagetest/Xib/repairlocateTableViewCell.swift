//
//  repairlocateTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/03/24.
//

import Foundation
import UIKit

class repairlocateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var totalDistanceField: UITextField!
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
    var toolbars: UIToolbar!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        toolbarItem()
        addOilPlacebutton.layer.borderWidth = 2
        addOilPlacebutton.layer.borderColor = UIColor.lightGray.cgColor
        addOilPlacebutton.layer.cornerRadius = 10
        findPlace.layer.borderColor  = UIColor.black.cgColor
        findPlace.layer.borderWidth = 0.5
        totalDistanceField.delegate = self
        
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
    
    @objc func keydown() {
        /// picker와 같은 뷰를 닫는 함수
        self.totalDistanceField.endEditing(true)
    }
    
    func toolbarItem() {
        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.keydown))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.keydown))
        toolbars = UIToolbar()
        toolbars.sizeToFit()
        toolbars.tintColor = UIColor(displayP3Red: 42/255, green: 198/255, blue: 254/255, alpha: 1)
        toolbars.setItems([flexibleSpace,cancelBT,doneBT], animated: false)
        toolbars.isUserInteractionEnabled = true
        totalDistanceField.inputAccessoryView = toolbars
    
        
        
    }
}
extension repairlocateTableViewCell : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // replacementString : 방금 입력된 문자 하나, 붙여넣기 시에는 붙여넣어진 문자열 전체
            // return -> 텍스트가 바뀌어야 한다면 true, 아니라면 false
            // 이 메소드 내에서 textField.text는 현재 입력된 string이 붙기 전의 string
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal // 1,000,000
            formatter.locale = Locale.current
            formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
            
            // formatter.groupingSeparator // .decimal -> ,
            
            if let removeAllSeprator = totalDistanceField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
                var beforeForemattedString = removeAllSeprator + string
                if formatter.number(from: string) != nil {
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        totalDistanceField.text = formattedString
                        return false
                    }
                }else{ // 숫자가 아닐 때먽
                    if string == "" { // 백스페이스일때
                        let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                        beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                        if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                            totalDistanceField.text = formattedString
                            return false
                        }
                    }else{ // 문자일 때
                        return false
                    }
                }

            }
            
            return true
        }

    
    
    }


