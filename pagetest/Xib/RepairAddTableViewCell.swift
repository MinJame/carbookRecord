//
//  repairaddTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/03/21.
//

import Foundation
import UIKit

class RepairAddTableViewCell: UITableViewCell {

    @IBOutlet weak var fuelCost: UITextField!
    @IBOutlet weak var totalFulCost: UITextField!
    @IBOutlet weak var fuelLiterField: UITextField!
    @IBOutlet weak var fuelTypeButton: UIButton!
    var toolbars: UIToolbar!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        toolbarItem()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

   
        
        @objc func keydown() {
            /// picker와 같은 뷰를 닫는 함수
            self.totalFulCost.endEditing(true)
            self.fuelLiterField.endEditing(true)
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
            totalFulCost.inputAccessoryView = toolbars
            fuelLiterField.inputAccessoryView = toolbars
            
            
        }

    }

extension RepairAddTableViewCell : UITextFieldDelegate {
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // replacementString : 방금 입력된 문자 하나, 붙여넣기 시에는 붙여넣어진 문자열 전체
        // return -> 텍스트가 바뀌어야 한다면 true, 아니라면 false
        // 이 메소드 내에서 textField.text는 현재 입력된 string이 붙기 전의 string
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 1,000,000
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
        
        // formatter.groupingSeparator // .decimal -> ,
        
        if let removeAllSeprator = totalFulCost.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
            var beforeForemattedString = removeAllSeprator + string
            if formatter.number(from: string) != nil {
                if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                    totalFulCost.text = formattedString
                    return false
                }
            }else{ // 숫자가 아닐 때먽
                if string == "" { // 백스페이스일때
                    let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                    beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        totalFulCost.text = formattedString
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
