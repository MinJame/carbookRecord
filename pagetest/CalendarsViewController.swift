//
//  calendarsViewController.swift
//  pagetest
//
//  Created by min on 2022/04/06.
//

import Foundation
import UIKit
import JTAppleCalendar

protocol selectDateDelegate {
    func selectDate(date : Date)
    func dateCalendarDismissCallBack()
}


class CalendarsViewController : UIViewController {
  
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var calendarMonthView: JTAppleCalendarView!
    @IBOutlet weak var weekViewStack: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    var testCalendar = Calendar.current
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    var selectedDate : Date?
    var prePostVisibility: ((CellState, CalendarCell?)->())?
    var isInitAnimationStatus = false
    var isPortrait = true
    var delegate : selectDateDelegate?
    var tag : Int?
    @IBOutlet weak var previousMonth: UIButton!
    @IBOutlet weak var nextMonth: UIButton!
    var isContinuousAction = false
    
    var startDate : Date?
    var finishDate : Date?
    
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    
    let formatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.cornerRadius = 20
        mainContainer.layer.cornerRadius = 20
        bottomView.layer.cornerRadius = 20
        dateLabel.numberOfLines = 2
        setupCalendarView()

    }
  
    
    func calendarViewReload(){
        calendarMonthView.reloadData()
        
    }
    func setupCalendarView(){
        if selectedDate != nil {
            calendarMonthView.scrollToDate(selectedDate!, animateScroll: false)
            calendarMonthView.selectDates( [selectedDate!] )
        }else{
            calendarMonthView.scrollToDate(Date(), animateScroll: false)
            calendarMonthView.selectDates( [Date()] )
        }
        
        calendarMonthView.minimumLineSpacing = 0
        calendarMonthView.minimumInteritemSpacing = 0
        calendarMonthView.visibleDates { visibleDate in
            self.setupViewsOfCalendar(from: visibleDate)
        }
        
        previousMonth.addTarget(self, action: #selector(prevOrNextCalendarAction), for: .touchUpInside)
        nextMonth.addTarget(self, action: #selector(prevOrNextCalendarAction), for: .touchUpInside)
    }
    
    
    
    func setupViewsOfCalendar(from visibleDate: DateSegmentInfo) {
        let date = visibleDate.monthDates.first!.date
        formatter.dateFormat = "yyyy년 MM월"
        formatter.timeZone = Calendar.current.timeZone
        self.formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ko_KR")
        self.monthLabel.text = self.formatter.string(from: date)

        
    }
    
    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        prePostVisibility?(cellState, cell as? CalendarCell)
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = .white
            
        }else{
            validCell.dateLabel.textColor = .black
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyyMMdd"
            if dateFormat.string(from: cellState.date) == dateFormat.string(from: Date())  {
            validCell.dateLabel.textColor = .systemCyan
                Swift.print(cellState.date)
        }
       }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        validCell.selectedView.backgroundColor = .systemCyan
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
            validCell.selectedView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 0.1, delay: 0, options: []) {
                validCell.selectedView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
               
            }completion: { result in
                validCell.selectedView.transform = .identity
            }
        }else {
            validCell.selectedView.isHidden = true

        }
    }
    
    @objc func prevOrNextCalendarAction(_ sender : UIButton) {
        guard let date = selectedDate else {return}
        if !isContinuousAction {
            let calendar = Calendar(identifier: .gregorian)
            let dayOffset = DateComponents(month: sender.tag == 0 ? -1 : +1)
            
            if let moveDate = calendar.date(byAdding: dayOffset, to: date) {
                calendarMonthView.scrollToDate(moveDate)
                selectedDate = moveDate
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.isContinuousAction = false
            }
        }
    }
    
    
    @IBAction func dismissViewBtn(_ sender: UIButton) {
        
        if(self.presentingViewController != nil) {
            if let setDate = self.selectedDate {
                self.delegate?.selectDate(date: setDate)
                self.delegate?.dateCalendarDismissCallBack()
             
            }
            self.dismiss(animated: false, completion: nil)
        }
      dismiss(animated: true)
        
    }
}

extension CalendarsViewController : JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Locale(identifier: "ko_KR")
 
        let startDate = formatter.date(from: "2017 02 01")!
        let endDate = formatter.date(from: "2118 12 31")!
       
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        
        return parameters
    }
    
    
}

extension CalendarsViewController : JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CalendarCell
        handleCellConfiguration(cell: myCustomCell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
            cell.dateLabel.text = cellState.text
        }else{
            cell.isHidden = true
        }

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        
        handleCellConfiguration(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let calendar = Calendar(identifier: .gregorian)
        let comp = calendar.dateComponents([.year,.month, .day], from: date)
        let format = DateFormatter()
        format.calendar = Calendar(identifier: .gregorian)
        format.locale = Locale(identifier: "ko_KR")
        
        format.dateFormat = " M월 d일(E)"
        let dateString = format.string(for: date) ?? ""
        var valueText =  "\(dateString)"
        self.yearLabel.text = "\(comp.year!)"
        self.testLabel.text = valueText
        testLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        if let sDate = startDate{
            if sDate <= date {
                self.selectedDate = date
                handleCellConfiguration(cell: cell, cellState: cellState)
            }else {
            self.selectedDate = date
          handleCellConfiguration(cell: cell, cellState: cellState)
        }
    }else {
        self.selectedDate = date
        handleCellConfiguration(cell: cell, cellState: cellState)
    }

    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
}
