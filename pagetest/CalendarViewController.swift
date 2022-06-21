////
////  CalendarViewController.swift
////  pagetest
////
////  Created by min on 2022/03/31.
////
//
//import Foundation
//import UIKit
//
//class CalendarViewController: UIViewController {
//
//    
//    @IBOutlet weak var yearMonthLabel: UILabel!
//    let now = Date()
//    
//    var cal = Calendar.current
//    
//    let dateFormatter = DateFormatter()
//    
//    var components = DateComponents()
//    
//    var weeks: [String] = ["日", "月", "火", "水", "木", "金", "土"]
//    
//    var days: [String] = []
//    
//    var daysCountInMonth = 0 // 해당 월이 며칠까지 있는지
//    
//    var weekdayAdding = 0 // 시작일
//    
//    
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        self.initView()
//        dateFormatter.dateFormat = "yyyy年M月" // 월 표시 포맷 설정
//        
//        components.year = cal.component(.year, from: now)
//        
//        components.month = cal.component(.month, from: now)
//        
//        components.day = 1
//        
//        self.calculation()
//        
//    }
//    private func initView() {  // 뷰을 초기 설정
//        
//        self.initCollection()
//        
//    }
//    
//    
//    
//    @IBAction func prevBtn(_ sender: Any) {
//        
//        components.month = components.month! - 1
//
//              self.calculation()
//
//              self.collectionView.reloadData()
//
//    }
//    
//    @IBAction func nextBtn(_ sender: Any) {
//        
//        components.month = components.month! + 1
//
//               self.calculation()
//
//               self.collectionView.reloadData()
//    }
//    private func initCollection() {  // CollectionView의 초기 설정
//        
//        self.collectionView.delegate = self
//        
//        self.collectionView.dataSource = self
//        
//        self.collectionView.register(UINib(nibName: "CalendarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "calendarCell")
//        
//        
//        
//    }
//    
//    private func calculation() { // 월 별 일 수 계산
//
//            let firstDayOfMonth = cal.date(from: components)
//
//            let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!) // 해당 수로 반환이 됩니다. 1은 일요일 ~ 7은 토요일
//
//            daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
//
//            weekdayAdding = 2 - firstWeekday
//        self.yearMonthLabel.text = dateFormatter.string(from: firstDayOfMonth!)
//
//               
//
//               self.days.removeAll()
//
//               for day in weekdayAdding...daysCountInMonth {
//
//                   if day < 1 { // 1보다 작을 경우는 비워줘야 하기 때문에 빈 값을 넣어준다.
//
//                       self.days.append("")
//
//                   } else {
//
//                       self.days.append(String(day))
//
//                   }
//
//               }
//
//    }
//    
//}
//
//extension CalendarViewController : UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//            switch section {
//
//            case 0:
//
//                return 7 // 요일의 수는 고정
//
//            default:
//
//                return self.days.count // 일의 수
//
//            }
//
//        }
//
//        
//
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCollectionViewCell
//
//            
//
//            switch indexPath.section {
//
//            case 0:
//
//                cell.dateLabel.text = weeks[indexPath.row] // 요일
//
//            default:
//
//                cell.dateLabel.text = days[indexPath.row] // 일
//
//            }
//
//            
//
//            if indexPath.row % 7 == 0 { // 일요일
//
//                cell.dateLabel.textColor = .red
//
//            } else if indexPath.row % 7 == 6 { // 토요일
//
//                cell.dateLabel.textColor = .blue
//
//            } else { // 월요일 좋아(평일)
//
//                cell.dateLabel.textColor = .black
//
//            }
//
//
//
//            return cell
//
//        }
//    
//    
//}
