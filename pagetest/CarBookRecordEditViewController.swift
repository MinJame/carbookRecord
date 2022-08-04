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
import BSImagePicker
import Photos
import Alamofire


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
    var memo : String? = "메모를 입력해주세요"
    var tablelist : [Dictionary<String,Any>] = []
    var firstTag : Int = 0
    var secondTag : Int = 0
    var thirdTag : Int = 0
    
    var userSelectedImages : [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        dateDelegate = self
        
        self.title = ""
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"icon_back_arrow"), style: .plain, target: self, action:#selector(self.dismissView))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        initTableView()
        setLists()
        setItems()
        setNotification()
    }
    
    func setLists() {
        // 테이블리스트 데이터들 선언
        tablelist = [
            ["Type": 1,"Distance" :"","Date":"","Mode" : 0,"isLocation": false,"imageFirst" : UIImage.self, "imageSecond" : UIImage.self ],
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
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
  
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.editTableView.contentInset
        contentInset.bottom = keyboardFrame.size.height - 60
        editTableView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        
        editTableView.contentInset = contentInset
    }
    
    
    @objc func dismissKeyboard() {
        
        self.view.endEditing(true)
        
    }
    
    @objc func dismissView() {
//
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is CarBookRecordViewController {
                _ = self.navigationController?.popToViewController(vc as! CarBookRecordViewController, animated: true)
            }
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
                firstTag = cell.selectRecordItemBtn.tag
                secondTag = cell.fillItemCostBtn.tag
                thirdTag =  cell.fillFuelLiterBtn.tag
                let date = tablelist[1]["Date"] as? String ?? ""
                
                cell.fillItemCostBtn.titleLabel?.text = ""
                
                cell.fillItemCostBtn.setTitle(expendCost + "원",for : .normal)
                cell.fillFuelLiterBtn.setTitle(String((Double(expendCost) ?? 0)/2168) + "L",for : .normal)
                cell.selectRecordItemBtn.addTarget(self, action: #selector(moveItemBtn(_ :)), for:  .touchUpInside)
                cell.fillItemCostBtn.addTarget(self, action: #selector(moveItemBtn(_ :)), for:  .touchUpInside)
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
                
                let first = tablelist[1]["imageFirst"] as? UIImage
                let second = tablelist[1]["imageSecond"] as? UIImage
                
                if first != nil {
                    cell.selectPictureBtn.setTitle("", for: .normal)
                    cell.firstImageView.isHidden = false
                    cell.seconeImageView.isHidden = false
                    cell.thirdImageView.isHidden = false
                    cell.fourthImageView.isHidden = false
                    cell.fifthImageView.isHidden = false
                    cell.firstImageView.image = first
                    cell.seconeImageView.image = second
                }else {
                    cell.firstImageView.isHidden = true
                    cell.seconeImageView.isHidden = true
                    cell.thirdImageView.isHidden = true
                    cell.fourthImageView.isHidden = true
                    cell.fifthImageView.isHidden = true
                }
              
       
                
                cell.selectPictureBtn.addTarget(self, action:#selector(selectImageBtn(_ :)), for: .touchUpInside)
                
                cell.fillMemoBtn.addTarget(self, action:#selector(moveMemoBtn(_ :)), for: .touchUpInside)
                cell.fillMemoBtn.setTitle(memo, for: .normal)
                cell.fillMemoBtn.titleLabel?.lineBreakMode = .byWordWrapping
                cell.fillMemoBtn.titleLabel?.textAlignment = .left
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
    
    @objc func selectImageBtn(_ sender: UIButton) {

        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.selection.unselectOnReachingMax = true

        let start = Date()
        self.presentImagePicker(imagePicker, select: { (asset) in
        }, deselect: { (asset) in
        }, cancel: { (assets) in
        
        }, finish: { (assets) in
            if assets.count != 0 {
                
                for i in 0..<assets.count {
                    
                    let imageManager = PHImageManager.default()
                    let option = PHImageRequestOptions()
                    option.isSynchronous = true
                    var thumbnail = UIImage()
                    
                    imageManager.requestImage(for: assets[i],
                                              targetSize: CGSize(width: 200, height: 200),
                                              contentMode: .aspectFit,
                                              options: option) { (result, info) in
                        thumbnail = result!
                    }
                    
                    let data = thumbnail.jpegData(compressionQuality: 0.7)
                    let newImage = UIImage(data: data!)
                    self.userSelectedImages.append(newImage! as UIImage)
                    Swift.print("userSelectedImages1\(self.userSelectedImages.count)")
                    self.tablelist[1].updateValue(self.userSelectedImages.first, forKey: "imageFirst")
                    self.tablelist[1].updateValue(self.userSelectedImages.last, forKey: "imageSecond")
//                    Swift.print("userSelectedImages\(self.userSelectedImages)")
                  
                }
                self.editTableView.reloadData()
            }
        }, completion: {
            let finish = Date()
        })
    }

    
    
    
    @objc func moveMemoBtn(_ sender: UIButton) {

        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CarBookRecordMemoViewController")
            as? CarBookRecordMemoViewController  {
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            if memo != "메모를 입력해주세요" {
                vc.memos = memo ?? ""
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func moveItemBtn(_ sender: UIButton) {
       
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BottomSheetViewController")
            as? BottomSheetViewController  {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.firstTag = firstTag
            vc.secondTag = secondTag
            vc.thirdTag = thirdTag
            vc.cost = expendCost
            Swift.print("buttonTag\(firstTag)")
            Swift.print("buttonTag\( vc.firstTag)")
            self.present(vc, animated: true)
        }
        
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
        format.dateFormat = "yyyy년 MM월 dd일 (E)"
        
        startDate = date
        dateLabel = format.string(for: date) ?? ""
        tablelist[1].updateValue(dateLabel, forKey: "Date")
        // 오늘 날짜의 문자를 선택한 날짜로 저장
        
        self.editTableView.reloadData()
    }
}

