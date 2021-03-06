//
//  OilEditsViewController.swift
//  pagetest
//
//  Created by min on 2022/03/29.
//

import Foundation
import UIKit


class OilEditsViewController: UIViewController{
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var todayDayLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var oilTableView: UITableView!
    var tablelist : [Dictionary<String,Any>] = []
    var repairDelegate : RepairCallbackDelegate?
    var dateDelegate : selectDateDelegate?
    var searchDelegate : SearchCallbackDelegate?
    var startDate : Date?
    var searchTitle : String = ""
    var cellId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateDelegate = self
        initTableViews()
        setNotification()
        setItems()
        initTitle()
        if cellId != nil {
            getCarBookData()
        }

    }
   
    func initTableViews() {
        
        oilTableView.delegate = self
        oilTableView.dataSource = self
        oilTableView.rowHeight = UITableView.automaticDimension
        
        let cell1: UINib = UINib(nibName: "OilLocateTableViewCell", bundle: nil)
        oilTableView.register(cell1, forCellReuseIdentifier: "OilLocateTableViewCellID")
        
        let cell2: UINib = UINib(nibName: "OilAddTableViewCell", bundle: nil)
        self.oilTableView.register(cell2, forCellReuseIdentifier: "OilAddTableViewCellID")
        
//
//        oilTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
    }
    //수정필요
    func setItems(){
        tablelist = [
            ["Type": 1,"Distance" :"","isLocation": false],
            ["Type": 2,"Cost" : 0,"Fuel": 2100.0,"Liter" : 0.00,"Id": 0,"FuelType" : "경유","Memo": "","Image" :"주소"]
      
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
        
        if cellId != nil {
            finishButton.setTitle("수정", for: .normal)
       
        }else {
            finishButton.setTitle("완료", for: .normal)
          
        }
        
        
    }
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    // db에서 정비목록을 불러올때 정비목록 변환해주는 함수

    //네이밍 수정
    func getCarBookData() {
        let carBookDatabase = CARBOOK_DAO.sharedInstance
        // db에서 celId에 해당되는 데이터가 있을경우 list에 저장하고 data item 변수 저장
        // 형식
        if let item : Dictionary<String, Any> = carBookDatabase.selectFuelingData(id: cellId ?? "") {
            // 테이블리스트의  "Distance"에  데이터를 업데이트 시켜준다0.0
            tablelist[0].updateValue(item["fuelingDist"] as? Double ?? 0, forKey: "Distance")
            // 테이블리스트의 "Type"에 데이터를 업데이트 시켜준다
            // list의 "carbookRecordExpendDate"가 문자형일 경우 date에 저장해준다
            let date = item["fuelingExpendDate"] as? String ?? ""
            // DateFormatter를 formatter에 저장한다
            let formatter = DateFormatter()
            // formatter 표시 형식을 "년월일시분초"형식으로 저장한다
            formatter.dateFormat = "yyyyMMddHHmmss"
            // formatter 지역을 한국으로 설정한다
            formatter.locale = Locale(identifier: "ko_KR")
            // dates를 date 형식으로 저장한다
            let dates = formatter.date(from: date)
            // dates startDate에 저장한다
            startDate = dates
            // formatter형식을 "년월일(요일)"으로 표시할수 있게 저장한다
            formatter.dateFormat = "yyyy.MM.dd(E)"
            // finishButton의 문자를 수정으로 저장한다 setTitle
            // todayDateLabel의 문자에 dateString 저장 비교해서
            todayDayLabel.text = formatter.string(for: dates) ?? ""
            // 만약 list의 "carbokRecordRepairMode"가 2일 경우
            
            // getcarBookDatas 함수를 호출한다
            
            
            tablelist[1].updateValue(item["fuelingID"] as? String ?? "", forKey: "Id")
            // 테이블리스트의 "Type"에 데이터를 업데이트 시켜준다
            tablelist[1].updateValue(item["fuelingTotalCost"] as? Double ?? 0.0, forKey: "Cost")
            tablelist[1].updateValue(item["fuelType"] as? String ?? 0.0, forKey: "FuelType")
            tablelist[1].updateValue(item["fuelingFuelCost"] as? Double ?? 0.0, forKey: "Fuel")
            tablelist[1].updateValue(item["fuelingItemVolume"] as? Double ?? 0.0, forKey: "Liter")
            tablelist[1].updateValue(item["fuelingMemo"] as? String ?? "", forKey: "Memo")
            oilTableView.reloadData()
            Swift.print("아이디 값1\(item)")
            Swift.print("아이디 값2\(tablelist[1]["FuelType"] as? String ?? "")")
            
        }
    }
    // carBookRecordItems


    // 데이터 수정하기
    func updateData() {
        //carbookdb 불러오기
        let carBookDataBase = CARBOOK_DAO.sharedInstance
        // 테이블리스트첫번째데이터를 변수명으로 선언
        let upperDataList = tablelist[0]
        // 수정페이지에서 새로운 추가할 아이템리스트 변수로 선언
        let downerDataList = tablelist[1]
        // 수정페이지에서 수정할 아이템리스트 변수로 선언
        // 수정할 날짜 적용하기 위해서 날짜 형식 포맷
        let formatter = DateFormatter()
        // 날짜 달력 형식 선언
        formatter.calendar = Calendar(identifier: .gregorian)
        // 날짜 형식의 지역 선언
        formatter.locale = Locale(identifier: "ko_KR")
        // 날짜 형식의 포맷 선언
        formatter.dateFormat = "yyyyMMddHHmmss"
        //  수정에 필요한 정비기록의 기본정보들 묶어서 저장
        let years = formatter.string(for: startDate ?? Date()) ?? ""
        let year = String(years.dropLast(10))
        Swift.print("년\(year)")
        
        let updateFuelingDataList : Dictionary<String,Any>  = [
            "fuelingID" :  downerDataList["Id"] as? String ?? "",
            "fuelingIsHidden" : 0,
            "fuelingPlace" : "동일주유소",
            "fuelingAddress" : "옆집동네점",
            "fuelingLatitude" : 39.1234,
            "fuelingLongitude" : 127.88,
            "fuelingExpendDate" : formatter.string(for: startDate ?? Date()) ?? "",
            "fuelingDist" : upperDataList["Distance"] as? Double ?? 0.0,
            "fuelingTotalCost":downerDataList["Cost"] as? Double ?? 0.0,
            "fuelType": downerDataList["FuelType"] as? String ?? "" ,
            "fuelingFuelCost":downerDataList["Fuel"] as? Double ?? 0.0,
            "fuelingItemVolume": downerDataList["Liter"] as? Double ?? 0.0,
            "fuelingImage":downerDataList["Image"] as? String ?? "",
            "fuelingMemo": downerDataList["Memo"] as? String ?? ""
       
        ]
            // 수정한 정비기록 데이터들을 db에 저장
            let _ = carBookDataBase.modifyCarBookDataOilItem(carbookDataOilItem: updateFuelingDataList)
            
            
            self.dismiss(animated: true) {
                self.repairDelegate?.setRepairData(year: year)
                self.searchDelegate?.setSearchData(name: self.searchTitle)
            }
        }
        
    
    // 데이터 삽입하기
    func insertDatas(){
        //carbookdb 불러오기
        let carBookDataBase = CARBOOK_DAO.sharedInstance
        // 정비기록에서 새로운 추가할 아이템리스트 변수로 선언
        // 테이블리스트첫번째데이터를 변수명으로 선언
        let upperDataList = tablelist[0]
        let downerDataList = tablelist[1]
        // 수정할 날짜 적용하기 위해서 날짜 형식 포맷
        let formatter = DateFormatter()
        // 날짜 달력 형식 선언
        formatter.calendar = Calendar(identifier: .gregorian)
        // 날짜 형식의 지역 선언
        formatter.locale = Locale(identifier: "ko_KR")
        // 날짜 형식의 포맷 선언
        formatter.dateFormat = "yyyyMMddHHmmss"
        // 새로 저장에 필요한 정비기록 기본정보들을 저장
        let insertFuelingDataList : Dictionary<String,Any>  = [
            "carSN" : 1,
            "fuelingID" :  formatter.string(for: Date()) ?? "",
            "fuelingIsHidden" : 0,
            "fuelingPlace" : "동일주유소",
            "fuelingAddress" : "옆집동네점",
            "fuelingLatitude" : 39.1234,
            "fuelingLongitude" : 127.88,
            "fuelingExpendDate" : formatter.string(for: startDate ?? Date()) ?? "",
            "fuelingDist" : upperDataList["Distance"] as? Double ?? 0.0,
            "fuelingTotalCost":downerDataList["Cost"] as? Double ?? 0.0,
            "fuelType": downerDataList["FuelType"] as? String ?? "" ,
            "fuelingFuelCost":downerDataList["Fuel"] as? Double ?? 0.0,
            "fuelingItemVolume": downerDataList["Liter"] as? Double ?? 0.0,
            "fuelingImage":downerDataList["Image"] as? String ?? "",
            "fuelingMemo": downerDataList["Memo"] as? String ?? ""
       
        ]
    
        // 정비항목들을 db에 저장한다
        _ = carBookDataBase.insertCarbookOilItems(carbookDataOilItems: insertFuelingDataList)
        // 동작 후 메인 페이지로 이동
        self.dismiss(animated: true){
            self.repairDelegate?.setRepairData(year: nil)
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
        if cellId != nil {
            updateData()
        }  else {
            insertDatas()
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - TextField & Keyboard Methods
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.oilTableView.contentInset
        contentInset.bottom = keyboardFrame.size.height - 60
        oilTableView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        
        oilTableView.contentInset = contentInset
    }
    
    
    @objc func dismissKeyboard() {
        
        self.view.endEditing(true)
        
    }
    
    
}

extension OilEditsViewController: UITableViewDelegate {
    
}

extension OilEditsViewController: UITableViewDataSource {

    
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
            if let cell = oilTableView.dequeueReusableCell(withIdentifier: "OilLocateTableViewCellID") as?
                OilLocateTableViewCell{
                
                // driveDistance가 텍스트 필드여서 텍스트 필드 delegate 적용
                cell.totalDistanceField.delegate = self
                // driveDistance의 문자는 테이블리스트의["Distance"]값으로 할려고하는데 더블형임으로 문자형으로 변환해서 보여준다
                cell.totalDistanceField.text = String(format: "%.f", tablelist[0]["Distance"] as? Double ?? 0.0)
                cell.totalDistanceField.textColor = .black
                
                return cell
            }else {
                let cell = oilTableView.dequeueReusableCell(withIdentifier: "OilLocateTableViewCellID")
                return cell!
            }
            
        case 2 :
            if let cell = oilTableView.dequeueReusableCell(withIdentifier: "OilAddTableViewCellID") as?
                OilAddTableViewCell{
                cell.oilMemoView.delegate = self
                cell.totalFulCost.delegate = self
                cell.fuelLiterField.delegate = self
                cell.fuelCost.delegate = self
                if cellId != nil {
                    cell.fuelTypeButton.titleLabel?.text = tablelist[1]["FuelType"] as? String ?? ""
                    cell.fuelTypeButton.addTarget(self, action: #selector(changereOilFuelButton(_ :)), for:  .touchUpInside)
                    cell.fuelTypeButton.setTitle(tablelist[1]["FuelType"] as? String ?? "", for: .normal)
              
                }else {
                    cell.fuelTypeButton.addTarget(self, action: #selector(changereOilFuelButton(_ :)), for:  .touchUpInside)
                    cell.fuelTypeButton.setTitle(tablelist[1]["FuelType"] as? String ?? "", for: .normal)
                }
                let cellCost = tablelist[1]["Cost"] as? Double ?? 0.0
                let fuelcost = tablelist[1]["Fuel"] as? Double ?? 0.0
                let fuelLiter = tablelist[1]["Liter"] as? Double ?? 0.0
                cell.totalFulCost.text = String(format: "%.f", cellCost)
                cell.totalFulCost.textColor = .black
                cell.fuelCost.text = String(format: "%.f", fuelcost)
                cell.fuelCost.textColor = .black
                cell.fuelLiterField.text = String(format: "%.2f", fuelLiter)
                cell.fuelLiterField.textColor = .black
                if let memo = item["Memo"] as? String, memo != "" {
                    cell.oilMemoView.text = memo
                    cell.oilMemoView.textColor = .black
                    
                }
                
                return cell
            }else {
                let cell = oilTableView.dequeueReusableCell(withIdentifier: "OilAddTableViewCellID")
                return cell!
            }
            
        default :
            let cell = oilTableView.dequeueReusableCell(withIdentifier: "OilLocateTableViewCellID")
            
            
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
        self.oilTableView.reloadData()
        
    }
    
    @objc func changereOilFuelButton(_ sender: UIButton) {
        // 만약 테이블리스트 첫번째의 islocation이 bool형이면 islocation에 저장
        
        let alert = UIAlertController(title: "유종", message: "", preferredStyle: UIAlertController.Style.alert)
       
        let gasoline = UIAlertAction(title: "휘발유", style: UIAlertAction.Style.default, handler:{[self]
            action in
            tablelist[1].updateValue("휘발유" , forKey: "FuelType")
            self.oilTableView.reloadData()
        })
        let diesel = UIAlertAction(title: "경유", style: UIAlertAction.Style.default, handler:{[self]
            action in
            tablelist[1].updateValue("경유" , forKey: "FuelType")
            self.oilTableView.reloadData()
        })
        let LPG = UIAlertAction(title: "LPG", style: UIAlertAction.Style.default, handler:{[self]
            action in
            tablelist[1].updateValue("LPG" , forKey: "FuelType")
            self.oilTableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel)
        alert.addAction(gasoline)
        alert.addAction(diesel)
        alert.addAction(LPG)
        alert.addAction(cancel) // 알림창에 버튼추가
       
        if UIDevice.current.userInterfaceIdiom == .pad { //디바이스 타입이 iPad일때
          if let popoverController = alert.popoverPresentationController {
              // ActionSheet가 표현되는 위치를 저장해줍니다.
              popoverController.sourceView = self.view
              popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
              popoverController.permittedArrowDirections = []
              self.present(alert, animated: true, completion: nil)
          }
        } else {
          self.present(alert, animated: true)
        }
 
        self.oilTableView.reloadData()
        
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
            return 600.0
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
        
 
            startDate = date
     
            // 오늘 날짜의 문자를 선택한 날짜로 저장
            todayDayLabel.text = format.string(for: date) ?? ""
       
}
}
 

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
            if textView.tag == 9 {
                // 해당되는 텍스트 필드의 값을 더블형으로 변환시켜서 테이블리스트 "Distance"에 업데이트 시킨다
                tablelist[1].updateValue(textView.text ?? "", forKey: "Memo")
            }
            
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
        

        
        if textField.tag == 5 {
            // 해당되는 텍스트 필드의 값을 더블형으로 변환시켜서 테이블리스트 "Distance"에 업데이트 시킨다
            tablelist[0].updateValue(NumberFormatter().number(from: textField.text?.replacingOccurrences(of: ",", with: "") ?? "0.0")?.doubleValue as Any , forKey: "Distance")
        }
        if textField.tag == 6 {
      
            tablelist[1].updateValue(NumberFormatter().number(from: textField.text?.replacingOccurrences(of: ",", with: "") ?? "0.0")?.doubleValue as Any , forKey: "Cost")
            self.oilTableView.reloadData()
          
             if tablelist[1]["Cost"] as? Double != 0{
                 tablelist[1].updateValue((tablelist[1]["Cost"] as? Double ?? 0.0)/(tablelist[1]["Fuel"] as? Double ?? 0.0), forKey: "Liter")
             }else {
                 tablelist[1].updateValue("0", forKey: "Cost")
                 tablelist[1].updateValue("0", forKey: "Liter")
             }
            
        }
        if textField.tag == 7 {
            self.oilTableView.reloadData()
            tablelist[1].updateValue(NumberFormatter().number(from: textField.text?.replacingOccurrences(of: ",", with: "") ?? "0.0")?.doubleValue as Any , forKey: "Fuel")
          
            if tablelist[1]["Fuel"] as? Double != 0 {
                tablelist[1].updateValue((tablelist[1]["Fuel"] as? Double ?? 0.0)*(tablelist[1]["Liter"] as? Double ?? 0.0), forKey: "Cost")
            }else {
               tablelist[1].updateValue((tablelist[1]["Cost"] as? Double ?? 0.0)/(tablelist[1]["Liter"] as? Double ?? 0.0), forKey: "Fuel")
            
            }
        }
        if textField.tag == 8 {
            self.oilTableView.reloadData()
            tablelist[1].updateValue(NumberFormatter().number(from: textField.text?.replacingOccurrences(of: ",", with: "") ?? "0.0")?.doubleValue as Any , forKey: "Liter")
            self.oilTableView.reloadData()
            if tablelist[1]["Liter"] as? Double != 0{
                tablelist[1].updateValue((tablelist[1]["Fuel"] as? Double ?? 0.0)*(tablelist[1]["Liter"] as? Double ?? 0.0), forKey: "Cost")
            }else {
                tablelist[1].updateValue("0", forKey: "Liter")
                tablelist[1].updateValue("0", forKey: "Cost")
            }
            
        }

        
        self.oilTableView.reloadData()
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
        if textField.tag == 6 {
            tablelist[1].updateValue(0, forKey: "Cost")
            textField.text = nil
      
         
        }
        if textField.tag == 7 {
            tablelist[1].updateValue(0, forKey: "Fuel")
            textField.text = nil
       
        }
        if textField.tag == 8 {
            tablelist[1].updateValue(0, forKey: "Liter")
            textField.text = nil

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


