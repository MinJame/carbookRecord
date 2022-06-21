//
//  CalendarCell.swift
//  pagetest
//
//  Created by min on 2022/04/06.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var selectedView : UIView!
    var isDataCheck = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectedView.layer.cornerRadius = 15
    }
}

