//
//  carbookRecordMemoViewController.swift
//  pagetest
//
//  Created by min on 2022/07/28.
//

import Foundation
import UIKit
import SideMenu


class CarBookRecordMemoViewController : UIViewController,UITextViewDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var backBtn: UIButton!
    var memos : String = ""
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var memoView: UITextView!
    var oilDelegate : OilCallbackDelegate?
    override func viewDidLoad() {
      
        memoView.delegate = self
        self.title = "메모"
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icon_back_arrow"), style: .plain, target: self, action:#selector(self.dismissView))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.saveMemoBtn))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
        memoView.becomeFirstResponder()
        memoView.text = memos
        setNotification()
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
        let _:UIEdgeInsets = UIEdgeInsets.zero
        
    }
    
    @objc func saveMemoBtn(_ sender: Any) {
        
        let viewControllers = self.navigationController!.viewControllers
          for var vc in viewControllers
          {
          if vc is CarBookRecordEditViewController
             {
                let VC = vc as! CarBookRecordEditViewController
                    VC.memo = memoView.text
                   
              self.navigationController?.popToViewController(VC, animated: true)
              self.oilDelegate?.setOilData()
             }
          }

    }

    
    @objc func dismissView(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)

    }

    @objc func dismissKeyboard() {
        
        self.view.endEditing(true)

        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength <= 60
    }
}
    
