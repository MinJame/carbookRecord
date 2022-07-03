//
//  directInputTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/03/08.
//

import UIKit

class directInputTableViewCell: UITableViewCell, UITextViewDelegate {


    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var washCarCostField: UITextField!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var deleteContentButton: UIButton!
    @IBOutlet weak var addContentButton: UIButton!
    @IBOutlet weak var directInputImageView: UIImageView!
    var toolbar: UIToolbar!
    var toolbars: UIToolbar!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        memoPlaceholderSetting()
        toolbarItem()
        toolbarItems()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    
    func memoPlaceholderSetting() {
        memoTextView.delegate = self // txtvReview가 유저가 선언한 outlet
        memoTextView.text = "메모 250자 기입가능\n(이모티콘 불가)"
        memoTextView.textColor = .lightGray
    }
    
    @objc func keydown() {
        /// picker와 같은 뷰를 닫는 함수
        self.memoTextView.endEditing(true)
        self.washCarCostField.endEditing(true)
    }
    
    func toolbarItems() {
        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.keydown))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.keydown))
        toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor(displayP3Red: 42/255, green: 198/255, blue: 254/255, alpha: 1)
        toolbar.setItems([flexibleSpace,cancelBT,doneBT], animated: false)
        toolbar.isUserInteractionEnabled = true
        washCarCostField.inputAccessoryView = toolbar
        
        
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
        memoTextView.inputAccessoryView = toolbars
        
        
    }
 

//    // TextView Place Holder
     func textViewDidBeginEditing(_ textView: UITextView) {
         if memoTextView.textColor == UIColor.lightGray {
             memoTextView.text = nil
             textView.textColor = UIColor.black
         }
         
     }
     // TextView Place Holder
     func textViewDidEndEditing(_ textView: UITextView) {
         if memoTextView.text.isEmpty {
             memoTextView.text = "메모 250자 기입가능\n(이모티콘 불가)"
             memoTextView.textColor = UIColor.lightGray
         }
     }

    
    
}
