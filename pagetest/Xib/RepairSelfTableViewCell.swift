//
//  repairSelfTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/03/23.
//

import UIKit

class RepairSelfTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var addImageView: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addImageView.layer.cornerRadius = 5
        distanceField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension RepairSelfTableViewCell : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // replacementString : 방금 입력된 문자 하나, 붙여넣기 시에는 붙여넣어진 문자열 전체
            // return -> 텍스트가 바뀌어야 한다면 true, 아니라면 false
            // 이 메소드 내에서 textField.text는 현재 입력된 string이 붙기 전의 string
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal // 1,000,000
            formatter.locale = Locale.current
            formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
            
            // formatter.groupingSeparator // .decimal -> ,
            
            if let removeAllSeprator = distanceField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
                var beforeForemattedString = removeAllSeprator + string
                if formatter.number(from: string) != nil {
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        distanceField.text = formattedString
                        return false
                    }
                }else{ // 숫자가 아닐 때먽
                    if string == "" { // 백스페이스일때
                        let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                        beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                        if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                            distanceField.text = formattedString
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
