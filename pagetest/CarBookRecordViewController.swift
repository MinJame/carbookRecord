//
//  CarBookRecordViewController.swift
//  pagetest
//
//  Created by min on 2022/07/21.
//

import Foundation
import UIKit
import SideMenu


class CarBookRecordViewController : UIViewController,UINavigationControllerDelegate{
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var fillDataView: UIView!
    @IBOutlet weak var fillCostView: UIView!
    @IBOutlet weak var keyBoardView: UIView!
    @IBOutlet weak var selectInsertItem: UISegmentedControl!
    @IBOutlet weak var filIText: UITextField!
    @IBOutlet weak var keyBoardStackView: UIStackView!
    @IBOutlet weak var OneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fifthBtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    @IBOutlet weak var ZeroBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
 
    var costs : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTexts()
       
    }
    func setTexts() {
        filIText.placeholder = "금액을 입력하세요"
        keyBoardView.layer.borderColor = UIColor.lightGray.cgColor
        keyBoardView.layer.borderWidth = 0.5
        
    }
    
    @IBAction func selectItems(_ sender: UISegmentedControl) {
        
        switch selectInsertItem.selectedSegmentIndex {
        case 0:
            filIText.text?.removeAll()
            filIText.placeholder = "금액을 입력하세요"
        case 1:
            filIText.text?.removeAll()
            filIText.placeholder = "주유량을 입력하세요"
            
        default:
            return
            
    }
    }
    
    
    @IBAction func moveToDetailReordViewController(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CarBookRecordEditViewController")
            as? CarBookRecordEditViewController  {
    
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            vc.expendCost = costs
            vc.expendLiter = costs
            self.present(vc, animated: true)
            
        }
        
    }
    
    @IBAction func inputNumbers(_ sender: UIButton) {
        let data = sender.titleLabel?.text ?? ""
        costs.append(data)
        filIText.text? = costs + "원"
        if filIText.text?.first == "0"{
            filIText.text?.removeFirst()
        }
    }
    
    @IBAction func deleteCost(_ sender: Any) {
        if filIText.text != "" {
            filIText.text?.removeLast()
    }
}
}

extension CarBookRecordViewController : UITextFieldDelegate {

    // 텍스트필드에 입력이 끝났을때 동작하는 함수
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 만약 텍스트 필드의 태그 값이 0인 경우
        if textField.tag == 0 {
            // 해당되는 텍스트 필드의 값을 더블형으로 변환시켜서 테이블리스트 "Distance"에 업데이트 시킨다
           
        }else{
            // 텍스트 필드의 태그 값이 0이 아닌경우 지출비용이므로  더블형으로 변환시켜서 테이블리스트의 "cost"에 업데이트 시킨다
       
        }
    }
    // 텍스트 필드가 입력시작될때 동작하는 함수
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 만약 텍스트필드의 문자색이 연한갈색이면
        if textField.textColor == UIColor.lightGray {
            // 만약 텍스트필드의 문자를 없애고
            textField.text = nil
            // 텍스트필드의 입력되는 문자를 검은색으로 입력시킨다
            textField.textColor = UIColor.black
        }
        
    }
    
    //textfield가 숫자일때 단위마다 ,찍어주는 함수
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 1,000,000
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수

        if let removeAllSeprator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
            var beforeForemattedString = removeAllSeprator + string
            if formatter.number(from: string) != nil {
                if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                    textField.text = formattedString
                    return false
                }
            }else{ // 숫자가 아닐 때
                if string == "" {
                    // 백스페이스일때
                    let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                    beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        textField.text = formattedString
                        return false
                    }
                }else{
                    // 문자일 때
                    return false
                }
            }
            
        }
        
        return true
    }
    
}


