//
//  OilEditsViewController.swift
//  pagetest
//
//  Created by min on 2022/03/29.
//

import Foundation
import UIKit

class OilEditsViewController: UIViewController{
    @IBOutlet weak var todayDayLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var OilTableView: UITableView!
    var tablelist : [Dictionary<String,Any>] = []
    var repairDelegate : RepairCallbackDelegate?
    var dateDelegate : selectDateDelegate?
    var startDate : Date?
    var finishDate : Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        dateDelegate = self
        initTableViews()
        setNotification()
        setItems()
        initTitle()
    }
    func initTableViews() {
        
        OilTableView.delegate = self
        OilTableView.dataSource = self
        OilTableView.rowHeight = UITableView.automaticDimension
        
        let cell1: UINib = UINib(nibName: "repairlocateTableViewCell", bundle: nil)
        OilTableView.register(cell1, forCellReuseIdentifier: "repairlocateTableViewCellID")
        
        let cell2: UINib = UINib(nibName: "RepairAddTableViewCell", bundle: nil)
        self.OilTableView.register(cell2, forCellReuseIdentifier: "RepairAddTableViewCellID")
        
        let cell3: UINib = UINib(nibName: "selectFueltypeCell", bundle: nil)
        OilTableView.register(cell3, forCellReuseIdentifier: "selectFueltypeCellID")
        
        let cell4: UINib = UINib(nibName: "directInputTableViewCell", bundle: nil)
        OilTableView.register(cell4, forCellReuseIdentifier: "directInputTableViewCellID")
        OilTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
    }
    
    func setItems(){
        tablelist = [
            ["Type": 1,"Distance" :"","Mode" : 0,"isLocation": false],
            ["Type": 2,"Cost" : 0,"Fuel": 0,"Liter" : 0],
            ["Type": 3],
            ["Type": 4],
            // ["Type": 2],
            // cellId 있는 경우와 없는 경우 구분

        ]
    }
    func initTitle() {
        let formatter = DateFormatter()
        // formatter의 달력은 그레고리언 형식
        formatter.calendar = Calendar(identifier: .gregorian)
        // formatter의 지역은 한국
        formatter.locale = Locale(identifier: "ko_KR")
        // 날짜표시를 년.월.일(요일)형식으로 선언
        formatter.dateFormat = "yyyy.MM.dd(E)"
        // finishButton을 완료로 선언 settitle ceLid 비교

        // todayDateLabel에 dateString 저장
        todayDayLabel.text = formatter.string(for: Date()) ?? ""
       
        
    }
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    // db에서 정비목록을 불러올때 정비목록 변환해주는 함수
    func getOilTypeCodeTitle(code : String) -> String {
       
        switch code {
        case "1" :
            return "휘발유"
        case "2":
            return"경유"
        case "3":
            return "LPG"
        case "4" :
            return "에탄올"
        case "5":
            return  "메탄올"
        case "6" :
            return "전기"
        default :
            return "휘발유"
        }
       
    }
    // 데이터 삽입하기
    func insertDatas(){
        //carbookdb 불러오기
        let carBookDataBase = CARBOOK_DAO.sharedInstance
        // 정비기록에서 새로운 추가할 아이템리스트 변수로 선언
//        var insertcarBookDataItemList : [Dictionary<String,Any>] = []
        // 테이블리스트첫번째데이터를 변수명으로 선언
        let upperDataList = tablelist[0]
//        var rePairList : [String] = []
        // 수정할 날짜 적용하기 위해서 날짜 형식 포맷
        var insertcarBookDataList : [Dictionary<String,Any>] = []
        let formatter = DateFormatter()
        // 날짜 달력 형식 선언
        formatter.calendar = Calendar(identifier: .gregorian)
        // 날짜 형식의 지역 선언
        formatter.locale = Locale(identifier: "ko_KR")
        // 날짜 형식의 포맷 선언
        formatter.dateFormat = "yyyyMMddHHmmss"
        // 새로 저장에 필요한 정비기록 기본정보들을 저장
        let carBookData : [String:Any]  = [
            "carbookRecordRepairMode" : upperDataList["Type"] as? Int ?? 0,
            "carbookRecordExpendDate" : formatter.string(for: startDate ?? Date()) ?? "",
            "carbookRecordTotalDistance" : upperDataList["Distance"] as? Double ?? 0.0,
            "carbookRecordIsHidden" : 0
        ]

            // repairList의 갯수와 테이블리스트의 갯수가 같을 경우
            let insertCarBookdata = carBookDataBase.insertCarbookData(carbookData: carBookData)
            //테이블 리스트 갯수 만큼 for문 동작한다
            for i in 0..<tablelist.count {
                // 새로 생성할 정비기록항목들은 위에서 생성한 데이터의 id값과 동일한 곳에 들어가야하고 id값은 Int형임으로 Int형으로 선언
                if let id = insertCarBookdata["id"] as? Int {
                    // 테이블리스트 i번째 데이터를 item이라고 선언
                    let item = tablelist[i]
                    // item중에 type이 Int형이고 type 값이 3이면 동작실행
                    if let type = item["Type"] as? Int, type == 2 {
                        // 새로 추가할 정비기록항목들을 묶어서 저장
                        let insertCarBookRecordOilItem : Dictionary<String,Any> = [
                            "carbookRecordItemRecordId" : id,
                            "carbookRecordOilItemFillFuel" : item["Category"] as? String ?? "",
                            "carbookRecordOilItemExpenseMemo" : item["memo"] as? String ?? "",
                            "carbookRecordOilItemExpenseCost" : item["cost"] as? Double ?? 0.0,
                            "carbookRecordOilItemFuelLiter" : item["Liter"] as? Double ?? 0.0,
                            "carbookRecordItemIsHidden" : item["isHidden"] as? Int ?? 0
                        ]
                        // insertcarBookDataItemList에 insertCarBookRecordItem를 더해준다
                        insertcarBookDataList.append(insertCarBookRecordOilItem)
                    }
                }
            }
            // 정비항목들을 db에 저장한다
            _ = carBookDataBase.insertCarbookOilItems(carbookDataOilItems: insertcarBookDataList)
            // 동작 후 메인 페이지로 이동
            self.dismiss(animated: true){
                self.repairDelegate?.setRepairData(year: nil)
             
                Swift.print("ID\(carBookData)")
                Swift.print("ID\(insertcarBookDataList)")
        }
        
    }
    
    @IBAction func selectDateBtn(_ sender: Any) {
        // 버튼 클릭시 날짜를 선택할 수 있게 CalendarsViewController으 뷰로 이동한다
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarsViewController")
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
    
    @IBAction func editButton(_ sender: Any) {
        insertDatas()
    }
    
    
    // MARK: - TextField & Keyboard Methods
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.OilTableView.contentInset
        contentInset.bottom = keyboardFrame.size.height - 60
        OilTableView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        
        OilTableView.contentInset = contentInset
    }
    
    
    @objc func dismissKeyboard() {
        
        self.view.endEditing(true)
        
    }
    
    
}

