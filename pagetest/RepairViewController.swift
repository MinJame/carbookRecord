//
//  RepairViewController.swift
//  pagetest
//
//  Created by min on 2022/03/23.
//

import Foundation
import UIKit
import SideMenu

class RepairViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var rePairItemTableView: UITableView!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var rePairTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var selfrepairButton: UIButton!
    @IBOutlet weak var repairButton: UIButton!
    @IBOutlet weak var addCell: UIButton!
    var dateDelegate : selectDateDelegate?
    var startDate : Date?
    var finishDate : Date?
    // 전체기록에서 정비기록페이지로 돌아올때 필요한 아이디
    var celId : Int?
    // 페이지에서 삭제되는 아이디들을 모음
    var deleteIds : [Int] = []
    var tablelist : [Dictionary<String,Any>] = []
    var categorys = ["엔진오일 및 오일 필터","에어콘 필터","와이퍼 브레이드","구동벨트","미션오일","배터리","엔진부동액","우리집"]
    var repairDelegate : RepairCallbackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateDelegate = self
        initTableView()
        setNotification()
        setLists()
        setBtn()
        // 만약 celId가 있으면 getcarBookData 함수를 실행한다
        if celId != nil {
            finishButton.titleLabel?.text = "수정"
            getCarBookData()
        }
    }
    // 버튼 세팅하는 함수
    func setBtn() {
        // repairButton 두께는 1
        repairButton.layer.borderWidth = 1
        // repairButton 색은 연한 회색
        repairButton.layer.borderColor = UIColor.lightGray.cgColor
        //repairButton 모서리 굴곡 값 5
        repairButton.layer.cornerRadius = 5
        //repairButton 문자색 하얀색
        repairButton.tintColor = UIColor.white
        // selfrepairButton 두께는 1
        selfrepairButton.layer.borderWidth = 1
        // selfrePairButton 모서리 굴곡 값 5
        selfrepairButton.layer.cornerRadius = 5
        // selfrePairButton색 연한회색
        selfrepairButton.layer.borderColor = UIColor.lightGray.cgColor
        // selfrepairButton 배경 흰색
        selfrepairButton.layer.backgroundColor = UIColor.white.cgColor
        // selfrepairButton 문자색 연한 회색
        selfrepairButton.tintColor  = UIColor.lightGray
        // formatter는 DateFormatter()형식으로 저장
        let formatter = DateFormatter()
        // formatter의 달력은 그레고리언 형식
        formatter.calendar = Calendar(identifier: .gregorian)
        // formatter의 지역은 한국
        formatter.locale = Locale(identifier: "ko_KR")
        // 날짜표시를 년.월.일(요일)형식으로 선언
        formatter.dateFormat = "yyyy.MM.dd(E)"
        // finishButton을 완료로 선언 settitle ceLid 비교
        finishButton.titleLabel?.text = "완료"
        // todayDateLabel에 dateString 저장
        todayDateLabel.text = formatter.string(for: Date()) ?? ""
        
    }
    // 테이블리스트 안에 데이터 선언
    func setLists() {
        // 테이블리스트 데이터들 선언
        tablelist = [
            ["Type": 1,"Distance" :"","Mode" : 0,"isLocation": false],
            // ["Type": 2],
            // cellId 있는 경우와 없는 경우 구분
            ["Type" :3, "Category": "1", "cost" : 0 ,"memo":"","Num": 1
             ,"id": 0,"isHidden":0 ]
        ]
    }
    // 테이블뷰 기초세팅하는 함수
    func initTableView() {
        rePairItemTableView.delegate = self
        rePairItemTableView.dataSource = self
        
        rePairItemTableView.rowHeight = UITableView.automaticDimension
        // cell1은 RepairSelfTableViewCell로 선언하고
        let cell1: UINib = UINib(nibName: "RepairSelfTableViewCell", bundle: nil)
        // repairItemTableView에 cell1을 등록한다
        self.rePairItemTableView.register(cell1, forCellReuseIdentifier: "repairSelfTableViewCellID")
        // cell2는 repairsTableViewCell로 선언하고
        let cell2: UINib = UINib(nibName: "repairsTableViewCell", bundle: nil)
        //   repairItemTableView에 cell2를 등록한다
        self.rePairItemTableView.register(cell2, forCellReuseIdentifier: "repairsTableViewCelllID")
        // cell3은 repairTableViewCell로 선언하고
        let cell3: UINib = UINib(nibName: "repairTableViewCell", bundle: nil)
        // repairItemTableView에 cell3을 등록한다
        self.rePairItemTableView.register(cell3, forCellReuseIdentifier: "repairTableViewCellID")
        // repairTItemTableView 리로드 시켜준다
        rePairItemTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    // 키보드가 동작할 수 있게 notfication 및 제스쳐 설정
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    // db에 정비항목을 저장해주기 위해서 정비목록을 숫자로 변환해주는 함수
    func getRePairItemTitleCode(title : String) -> String {
        switch title {
        case "엔진오일 및 오일 필터" :
            return  "1"
        case "에어콘 필터":
            return  "2"
        case "와이퍼 브레이드":
            return  "3"
        case "구동벨트" :
            return  "4"
        case "미션오일":
            return  "5"
        case "배터리" :
            return  "6"
        case "엔진부동액":
            return  "7"
        case "우리집":
            return  "8"
        default :
           return "1"
        }
    }
    // db에서 정비목록을 불러올때 정비목록 변환해주는 함수
    func getRePairItemCodeTitle(code : String) -> String {
       
        switch code {
        case "1" :
            return "엔진오일 및 오일 필터"
        case "2":
            return"에어콘 필터"
        case "3":
            return "와이퍼 블레이드"
        case "4" :
            return "구동벨트"
        case "5":
            return  "미션오일"
        case "6" :
            return "배터리"
        case "7":
            return "엔진부동액"
        case "8":
            return "우리집"
        default :
            return "엔진오일 및 오일 필터"
        }
       
    }
    
    
    // MARK: - TextField & Keyboard Methods
    // 텍스트뷰나 텍스트 필드를 클릭한 경우에 키보드가 나타나는 함수이다
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.rePairItemTableView.contentInset
        // 키보드가 얼마나 올라옯지 정해준다
        contentInset.bottom = keyboardFrame.size.height - 60
        rePairItemTableView.contentInset = contentInset
    }
    // 키보드가 내려가는 함수이다
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        
        rePairItemTableView.contentInset = contentInset
    }
    
    @objc func dismissKeyboard() {
        
        self.view.endEditing(true)
        
    }
    // MARK: - DB에서 데이터 불러올때 사용하는 함수
    // cellId가 있을경우 db에서 데이터를 불러올때 사용하는 함수
    func getCarBookData() {
        let carBookDatabase = CARBOOK_DAO.sharedInstance
        // db에서 celId에 해당되는 데이터가 있을경우 list에 저장하고 data item 변수 저장
        if let item : [String : Any] = carBookDatabase.selectCarbookData(id: String(celId ?? 0)) {
            // 테이블리스트의  "Distance"에  데이터를 업데이트 시켜준다
            tablelist[0].updateValue(item["carbookRecordTotalDistance"] as? Double ?? 0, forKey: "Distance")
            // 테이블리스트의 "Type"에 데이터를 업데이트 시켜준다
            tablelist[0].updateValue(item["carbookRecordRepairMode"] as? Int ?? 0, forKey: "Type")
            // list의 "carbookRecordExpendDate"가 문자형일 경우 date에 저장해준다
            let date = item["carbookRecordExpendDate"] as? String ?? ""
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
            finishButton.titleLabel?.text = "수정"
            // todayDateLabel의 문자에 dateString 저장 비교해서
            todayDateLabel.text = formatter.string(for: dates) ?? ""
            // 만약 list의 "carbokRecordRepairMode"가 2일 경우
            if item["carbookRecordRepairMode"] as? Int == 2 {
                // 자가정비모드버튼을 흰색으로하고
                selfrepairButton.tintColor = UIColor.white
                // 정비소버튼을 연한회색으로 나타내고
                repairButton.tintColor  = UIColor.lightGray
                // 자가정비모드의 배경을 어두운 회색으로 하고
                selfrepairButton.layer.backgroundColor = UIColor.darkGray.cgColor
                // 정비소버튼의 배경을 흰색으로 한다
                repairButton.layer.backgroundColor = UIColor.white.cgColor
            }
            // getcarBookDatas 함수를 호출한다
            getcarBookDatas()
        }
    }
    // carBookRecordItems
    func getcarBookDatas() {
        let carBookDatabase = CARBOOK_DAO.sharedInstance
        // db에서 celId에 해당되는 데이터가 있을경우 list에 저장하고
        if let list : [Dictionary<String,Any>] = carBookDatabase.selectCarbookDataList(id: String(celId ?? 0)) {
            // 정비기록의 비어있는 첫번째 것을 제거해준다 remove 충돌소지가 있음
            tablelist.remove(at: 1)
            // list의 item값 중에서
            for item in list {
                // 불러올 정비기록들을 묶어서 저장
                let registerCarBookRecordItem : Dictionary<String,Any> = [
                    // id 값은 item의 _id이고
                    "id" : item["_id"] as? Int ?? 0,
                    // category 값은 item의 carbookRecordItemCategoryCode
                    "Category" : item["carbookRecordItemCategoryCode"] as? String ?? "",
                    // cost 값은 item의 carbookRecordItemExpenseCost
                    "cost" : item["carbookRecordItemExpenseCost"] as? Double ?? 0.0,
                    // memo는 item의 carbookRecordItemExpenseMemo
                    "memo" : item["carbookRecordItemExpenseMemo"] as? String ?? "",
                    // isHidden은 carbookRecordItemIsHidden이며
                    "isHidden" : item["carbookRecordItemIsHidden"] as? Int ?? 0,
                    // Type 값은 3이다
                    "Type" : 3
                ]
                // 테이블리스트에 불러올 정비기록들을 더해준다
                tablelist.append(registerCarBookRecordItem)
            }
            // 테이블뷰를 리로드 시켜서 불러올 항목들을 보여준다
            rePairItemTableView.reloadData()
        }
    }
    // 데이터 수정하기
    func updateData() {
        //carbookdb 불러오기
        let carBookDataBase = CARBOOK_DAO.sharedInstance
        // 테이블리스트첫번째데이터를 변수명으로 선언
        let upperDataList = tablelist[0]
        // 수정페이지에서 새로운 추가할 아이템리스트 변수로 선언
        var insertcarBookDataList : [Dictionary<String,Any>] = []
        // 수정페이지에서 수정할 아이템리스트 변수로 선언
        var updatecarBookDataList : [Dictionary<String,Any>] = []
        // 정비항목의 중복을 체크하기 위해서 String 배열 선언
        var rePairList : [String] = []
        // 수정할 날짜 적용하기 위해서 날짜 형식 포맷
        let formatter = DateFormatter()
        // 날짜 달력 형식 선언
        formatter.calendar = Calendar(identifier: .gregorian)
        // 날짜 형식의 지역 선언
        formatter.locale = Locale(identifier: "ko_KR")
        // 날짜 형식의 포맷 선언
        formatter.dateFormat = "yyyyMMddHHmmss"
        //  수정에 필요한 정비기록의 기본정보들 묶어서 저장
        let upperCarDataList : [String:Any] = [
            "carbookRecordRepairMode" : upperDataList["Type"] as? Int ?? 0,
            "carbookRecordTotalDistance" : upperDataList["Distance"] as? Double ?? 0.0,
            "carbookRecordIsHidden" : 0,
            "carbookRecordExpendDate" : formatter.string(for: startDate ?? Date()) ?? ""
        ]
        // filter를 이용해서
        // 테이블리스트의 갯수 만큼 for문 동작

        for i in 0..<tablelist.count {
            // 테이블리스트의 i번째 데이터를 carbookItem에 저장
            let carBookItem = tablelist[i]
            // carbookItem["Type"]이 인트형이면 type에 저장하고 type이 3일경우
            if let type = carBookItem["Type"] as? Int, type == 3{
                // carbookItem["category"]가 문자형일경우 category에 저장한다
                let category = carBookItem["Category"] as? String ?? ""
                // 만약 repairList에 category가 포함되어 있지 않으면 repairList에 category를 더해준다
                if !rePairList.contains(category){
                    rePairList.append(category)
                }
            }
        }
        // 만약 repairList의 갯수와 테이블리스트의 갯수가 같지 않으면
        if rePairList.count != tablelist.count-1 {
            // 동일항목은 등록불가합니다 라는 알림 창이 발생하게 한다
           
            let alert = UIAlertController(title: "동일항목", message: "등록불가합니다", preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "확인", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }else {
            // carbookdatadb에 수정한 항목들을 해당한 셀 아이디에 값에 맞게 저장해 주어야함으로 수정한 항목과 셀아이디값별로 구분해서 db저장
            let _ = carBookDataBase.modifyCarBookData(carbookData: upperCarDataList, id: String(celId ?? 0))
            //테이블리스트 갯수 만큼 for문이 돈다
            for i in 0..<tablelist.count {
                // 테이블리스트 i번째 데이터를 item이라고 선언
                let item = tablelist[i]
                // item중에 type이 Int형이고 type 값이 3이면 동작실행
                if let type = item["Type"] as? Int, type == 3 {
                    // item의 id 값을 Int형으로 선언하고 id로 저장
                    let id = item["id"] as? Int ?? 0
                    if id == 0 {     // 만약 id 값이 0이면 저장된 데이터들이 없으므로 새로운 정비기록들을 추가
                        // 새로 추가할 정비기록들을 묶어서 저장
                        let insertCarBookDatas : Dictionary<String,Any> = [
                            // 추가되는 정비기록데이터가 같은 셀에 있어야되서 cellId에 맞게 데이터 구분해서 db저장
                            "carbookRecordItemRecordId" : celId ?? 0,
                            "carbookRecordItemCategoryCode" : item["Category"] as? String ?? "",
                            "carbookRecordItemExpenseCost" : item["cost"] as? Double ?? 0.0,
                            "carbookRecordItemCategoryName" : getRePairItemCodeTitle(code: item["Category"] as? String ?? ""),
                            "carbookRecordItemExpenseMemo" : item["memo"] as? String ?? "",
                            "carbookRecordItemIsHidden" : item["isHidden"] as? Int ?? 0
                        ]
                        insertcarBookDataList.append(insertCarBookDatas)
                        
                    }else {  //만약 id 값이 0이 아니면 이미 저장된 데이터 값들이 있으므로 해당 id값에 맞춰서 정비기록를 수정해준다
                        //수정해서 업데이트할 정비기록을 묶어서 저장
                        let updateCarBookDatas : Dictionary<String,Any> = [
                            "_id" : id ,
                            "carbookRecordItemRecordId" : celId ?? 0,
                            "carbookRecordItemCategoryCode" : item["Category"] as? String ?? "",
                            "carbookRecordItemExpenseMemo" : item["memo"] as? String ?? "",
                            "carbookRecordItemExpenseCost" : item["cost"] as? Double ?? 0.0,
                            "carbookRecordItemCategoryName" : getRePairItemCodeTitle(code: item["Category"] as? String ?? ""),
                            "carbookRecordItemIsHidden" : item["isHidden"] as? Int ?? 0.0
                        ]
                        updatecarBookDataList.append(updateCarBookDatas)
                    }
                }
            }
            // 새로 추가할 정비기록 데이터들을 db에 저장
            let _ = carBookDataBase.insertCarbookItems(carbookDataItems: insertcarBookDataList)
            // 수정한 정비기록 데이터들을 db에 저장
            let _ = carBookDataBase.modifyCarBookDataItem(carbookDataItem: updatecarBookDataList)
            // 삭제한 정비기록 데이터들을 db에 저장
            let _ = carBookDataBase.deleteCarBookDataItem(deleteIds: deleteIds)
           
            self.dismiss(animated: true) {
                self.repairDelegate?.setRepairData(year: nil)
            }
        }
       
    }
    // 데이터 삽입하기
    func insertDatas(){
        //carbookdb 불러오기
        let carBookDataBase = CARBOOK_DAO.sharedInstance
        // 정비기록에서 새로운 추가할 아이템리스트 변수로 선언
        var insertcarBookDataItemList : [Dictionary<String,Any>] = []
        // 테이블리스트첫번째데이터를 변수명으로 선언
        let upperDataList = tablelist[0]
        var rePairList : [String] = []
        // 수정할 날짜 적용하기 위해서 날짜 형식 포맷
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
        // 테이블리스트의 갯수 만큼 for문 동작
        for i in 0..<tablelist.count {
            // 테이블리스트의 i번째 데이터를 carbookItem에 저장
            let carBookItem = tablelist[i]
            // carbookItem["Type"]이 인트형이면 type에 저장하고 type이 3일경우
            if let type = carBookItem["Type"] as? Int, type == 3{
                // carbookItem["category"]가 문자형일경우 category에 저장한다
                let category = carBookItem["Category"] as? String ?? ""
                // 만약 repairList에 category가 포함되어 있지 않으면 repairList에 category를 더해준다
                if !rePairList.contains(category){
                    rePairList.append(category)
                }
            }
        }
        // 만약 repairList의 갯수와 테이블리스트의 갯수가 같지 않으면
        if rePairList.count != tablelist.count-1 {
            // 동일항목은 등록불가합니다 라는 알림 창이 발생하게 한다
            let alert = UIAlertController(title: "동일항목", message: "등록불가합니다", preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "확인", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }else{
            // repairList의 갯수와 테이블리스트의 갯수가 같을 경우
            let insertCarBookdata = carBookDataBase.insertCarbookData(carbookData: carBookData)
            //테이블 리스트 갯수 만큼 for문 동작한다
            for i in 0..<tablelist.count {
                // 새로 생성할 정비기록항목들은 위에서 생성한 데이터의 id값과 동일한 곳에 들어가야하고 id값은 Int형임으로 Int형으로 선언
                if let id = insertCarBookdata["id"] as? Int {
                    // 테이블리스트 i번째 데이터를 item이라고 선언
                    let item = tablelist[i]
                    // item중에 type이 Int형이고 type 값이 3이면 동작실행
                    if let type = item["Type"] as? Int, type == 3 {
                        // 새로 추가할 정비기록항목들을 묶어서 저장
                        let insertCarBookRecordItem : Dictionary<String,Any> = [
                            "carbookRecordItemRecordId" : id,
                            "carbookRecordItemCategoryCode" : item["Category"] as? String ?? "",
                            "carbookRecordItemCategoryName" : getRePairItemCodeTitle(code: item["Category"] as? String ?? ""),
                            "carbookRecordItemExpenseMemo" : item["memo"] as? String ?? "",
                            "carbookRecordItemExpenseCost" : item["cost"] as? Double ?? 0.0,
                            "carbookRecordItemIsHidden" : item["isHidden"] as? Int ?? 0
                        ]
                        // insertcarBookDataItemList에 insertCarBookRecordItem를 더해준다
                        insertcarBookDataItemList.append(insertCarBookRecordItem)
                    }
                }
            }
            // 정비항목들을 db에 저장한다
            _ = carBookDataBase.insertCarbookItems(carbookDataItems: insertcarBookDataItemList)
            // 동작 후 메인 페이지로 이동
            self.dismiss(animated: true){
                self.repairDelegate?.setRepairData(year: nil)
            }
        }
        
    }
    // 정비한 기록들을 저장하기 위한 버튼
    @IBAction func saveDataButton(_ sender: Any) {
        // 전체기록 페이지에서 정비기록을 클릭후 정비기록 페이지 들어온 경우와 정비기록 페이지로 들어와서 데이터 저장하는 것을 구분하기 위한 if문
        if celId != nil {
            updateData()
        }  else {
            insertDatas()
        }
    }
    // 정비모드 수정하는 버든
    @IBAction func selectrepairBtn(_ sender: UIButton) {
        //정비항목이 정비소에서 했을경우
        if  sender.tag == 0 {
            // 테이블리스트의 첫번째 데이터 모음의 Type 값을 1로 업데이트 시켜준다
            tablelist[0].updateValue(1, forKey: "Type")
            // 테이블뷰의 열을 다시한번 불러준다
            rePairItemTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            // 정비소버튼을 색을 흰색으로
            repairButton.tintColor = UIColor.white
            // 자가정비 버튼을 색을 연한 회색으로
            selfrepairButton.tintColor  = UIColor.lightGray
            // 정비소 버튼의 배경색을 진한 회색으로
            repairButton.layer.backgroundColor = UIColor.darkGray.cgColor
            // 자가정비 버튼의 배경색을 흰색으로 한다
            selfrepairButton.layer.backgroundColor = UIColor.white.cgColor
            
        }
        // 정비항목을 자가정비로 했을 경우
        else if sender.tag == 1 {
            // 테이블리스트의 첫번째 데이터 모음의 Type값을 2로 업데이트 시켜준다
            tablelist[0].updateValue(2, forKey: "Type")
            // 테이블뷰의 열을 다시한번 불러준다
            rePairItemTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            // 자가정비 버튼을 흰색으로
            selfrepairButton.tintColor = UIColor.white
            // 정비소 버튼을 연한 회색으로
            repairButton.tintColor  = UIColor.lightGray
            // 자가정비 버튼의 배경색을 진한 회색으로
            selfrepairButton.layer.backgroundColor = UIColor.darkGray.cgColor
            // 정비소 버튼의 배경색을 흰색으로 한다
            repairButton.layer.backgroundColor = UIColor.white.cgColor
        }
        
    }
    //뷰를 지우는 함수
    @IBAction func moveView(_ sender: Any) {
        dismiss(animated: true)
        
    }
    // 정비항목을 추가해주는 함수
    @IBAction func addCells(_ sender: Any) {
        //버튼을 누를시 정비항목을 추가할때 필요한 데이터들만 테이블리스트에 합해준다
        // 테이블리스트의 갯수가 10개보다 같거나 작을 경우
        if tablelist.count <= 10 {
            // 테이블 리스트에 데이터를 추가해준다
            tablelist.append(["Type" :3, "Category": "1", "cost" : 0 ,"memo":"메모 250자 기입가능\n(이모티콘 불가)"])
            rePairItemTableView.insertRows(at: [IndexPath(row: tablelist.count-1, section: 0)], with: .automatic)
            let indexPath = IndexPath(row: tablelist.count-1, section: 0)
            // 셀을 추가해줄 경우 추가한 셀로 스크롤이 올라갈수 있게 동작하는 함수 입니다.
            rePairItemTableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated:true)
        }else {
            // 알렛뷰의 제목과 메세지들을 생성해준다
            let alert = UIAlertController(title: "정비 기록은", message: "최대 10개까지만 입력가능합니다.", preferredStyle: UIAlertController.Style.alert)
            // 알림창에 뷰를 지울수 있는 버튼 내용 생성
            let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel)
            alert.addAction(cancel) // 알림창에 버튼추가
            // 버튼이 나타나는 동작 구현
            self.present(alert,animated: false)
        }
      
    }
    // 날짜를 선택하는 함수
    @IBAction func selectDays(_ sender: Any) {
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
    // 버튼을 클릭시 정비항목을 삭제헤주는 함수
    @IBAction func deleteCells(_ sender: UIButton) {
        // 만약 테이블리스트가 2개 이하일경우
        if tablelist.count <= 2 {
            // 알렛뷰의 제목과 메세지들을 생성해준다
            let alert = UIAlertController(title: "정비 기록", message: "최소 1개의 항목은 입력하셔야 합니다.", preferredStyle: UIAlertController.Style.alert)
            // 알림창에 뷰를 지울수 있는 버튼 내용 생성
            let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel)
            alert.addAction(cancel) // 알림창에 버튼추가
            // 버튼이 나타나는 동작 구현
            self.present(alert,animated: false)
        }else {// 테이블리스트가 2개보다 많을 경우
            // 삭제가 마지막 정비기록부터 됨으로써 필요한 id값을 알기위해서 테이블리스트 마지막 데이터들 가져옴
            let item = tablelist.last
            // 마지막 테이블리스트 id값이 Int형이므로 Int형으로 선언후 deleteId에 저장
            let deleteId = item?["id"] as? Int ?? 0
            // 만약 delelteId가 0이 아닐경우
            if deleteId != 0 {
                // Int배열로 선언한 deleteIds에 deleteId를 합쳐서 저장해준다
                deleteIds.append(deleteId)
            }
            // 테이블리스트에서 테이블리스트수에서 1을 뺀 값에서 제거 시켜준다
            tablelist.remove(at: tablelist.count-1)
            //테이블리스트행에서 지워준다
            rePairItemTableView.deleteRows(at: [IndexPath(row: tablelist.count, section: 0)], with: .automatic)
        }
    }
    
}
// MARK: - TableView Delegate,DataSource 선언
extension RepairViewController: UITableViewDelegate {
}

