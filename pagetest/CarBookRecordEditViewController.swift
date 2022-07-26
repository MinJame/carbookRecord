//
//  CarBookRecordEditViewController.swift
//  infoCar
//
//  Created by min on 2022/07/20.
//  Copyright © 2022 mureung. All rights reserved.
//

import Foundation
import UIKit
import SideMenu


class CarBookRecordEditViewController : UIViewController,UINavigationControllerDelegate{
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var editTableView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    var dateDelegate : selectDateDelegate?
    var expendCost : String = ""
    var expendLiter : String = ""
    var startDate : Date?
    var dateLabel : String? = ""
    var tablelist : [Dictionary<String,Any>] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        dateDelegate = self
        initTableView()
        setLists()
        setItems()
    }
    
    func setLists() {
        // 테이블리스트 데이터들 선언
        tablelist = [
            ["Type": 1,"Distance" :"","Date":"","Mode" : 0,"isLocation": false],
            // ["Type": 2],
            // cellId 있는 경우와 없는 경우 구분
            ["Type" :2, "Category": "1", "Cost" : 0 ,"Memo":"","Num": 1
             ,"id": 0,"isHidden":0 ]
        ]
    }
    
    func setItems() {
        
        let format = DateFormatter()
        // format의 달력 형식을 그레고리언 형식의 달력으로 저장
        format.calendar = Calendar(identifier: .gregorian)
        // format의 지역을 한국으로 저장
        format.locale = Locale(identifier: "ko_KR")
        
        // format의 날짜 표기 형식을 "년.월.일(요일)"로 저장
        format.dateFormat = "yyyy.MM.dd(E)"
        
        tablelist[1].updateValue(format.string(for: Date()) ?? "", forKey: "Date")
        
    }
    func initTableView() {
        editTableView.delegate = self
        editTableView.dataSource = self
        editTableView.rowHeight = UITableView.automaticDimension
        let cell1: UINib = UINib(nibName: "CarBookRecordItemTableViewCell", bundle: nil)
        editTableView.register(cell1, forCellReuseIdentifier: "CarBookRecordItemTableViewCellID")
        
        let cell2: UINib = UINib(nibName: "FillOilItemTableViewCell", bundle: nil)
        editTableView.register(cell2, forCellReuseIdentifier: "FillOilItemTableViewCellID")

    }
    
    @IBAction func dismissView(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CarBookRecordViewController")
            as? CarBookRecordViewController  {
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: true)
            
        }
        
    }
    
}

extension CarBookRecordEditViewController: UITableViewDelegate {
    
}

extension CarBookRecordEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablelist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tablelist[indexPath.row]
    
        let type = item["Type"] as? Int ?? 0
        
        switch type {
        case 1 :
            // 만약 타입이 1일 경우 repairsTableViewCell을 재사용한다
            if let cell = editTableView.dequeueReusableCell(withIdentifier: "CarBookRecordItemTableViewCellID") as?
                CarBookRecordItemTableViewCell {
                
                    
                let date = tablelist[1]["Date"] as? String ?? ""
                
                cell.fillItemCostBtn.titleLabel?.text = ""
                cell.fillItemCostBtn.titleLabel?.text = expendCost + "원"
                cell.fillFuelLiterBtn.titleLabel?.text = String((Int(expendCost) ?? 0)/2168) + "L"
                cell.selectDateBtn.setTitle(date, for: .normal)
                cell.selectDateBtn.addTarget(self, action:#selector(selectDateBtn(_ :)), for: .touchUpInside)
                return cell
            }
            else {
                let cell = editTableView.dequeueReusableCell(withIdentifier: "CarBookRecordItemTableViewCellID")
                return cell!
            }
        case 2:
            if let cell = editTableView.dequeueReusableCell(withIdentifier: "FillOilItemTableViewCellID") as?
                FillOilItemTableViewCell {
                return cell
            }
            else {
                let cell = editTableView.dequeueReusableCell(withIdentifier: "FillOilItemTableViewCellID")
                return cell!
            }
            
        default:
            let cell = editTableView.dequeueReusableCell(withIdentifier: "CarBookRecordItemTableViewCellID")
            return cell!
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            // item에 테이블리스트 열의 데이터 저장
            let item = tablelist[indexPath.row]
            // item의 "Type"값을 type에 저장
            let type = item["Type"] as? Int ?? 0
            // 타입 값에 따라 테이블뷰의 열의 높이 저장
            switch type {
            case 1 :
                return UITableView.automaticDimension
            case 2 :
                return UITableView.automaticDimension
            default :
                return 200.0
            }
        }
    
   @objc func selectDateBtn(_ sender: UIButton) {
       // 버튼 클릭시 날짜를 선택할 수 있게 CalendarsViewController으 뷰로 이동한다
       let storyboardVC = UIStoryboard(name: "TES", bundle: nil)
       if let vc = storyboardVC.instantiateViewController(withIdentifier: "CalendarsViewController")
           as? CalendarsViewController  {
           vc.modalTransitionStyle = .crossDissolve
           vc.modalPresentationStyle = .overFullScreen
           DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
               vc.delegate = self.dateDelegate
               vc.selectedDate = self.startDate
               self.present(vc, animated: false, completion: nil)
           }
       }
       
   }
    
}
extension CarBookRecordEditViewController : selectDateDelegate {
    func dateCalendarDismissCallBack() {
    }
    
    // 날짜 선택 함수 동작
    func selectDate(date: Date) {
        //  DateFormatter을 format에 저장
        let format = DateFormatter()
        // format의 달력 형식을 그레고리언 형식의 달력으로 저장
        format.calendar = Calendar(identifier: .gregorian)
        // format의 지역을 한국으로 저장
        format.locale = Locale(identifier: "ko_KR")
        
        // format의 날짜 표기 형식을 "년.월.일(요일)"로 저장
        format.dateFormat = "yyyy.MM.dd(E)"
        
 
            startDate = date
            dateLabel = format.string(for: date) ?? ""
        tablelist[1].updateValue(dateLabel as? Any, forKey: "Date")
            // 오늘 날짜의 문자를 선택한 날짜로 저장
        Swift.print("dateLabel\(dateLabel)")
        self.editTableView.reloadData()
}
}
 
