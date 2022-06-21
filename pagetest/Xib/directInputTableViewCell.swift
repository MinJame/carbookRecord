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
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var deleteContentButton: UIButton!
    @IBOutlet weak var addContentButton: UIButton!
    @IBOutlet weak var directInputImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        memoPlaceholderSetting()
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
    
    
    // TextView Place Holder
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
