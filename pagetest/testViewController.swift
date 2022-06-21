//
//  testViewController.swift
//  pagetest
//
//  Created by min on 2022/03/24.
//

import Foundation
import UIKit


class testViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var testTableView: UITableView!
    var data = [String]()

    override func viewDidLoad() {
       super.viewDidLoad()
        testTableView.delegate = self
        testTableView.dataSource = self
     }
    
 
    
}

extension testViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell") as! firstCell
  
//    cell.deleteBtn.addTarget(self, action: #selector(deleteBtnAction(_:)), for: .touchUpInside)
    return cell
  }
}


class firstCell : UITableViewCell {
    
    @IBOutlet weak var changeView: UISegmentedControl!
    
}
