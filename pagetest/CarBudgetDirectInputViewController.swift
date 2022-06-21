//
//  CarBudgetDirectInputViewController.swift
//  pagetest
//
//  Created by min on 2022/03/08.
//

import Foundation
import UIKit

class CarBudgetDirectInputViewController: UIViewController,UITextViewDelegate {
    
    
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var directInputImage: UIImageView!
    @IBOutlet weak var directInputTitle: UILabel!
    @IBOutlet weak var useMoneyData: UITextField!
    @IBOutlet weak var infoDataView: UIView!
    
    @IBOutlet weak var totalDistanceLabel: UITextField!
    override func viewDidLoad() {
    super.viewDidLoad()
    let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    self.view.addGestureRecognizer(tap)
    
    // Do any additional setup after loading the view.
}


// MARK: - TextField & Keyboard Methods
@objc func keyboardShow(notification: NSNotification) {
    
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        
        if self.view.frame.origin.y == 0 {
            
            self.view.frame.origin.y -= keyboardSize.height/2.1
            
        }
        
    }
    
}

@objc func keyboardHide(notification: NSNotification) {
    
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += keyboardSize.height/2.1
        }
        
    }
    
}
@objc func dismissKeyboard() {
    
    self.view.endEditing(true)
    
}


}


