//
//  RecordViewController.swift
//  pagetest
//
//  Created by min on 2022/04/12.
//

import Foundation
import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var tablelistss : [Dictionary<String,Any>] = []
    override func viewDidLoad() {
       super.viewDidLoad()
        Swift.print(tablelistss)
        self.textView.text = tablelistss.description
     }
    
    
}