extension OilEditsViewController: UITableViewDelegate {
    
}

extension OilEditsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tablelist.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 테이블리스트의 row들의 데이터를 item으로 선언
        let item = tablelist[indexPath.row]
        // item의 "Type"을 타입으로 선언
        let type = item["Type"] as? Int ?? 0
        
        switch type {

        case 1 :
            if let cell = OilTableView.dequeueReusableCell(withIdentifier: "repairlocateTableViewCellID") as?
                repairlocateTableViewCell{
                
                // driveDistance가 텍스트 필드여서 텍스트 필드 delegate 적용
                cell.totalDistanceField.delegate = self
                // driveDistance의 문자는 테이블리스트의["Distance"]값으로 할려고하는데 더블형임으로 문자형으로 변환해서 보여준다
                cell.totalDistanceField.text = String(format: "%.f", tablelist[0]["Distance"] as? Double ?? 0.0)
                
                return cell
            }else {
                let cell = OilTableView.dequeueReusableCell(withIdentifier: "repairlocateTableViewCellID")
                return cell!
            }
          
        case 2 :
            if let cell = OilTableView.dequeueReusableCell(withIdentifier: "RepairAddTableViewCellID") as?
                RepairAddTableViewCell{
                
                cell.totalFulCost.delegate = self
                cell.fuelLiterField.delegate = self
                
                cell.totalFulCost.text = String(format: "%.f", tablelist[1]["Cost"] as? Double ?? 0.0)
                cell.fuelLiterField.text = String(format: "%.f", tablelist[1]["Liter"] as? Double ?? 0.0)

                return cell
            }else {
                let cell = OilTableView.dequeueReusableCell(withIdentifier: "RepairAddTableViewCellID")
                return cell!
            }
          
        case 3 :
            if let cell = OilTableView.dequeueReusableCell(withIdentifier: "selectFueltypeCellID") as? selectFueltypeCell {
                cell.changeoil.addTarget(self, action: #selector(changereFilButton(_ :)), for: .valueChanged)
                if  cell.changeoil.selectedSegmentIndex == 0 {
                    cell.changeDrag.isHidden = true
                }
                else if cell.changeoil.selectedSegmentIndex == 1 {

                    cell.changeDrag.isHidden = false
                }
                else {
                    cell.changeDrag.isHidden = true
                }
      
                return cell
            }
            else {

                let cell = OilTableView.dequeueReusableCell(withIdentifier: "selectFueltypeCellID")


                return cell!
            }
        case 4 :
            if let cell = OilTableView.dequeueReusableCell(withIdentifier: "directInputTableViewCellID") as? directInputTableViewCell {
              
      
                return cell
            }
            else {

                let cell = OilTableView.dequeueReusableCell(withIdentifier: "directInputTableViewCellID")


                return cell!
            }
            

        default :
            let cell = OilTableView.dequeueReusableCell(withIdentifier: "directInputTableViewCellID")
            
            
            return cell!
        }
    }
    
    
    @objc func addBtnAction(_ sender: UIButton) {
        
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "testViewController"){
            
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func changereFilButton(_ sender: UIButton) {
        // 만약 테이블리스트 첫번째의 islocation이 bool형이면 islocation에 저장
        if let isLocation = tablelist[0]["isLocation"] as? Bool {
            //그리고 테이블리스트에 islocation값의 반대되는 값을 저장한다
            tablelist[0].updateValue(!isLocation , forKey: "isLocation")
        }
        // 그후 테이블뷰를 다시불러온다
        self.OilTableView.reloadData()
        
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
        case 3 :
            return UITableView.automaticDimension
        case 4 :
            return UITableView.automaticDimension
        default :
            return 200.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
// 달력선택 delegate
extension OilEditsViewController : selectDateDelegate {
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

            if finishDate == nil {
                startDate = date
                finishDate = nil
                // 오늘 날짜의 문자를 선택한 날짜로 저장
                todayDayLabel.text = format.string(for: date) ?? ""
            }else {
                      finishDate = date
                todayDayLabel.text = format.string(for: date) ?? ""
            }
            
        }
    }

// MARK: - Text

// MARK: - TextView,TextField 사용을 위한 Delegate 선언
extension OilEditsViewController : UITextViewDelegate,UITextFieldDelegate {
    // 텍스트뷰 입력이 끝날때 동작하는 함수
    func textViewDidEndEditing(_ textView: UITextView) {
        // 만약 텍스트뷰의 문자가 비어 있으면
        if textView.text.isEmpty {
            // 텍스트뷰의 문자를 "메모 250자 기입가능\n(이모티콘 불가)"로 입력해준다
            textView.text = "메모 250자 기입가능\n(이모티콘 불가)"
            // 텍스트뷰의 문자색을 연한 갈색으로 정한다
            textView.textColor = UIColor.lightGray
        }else {
            // 만약 텍스트 뷰가 비어 있지 않다면 텍스트뷰의 데이터를 memo에 저장한다
        }

    }
    //텍스트뷰 입력이 시작될때 동작하는 함수
    func textViewDidBeginEditing(_ textView: UITextView) {
        // 만약 텍스트뷰의 문자색이 연한갈색이면
        if textView.textColor == UIColor.lightGray {
            //텍스트뷰의 문자를 없애고
            textView.text = nil
            // 텍스트뷰의 입력되는 문자를 검은색으로 입력시킨다
            textView.textColor = UIColor.black
        }
        
    }
    // 텍스트필드에 입력이 끝났을때 동작하는 함수
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 만약 텍스트 필드의 태그 값이 0인 경우
        if textField.tag == 0 {
            // 해당되는 텍스트 필드의 값을 더블형으로 변환시켜서 테이블리스트 "Distance"에 업데이트 시킨다
            tablelist[textField.tag].updateValue(NumberFormatter().number(from: textField.text?.replacingOccurrences(of: ",", with: "") ?? "0.0")?.doubleValue as Any , forKey: "Distance")
        } else if textField.tag == 2 {
            tablelist[2].updateValue(NumberFormatter().number(from: textField.text?.replacingOccurrences(of: ",", with: "") ?? "0.0")?.doubleValue as Any , forKey: "Cost")
            
        } else if textField.tag == 3 {
            tablelist[2].updateValue(NumberFormatter().number(from: textField.text?.replacingOccurrences(of: ",", with: "") ?? "0.0")?.doubleValue as Any , forKey: "Liter")
            
        }else {
            
        }
    }
    // 텍스트 필드가 입력시작될때 동작하는 함수
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 만약 텍스트필드의 문자색이 연한갈색이면
        if textField.textColor == UIColor.lightGray {
            // 만약 텍스트필드의 문자를 없애고
            textField.text = nil
            // 텍스트필드의 입력되는 문자를 검은색으로 입력시킨다
            textField.textColor = UIColor.black
        }
    }
    
    //textfield가 숫자일때 단위마다 ,찍어주는 함수
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 1,000,000
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수

        if let removeAllSeprator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
            var beforeForemattedString = removeAllSeprator + string
            if formatter.number(from: string) != nil {
                if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                    textField.text = formattedString
                    return false
                }
            }else{ // 숫자가 아닐 때
                if string == "" {
                    // 백스페이스일때
                    let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                    beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        textField.text = formattedString
                        return false
                    }
                }else{
                    // 문자일 때
                    return false
                }
            }
            
        }
        
        return true
    }
    
}


