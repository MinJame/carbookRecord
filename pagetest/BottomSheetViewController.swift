//
//  File.swift
//  pagetest
//
//  Created by min on 2022/07/28.
//

import Foundation
import UIKit

class BottomSheetViewController : UIViewController{
    
    @IBOutlet weak var mainContainer: UIView!
    
    @IBOutlet weak var categoryTableViewCell: UITableView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dismissBtn: UIButton!
    var cost : String = ""
    var tablelist : [Dictionary<String,Any>] = []
    var items: [String] = []
    var firstTag : Int = 0
    var secondTag : Int = 0
    var thirdTag : Int = 0
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
        
    }
    
    
    func setLists() {
        // 테이블리스트 데이터 및 카테고리 항목(임시로 선언) 선언
        tablelist = [
            ["Type": firstTag],
            ["Type": secondTag],
            ["Type": thirdTag],
            ["Type": 4]
       
        ]
        items = ["주유","정비","기타","세차"]
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
        //        // item의 "Type"을 타입으로 선언
        
//        let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "SelectItemTableViewCellID") as?
//            SelectItemTableViewCell
//
//        cell?.itemTypeLabel.text = items[indexPath.row]
//        return cell!
        let type = item["Type"] as? Int ?? 0
//
        if type == 1 {
            if let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "SelectItemTableViewCellID") as?
                SelectItemTableViewCell{

                cell.itemTypeLabel.text = items[indexPath.row]
                Swift.print("아이고\(items[indexPath.row])")
                Swift.print("아이고\(cell.itemTypeLabel.text)")
                return cell
            }else {
                let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "SelectItemTableViewCellID")
                return cell!
            }
//        } else if type == 2 {
//
//            if let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "KeyBoardTableViewCellID") as?
//                KeyBoardTableViewCell{
//
//               cell.selectLabel.text = cost
//
//
//                return cell
//            }else {
//                let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "KeyBoardTableViewCellID")
//                return cell!
//            }
//
//        }
//        else {
//            let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "SelectItemTableViewCellID")
//            return cell!
//
//        }
    }else {
        let cell = categoryTableViewCell.dequeueReusableCell(withIdentifier: "SelectItemTableViewCellID")
        return cell!
    }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
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
    