extension RepairViewController: UITableViewDataSource {
    // 테이블뷰의 열의 갯수 선언
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablelist.count
    }
    // 테이블뷰 cell안에서 동작할 것들 선언
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 테이블리스트의 row들의 데이터를 item으로 선언
        let item = tablelist[indexPath.row]
        // item의 "Type"을 타입으로 선언
        let type = item["Type"] as? Int ?? 0
        // 타입에 따라 다르게 셀 사용
        switch type   {
        case 1 :
            // 만약 타입이 1일 경우 repairsTableViewCell을 재사용한다
            if let cell = rePairItemTableView.dequeueReusableCell(withIdentifier: "repairsTableViewCelllID") as?
                repairsTableViewCell {
                // 셀의 noLacteBtn를 누를경우 changereFilButton 함수 동작
                cell.noLocateBtn.addTarget(self, action:#selector(changereFilButton(_ :)), for: .touchUpInside)
                // 만약 테이블리스트 첫번째의 islocation이 bool형이면 islocation에 저장
                if let isLocation = tablelist[0]["isLocation"] as? Bool{
                    //rePairLocationView 히든 처리
                    cell.rePairLocationView.isHidden = isLocation
                    cell.rePairShopView.isHidden = isLocation
                    cell.addRepairShopView.isHidden = !isLocation
                }
                // driveDistance가 텍스트 필드여서 텍스트 필드 delegate 적용
                cell.driveDistance.delegate = self
                // driveDistance의 문자는 테이블리스트의["Distance"]값으로 할려고하는데 더블형임으로 문자형으로 변환해서 보여준다
                cell.driveDistance.text = String(format: "%.f", tablelist[0]["Distance"] as? Double ?? 0.0)
                return cell
            } else {
                let cell = rePairItemTableView.dequeueReusableCell(withIdentifier: "repairSelfTableViewCellID")
                return cell!
            }
        case 2 :
            // 타입이 2인경우 RepairSelfTableViewCell을 재사용한다
            if let cell = rePairItemTableView.dequeueReusableCell(withIdentifier: "repairSelfTableViewCellID") as?
                RepairSelfTableViewCell {
                // distanceField가 텍스트 필드임으로 텍스트필드 delegate 적용
                cell.distanceField.delegate = self
                // distanceField의 문자는 테이블리스트의["Distance"]값인데 더블형임으로 문자형으로 변환해서 보여준다
                cell.distanceField.text = String(format: "%.f", tablelist[0]["Distance"] as? Double ?? 0.0)
                return cell
            }else {
                let cell = rePairItemTableView.dequeueReusableCell(withIdentifier: "repairSelfTableViewCellID")
                return cell!
            }
        case 3 :
            // 타입이 3인경우 repairTableViewCell을 재사용한다
            if let cell = rePairItemTableView.dequeueReusableCell(withIdentifier: "repairTableViewCellID") as?
                repairTableViewCell {
                // 메모뷰가 텍스트 뷰 형식이여서 텍스트뷰 delegate 적용
                cell.repairMemoView.delegate = self
                // 비용 입력하는 텍스트가   텍스트필드 delegate 적용
                cell.repairCostField.delegate = self
                // 정비목록있는 창을 pickerview 형식으로 구성했으며  pickerview사용을 위해 delegate 적용
                cell.pickers.delegate = self
                cell.repairMemoView.tag = indexPath.row
                cell.repairCostField.tag = indexPath.row
                cell.rePairItems.tag = indexPath.row
                cell.pickers.tag = indexPath.row
                // 셀의 정비목록을 초기값을 코드에서 문자형으로 변환해서 나타낸다
                cell.rePairItems.text = getRePairItemCodeTitle(code: item["Category"] as? String ?? "")
                // 정비목록 번호를 알려준다
                cell.rePairNums.text = String(indexPath.row)
                //  repaircostfield의 placeholder(초기에 아무것도 입력안했을때 보여지는 것) 값을 0으로 지정
                cell.repairCostField.placeholder = "0"
                // 아이템의 "cost" 값을 costs로 선언한다
                let costs = item["cost"] as? Double ?? 0.0
                // repaircostfield의 문자를 문자열로 변환한 cost값 입력
                cell.repairCostField.text = String(Int(costs))
                // repaircostfield의 문자색을 연한갈색으로 선언
                cell.repairCostField.textColor = .lightGray
                // 만약 item의 "memo"가 문자열이면 memo에 저장하고, memo에 문자열이 있으면 repairMemoView의 문자에 memo를 입력한다.
                if let memo = item["memo"] as? String, memo != "" {
                    cell.repairMemoView.text = memo
                    
                }
                return cell
            }else {
                let cell = rePairItemTableView.dequeueReusableCell(withIdentifier: "repairTableViewCellID")
                return cell!
            }
        default :
            let cell = rePairItemTableView.dequeueReusableCell(withIdentifier: "repairTableViewCellID")
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//  정비소에서 장소없음을 누를경우 동작하는 함수
    @objc func changereFilButton(_ sender: UIButton) {
        // 만약 테이블리스트 첫번째의 islocation이 bool형이면 islocation에 저장
        if let isLocation = tablelist[0]["isLocation"] as? Bool {
            //그리고 테이블리스트에 islocation값의 반대되는 값을 저장한다
            tablelist[0].updateValue(!isLocation , forKey: "isLocation")
        }
        // 그후 테이블뷰를 다시불러온다
        self.rePairItemTableView.reloadData()
        
    }
    // 테이블뷰의 열의 높이를 지정해준다
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
        default :
            return 200.0
        }
    }
    
}
// 달력선택 delegate
extension RepairViewController : selectDateDelegate {
    func dateCalendarDismissCallBack() {
    }
    
