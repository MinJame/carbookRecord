//
//  File.swift
//  pagetest
//
//  Created by min on 2022/07/28.
//

import Foundation
import UIKit
import Alamofire

class BottomSheetViewController : UIViewController{
    
    @IBOutlet weak var mainContainer: UIView!
    
    @IBOutlet weak var categoryTableViewCell: UITableView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var bottomSheetTitleLabel: UILabel!
    var cost: Double = 0.0
    var costs : String = ""
    var result : String = ""
    var tablelist : [Dictionary<String,Any>] = []
    var items: [String] = []
    var liter : Double = 0.0
    var firstTag : Int = 0
    var secondTag : Int = 0
    var thirdTag : Int = 0
    var isDecimalCheck = false
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        setLists()
        mainContainer.layer.cornerRadius = 10
        mainContainer.layer.maskedCorners = [.layerMaxXMinYCorner, . layerMinXMinYCorner]
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismissView(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    func initTableView() {
        
        categoryTableViewCell.delegate = self
        categoryTableViewCell.dataSource = self
        categoryTableViewCell.rowHeight = UITableView.automaticDimension
        
        let cell1: UINib = UINib(nibName: "SelectItemTableViewCell", bundle: nil)
        categoryTableViewCell.register(cell1, forCellReuseIdentifier: "SelectItemTableViewCellID")
        let cell2: UINib = UINib(nibName: "KeyBoardTableViewCell", bundle: nil)
        categoryTableViewCell.register(cell2, forCellReuseIdentifier: "KeyBoardTableViewCellID")
        let cell3: UINib = UINib(nibName: "SelectFuelTypeCell", bundle: nil)
        categoryTableViewCell.register(cell3, forCellReuseIdentifier: "SelectFuelTypeCellID")
        
    }
    
    
    func setLists() {
        // 테이블리스트 데이터 및 카테고리 항목(임시로 선언) 선언
        tablelist = [
            ["Type": firstTag]
        
       
        ]
        items = ["주유","정비","기타","세차"]
    }
    
    func priceFormatter(value : Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 10
        numberFormatter.locale = Locale.current
        let result = numberFormatter.string(from: NSNumber(value:value))!
        return result
    }
    
}

extension BottomSheetViewController: UITableViewDelegate {
    
}

extension BottomSheetViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tablelist.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        // 테이블리스트의 row들의 데이터를 item으로 선언
        let item = tablelist[indexPath.row]

        let type = item["Type"] as? Int ?? 0
//
        if type == 1 {

            if let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "SelectItemTableViewCellID") as?
                SelectItemTableViewCell{
                bottomSheetTitleLabel.text = "카테고리 선택하기"
                cell.itemTypeLabel.text = items[indexPath.row]
                Swift.print("아이고\(items[indexPath.row])")
                return cell
            }else {
                let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "KeyBoardTableViewCellID")
                return cell!
            }
        }else if type == 2 {

            if let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "KeyBoardTableViewCellID") as?
                KeyBoardTableViewCell{
                bottomSheetTitleLabel.text = "금액 수정"
                Swift.print("1번이에요 3 \(cost)")
                cell.selectLabel.text = String(cost)
             
                cell.oneBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.secondBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.thirdBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.fourthBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.fifthBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.sixBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.sevenBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.eightBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.nineBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                return cell
            }else {
                let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "KeyBoardTableViewCellID")
                return cell!
            }

        } else if type == 3 {

            if let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "KeyBoardTableViewCellID") as?
                KeyBoardTableViewCell{
                bottomSheetTitleLabel.text = "주유량 수정"
                cell.selectLabel.text = String(format:"%.2f", liter)
                cell.currentLabel.text = "L"
                cell.oneBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.secondBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.thirdBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.fourthBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.fifthBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.sixBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.sevenBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.eightBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)
                cell.nineBtn.addTarget(self, action:#selector(inputNumbers(_ :)), for: .touchUpInside)


                return cell
            }else {
                let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "KeyBoardTableViewCellID")
                return cell!
            }

        }  else if type == 4 {

           if let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "SelectFuelTypeCellID") as?
                SelectFuelTypeCell{
               bottomSheetTitleLabel.text = "유종 선택"
               return cell
           }else {
               let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "SelectFuelTypeCellID")
               return cell!
           }

       }
        else {
            let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "SelectItemTableViewCellID")
            return cell!

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func inputNumbers(_ sender: UIButton) {
        let data = sender.titleLabel?.text ?? ""
        if let type = tablelist[0]["Type"] as? Int, type == 2 {
            if data != "." {
                if isDecimalCheck{
                    let check = cost - Double(Int(cost))
                    if check > 0 {
                        if let dCost = Double(cost.clean + data) {
                            cost = dCost
                            result = priceFormatter(value: cost)
                        }
                    }else {
                        if let dCost = Double(cost.clean+"."+data) {
                            cost = dCost
                            result = priceFormatter(value: cost)
                        }
                    }
                }else {
                    if let dCost = Double(cost.clean + data) {
                        cost = dCost
                        result = priceFormatter(value: cost)
                    }
                }
            }else {
                if let dCost = Double(cost.clean + data) {
                    cost = dCost
                    let _costs = cost + 0.1
                    isDecimalCheck = true
                    Swift.print("isDecimalCheck1\(isDecimalCheck)")
                    var checkCost = priceFormatter(value: _costs)
                    checkCost.removeLast()
                    result = checkCost
                }
                
            }
            Swift.print("1번이에요 cost \(cost)")
            Swift.print("1번이에요 cost2 \(costs)")
            Swift.print("1번이에요 resultcost \(result)")
            categoryTableViewCell.reloadData()
        }else if let type = tablelist[0]["Type"] as? Int, type == 3 {
            if data != "." {
                if isDecimalCheck{
                    let check = liter - Double(Int(liter))
                    if check >= 0 {
                        if let dCost = Double(liter.clean + data) {
                            liter = dCost
                            result = priceFormatter(value: liter)
                        }
                    }else {
                        if let dCost = Double(liter.clean+"."+data) {
                            liter = dCost
                            result = priceFormatter(value: liter)
                        }
                    }
                }else {
                    if let dCost = Double(liter.clean + data) {
                        liter = dCost
                        result = priceFormatter(value: liter)
                    }
                }
            }else {
                if let dCost = Double(liter.clean + data) {
                    liter = dCost
                    let _liters = liter + 0.1
                    Swift.print("isDecimalCheck2\(isDecimalCheck)")
                    isDecimalCheck = true
                    var checkLiter = priceFormatter(value: _liters)
                    checkLiter.removeLast()
                    result = checkLiter
                }
                
            }
            Swift.print("1번이에요 liter \(liter)")
            Swift.print("1번이에요 literresult \(result)")
            categoryTableViewCell.reloadData()
        }else {
            
        }
        
    }
        
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let item = tablelist[indexPath.row]
        // item의 "Type"값을 type에 저장
        let type = item["Type"] as? Int ?? 0
        // 타입 값에 따라 테이블뷰의 열의 높이 저장
        switch type {
        case 1 :
            return UITableView.automaticDimension
        case 2 :
            return UITableView.automaticDimension
        case 3 :
            return UITableView.automaticDimension
        case 4 :
            return UITableView.automaticDimension
            
        default :
            return 200.0
        }
    }
}
    
