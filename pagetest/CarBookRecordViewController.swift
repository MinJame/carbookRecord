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

   
    @IBOutlet weak var itemBtn: UIButton!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var fillDataView: UIView!
    @IBOutlet weak var fillCostView: UIView!
    @IBOutlet weak var keyBoardView: UIView!
    @IBOutlet weak var selectInsertItem: UISegmentedControl!
    @IBOutlet weak var fillMonetyField: UITextField!
    @IBOutlet weak var keyBoardStackView: UIStackView!
    @IBOutlet var insertBtn : [UIButton]!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var costs: Double = 0.0
    var isDecimalCheck = false
    var recordNum : Int = 0
  
    var money : Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = .none
        fillMonetyField.delegate = self
        setTexts()
        setBtn()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.userInterfaceIdiom == .pad
          {
            fillMonetyField.isEnabled = false
            keyBoardView.isHidden = false
            keyBoardStackView.isHidden = false
        }else {
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
                fillMonetyField.isEnabled = true
                fillMonetyField.becomeFirstResponder()
                setNotification()
                keyBoardView.isHidden = true
                keyBoardStackView.isHidden = true
            }else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
                fillMonetyField.isEnabled = true
                fillMonetyField.becomeFirstResponder()
                setNotification()
                keyBoardView.isHidden = true
                keyBoardStackView.isHidden = true
            }else {
                fillMonetyField.isEnabled = false
                fillMonetyField.resignFirstResponder()
                dismissKeyboard()
                keyBoardView.isHidden = false
                keyBoardStackView.isHidden = false
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            fillMonetyField.isEnabled = false
            keyBoardView.isHidden = false
            keyBoardStackView.isHidden = false
        }else {
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
                fillMonetyField.isEnabled = true
                fillMonetyField.becomeFirstResponder()
                setNotification()
                keyBoardView.isHidden = true
                keyBoardStackView.isHidden = true
            }else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
                fillMonetyField.isEnabled = true
                fillMonetyField.becomeFirstResponder()
                setNotification()
                keyBoardView.isHidden = true
                keyBoardStackView.isHidden = true
            }else {
                fillMonetyField.isEnabled = false
                fillMonetyField.resignFirstResponder()
                dismissKeyboard()
                keyBoardView.isHidden = false
                keyBoardStackView.isHidden = false
            }
            
        }
    }
    
    func setBtn() {
        itemBtn.addTarget(self, action: #selector(moveItemBtn(_ :)), for:  .touchUpInside)
    }

    func setTexts() {
        fillMonetyField.textColor = .lightGray
        keyBoardView.layer.borderColor = UIColor.lightGray.cgColor
        keyBoardView.layer.borderWidth = 0.5
        fillMonetyField.textColor = .black
        
    }
    
    func setKeyBoard() {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            fillMonetyField.isEnabled = false

            keyBoardView.isHidden = false
            keyBoardStackView.isHidden = false
        }else {
            if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
                fillMonetyField.isEnabled = true
                fillMonetyField.becomeFirstResponder()
                setNotification()
                keyBoardView.isHidden = true
                keyBoardStackView.isHidden = true
            }else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
                fillMonetyField.isEnabled = true
                fillMonetyField.becomeFirstResponder()
                setNotification()
                keyBoardView.isHidden = true
                keyBoardStackView.isHidden = true
            }else {
                fillMonetyField.resignFirstResponder()
                dismissKeyboard()
                fillMonetyField.isEnabled = false
                keyBoardView.isHidden = false
                keyBoardStackView.isHidden = false
            }
            
        }
        
        
    }

 
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardRectangle = keyboardFrame.cgRectValue
            _ = keyboardRectangle.height-50
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        
    }

    @objc func dismissKeyboard() {
        
        self.view.endEditing(true)

        
    }
    
    @IBAction func dissBtn(_ sender: Any) {
        fillMonetyField.text?.removeAll()
        costs = 0.0
//        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectItems(_ sender: UISegmentedControl) {
        
        switch selectInsertItem.selectedSegmentIndex {
        case 0:
            recordNum = selectInsertItem.selectedSegmentIndex
            Swift.print("recordNum\(recordNum)")
            fillMonetyField.text?.removeAll()
            costs = 0.0
            fillMonetyField.placeholder = "금액을 입력하세요"
            fillMonetyField.textColor = .black
        case 1:
            recordNum = selectInsertItem.selectedSegmentIndex
            Swift.print("recordNum\(recordNum)")
            fillMonetyField.text?.removeAll()
            costs = 0.0
            fillMonetyField.placeholder = "주유량을 입력하세요"
            fillMonetyField.textColor = .black
        default:
            return
            
        }
    }
    
    @objc func moveItemBtn(_ sender: UIButton) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BottomSheetViewController")
            as? BottomSheetViewController  {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    @IBAction func moveToDetailReordViewController(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CarBookRecordEditViewController")
            as? CarBookRecordEditViewController  {
       
            vc.expendCost = costs
            vc.expendLiter = costs
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func priceFormatter(value : Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 10
        numberFormatter.locale = Locale.current
        let result = numberFormatter.string(from: NSNumber(value:value))!
        return result
    }
    
    @IBAction func inputNumbers(_ sender: UIButton) {
        let data = sender.titleLabel?.text ?? ""
        if data != "." {
            if isDecimalCheck{
                let check = costs - Double(Int(costs))
                if check > 0 {
                    if let dCost = Double(costs.clean + data) {
                        costs = dCost
                        fillMonetyField.text = priceFormatter(value: costs)+"\(recordNum == 0 ? "원" : "L")"
                    }
                }else {
                    if let dCost = Double(costs.clean+"."+data) {
                        costs = dCost
                        fillMonetyField.text = priceFormatter(value: costs)+"\(recordNum == 0 ? "원" : "L")"
                    }
                }
            }else {
                if let dCost = Double(costs.clean + data) {
                    costs = dCost
                    fillMonetyField.text = priceFormatter(value: costs)+"\(recordNum == 0 ? "원" : "L")"
                }
            }
        }else {
            if let dCost = Double(costs.clean + data) {
                costs = dCost
                let _costs = costs + 0.1
                isDecimalCheck = true
                var checkCost = priceFormatter(value: _costs)
                checkCost.removeLast()
                fillMonetyField.text = checkCost+"\(recordNum == 0 ? "원" : "L")"
            }
            
        }
    }
    
    @IBAction func deleteCost(_ sender: Any) {
        if var text = fillMonetyField.text {
            if text.count > 0 {
                text.removeLast()
                if let lastChar = text.last {
                    if lastChar != "." && lastChar != "," {
                        var _cost = String(costs.cleans)
                        _cost.removeLast()
                        costs = Double(_cost) ?? 0.0
                        if costs != 0 {
                            fillMonetyField.text = priceFormatter(value: costs)+"\(recordNum == 0 ? "원" : "L")"
                        }else {
                            isDecimalCheck = false
                            fillMonetyField.text = ""
                        }
                    }else {
                        text.removeLast()
                        fillMonetyField.text = text+"\(recordNum == 0 ? "원" : "L")"
                        isDecimalCheck = false
                    }
                }
            }
        }
    }
}
// MARK: - TextView,TextField 사용을 위한 Delegate 선언
extension CarBookRecordViewController : UITextViewDelegate,UITextFieldDelegate {
   
    // 텍스트필드에 입력이 끝났을때 동작하는 함수
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 만약 텍스트 필드의 태그 값이 0인 경우
        if recordNum == 0 {
            if !(textField.text?.contains("원"))!{
                textField.text = fillMonetyField.text!  + "원"
            }else {
                textField.text = fillMonetyField.text!
            }
        }else {
            textField.text = fillMonetyField.text!  + "L"
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



extension Double {
    var cleans: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