    // 날짜 선택 함수 동작
    func selectDate(date: Date, tag: Int) {
        //  DateFormatter을 format에 저장
        let format = DateFormatter()
        // format의 달력 형식을 그레고리언 형식의 달력으로 저장
        format.calendar = Calendar(identifier: .gregorian)
        // format의 지역을 한국으로 저장
        format.locale = Locale(identifier: "ko_KR")

        // format의 날짜 표기 형식을 "년.월.일(요일)"로 저장
        format.dateFormat = "yyyy.MM.dd(E)"

        if tag == 0 {
            startDate = date
            finishDate = nil
            // 오늘 날짜의 문자를 선택한 날짜로 저장
            todayDateLabel.text = format.string(for: date) ?? ""
        }else {
            finishDate = date
            todayDateLabel.text = format.string(for: date) ?? ""
        }
        
    }
}
// MARK: - TextView,TextField 사용을 위한 Delegate 선언
extension RepairViewController : UITextViewDelegate,UITextFieldDelegate {
    // 텍스트뷰 입력이 끝날때 동작하는 함수
    func textViewDidEndEditing(_ textView: UITextView) {
        // 만약 텍스트뷰의 문자가 비어 있으면
        if textView.text.isEmpty {
            // 텍스트뷰의 문자를 "메모 250자 기입가능\n(이모티콘 불가)"로 입력해준다
            textView.text = "메모 250자 기입가능\n(이모티콘 불가)"
            // 텍스트뷰의 문자색을 연한 갈색으로 정한다
            textView.textColor = UIColor.lightGray
            tablelist[textView.tag].updateValue("", forKey: "memo")
        }else {
            // 만약 텍스트 뷰가 비어 있지 않다면 텍스트뷰의 데이터를 memo에 저장한다
            tablelist[textView.tag].updateValue(textView.text ?? "", forKey: "memo")
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
        }else{
            // 텍스트 필드의 태그 값이 0이 아닌경우 지출비용이므로  더블형으로 변환시켜서 테이블리스트의 "cost"에 업데이트 시킨다
            tablelist[textField.tag].updateValue(NumberFormatter().number(from: textField.text?.replacingOccurrences(of: ",", with: "") ?? "0.0")?.doubleValue as Any, forKey: "cost")
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
// MARK: - PickerView 사용을 위한 Delegate,DataSource 선언
extension RepairViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // 피커뷰의 구성요소를 1개로 선언하는 함수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // 피커뷰의 열의 아이템목록을 카테고리의 열의 있는 것으로 선언하는 함수
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorys[row]
    }
    // 피커뷰의 열의 갯수를 카테고리의 열의 갯수를 선언하는 함수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorys.count
        
    }
    // 피커뷰에서 항목을 선택할때 동작하는 함수
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 선택한 피커뷰의 항목을 코드로 변환해서 테이블뷰의 "category"에 저장한다
        tablelist[pickerView.tag].updateValue(getRePairItemTitleCode(title: categorys[row]) , forKey: "Category")
    }
    
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}





