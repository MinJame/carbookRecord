//
//  repairTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/03/08.
//

import UIKit


class RepairTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var rePairNums: UILabel!
    @IBOutlet weak var rePairView: UIView!
    @IBOutlet weak var rePairItems: UITextField!
    @IBOutlet weak var repairMemoView: UITextView!
    @IBOutlet weak var repaircostTitle: UILabel!
    @IBOutlet weak var repairCostField: UITextField!
    @IBOutlet weak var repairMarkImageView: UIImageView!
    var pickers: UIPickerView!
    var toolbar: UIToolbar!
    var toolbars: UIToolbar!
    var Categorys = ["엔진오일 및 오일 필터","에어콘 필터","와이퍼 브레이드","구동벨트","미션오일","배터리","엔진부동액","우리집"]
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pickers = UIPickerView()
    //    pickers.delegate = self
//        repairCostField.delegate = self
        memoPlaceholderSetting()
        toolbarItems()
        toolbarItem()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func toolbarItems() {
        rePairItems.inputView = pickers
        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.pickeradd))
        let addItemBT = UIBarButtonItem(title: "목록추가", style: .plain, target: self, action: #selector(self.pickeradd))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.pickerExit))
        toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor(displayP3Red: 42/255, green: 198/255, blue: 254/255, alpha: 1)
        toolbar.setItems([addItemBT,flexibleSpace,cancelBT,doneBT], animated: false)
        toolbar.isUserInteractionEnabled = true
        rePairItems.inputAccessoryView = toolbar
        repairMemoView.inputAccessoryView = toolbar
        repairCostField.inputAccessoryView = toolbar
    
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
        repairMemoView.inputAccessoryView = toolbars
        repairCostField.inputAccessoryView = toolbars
        
        
    }
 
    func memoPlaceholderSetting() {
        repairMemoView.delegate = self // txtvReview가 유저가 선언한 outlet
        repairMemoView.text = "메모,특이사항\n(250자,이모티콘 불가)"
        repairMemoView.textColor = .lightGray
    }

    @objc func pickeradd() {
        /// picker와 같은 뷰를 닫는 함수
        let row = self.pickers.selectedRow(inComponent: 0)
        self.pickers.selectRow(row, inComponent: 0, animated: false)
        self.rePairItems.text = self.Categorys[row]
        self.rePairItems.resignFirstResponder()
        self.rePairView.endEditing(true)
    }
    @objc func keydown() {
        /// picker와 같은 뷰를 닫는 함수
        self.repairMemoView.endEditing(true)
        self.repairCostField.endEditing(true)
    }
    
    
    
    @objc func pickerExit() {
        /// picker와 같은 뷰를 닫는 함수
        self.rePairItems.text = self.Categorys.first
        self.rePairView.endEditing(true)
    }
    
}
