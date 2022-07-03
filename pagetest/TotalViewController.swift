//
//  TotalViewController.swift
//  pagetest
//
//  Created by min on 2022/04/13.
//

import Foundation
import UIKit

protocol RepairCallbackDelegate{
    func setRepairData(year : String?)
}
struct dates {
    let year: String
    let month: [String]
}
class TotalViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchRecordBtn: UIButton!
    @IBOutlet weak var selectMonthBtn: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var totalTableView: UITableView!
    @IBOutlet weak var yearTotalDistanceLabel: UILabel!
    @IBOutlet weak var yearTotalExpenseCostLabel: UILabel!
    var searchDates : [dates] = []
    var selectDate : (yearRow : Int, monthRow: Int) = (0,0)
    var carDataList : [Dictionary<String,Any>] = []
    var delegate : RepairCallbackDelegate?
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        // 피커뷰 동작 할수 있게 함수 선언
        selectMonthView()
        initTableView()
        setCarbookDateList()
    }
    // 테이블뷰 기본 세팅
    func initTableView() {
        totalTableView.delegate = self
        totalTableView.dataSource = self
        totalTableView.rowHeight = UITableView.automaticDimension
        let cell1: UINib = UINib(nibName: "TotalTableViewCell", bundle: nil)
        self.totalTableView.register(cell1, forCellReuseIdentifier: "TotalTableViewCellID")
        let cell2: UINib = UINib(nibName: "OilMonthTotalTableViewCell", bundle: nil)
        self.totalTableView.register(cell2, forHeaderFooterViewReuseIdentifier: "OilMonthTotalTableViewCellID")
        let cell3: UINib = UINib(nibName: "rePairListTableViewCell", bundle: nil)
        self.totalTableView.register(cell3, forCellReuseIdentifier: "rePairListTableViewCellID")
        self.totalTableView.sectionHeaderTopPadding = 0.0
        totalTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
    }
    // db에서 정비목록을 불러올때 정비목록 변환해주는 함수
    func getCodeText(Code : String) -> String {
        switch Code {
        case "1" :
            return "엔진오일 및 오일 필터"
        case "2":
            return "에어콘 필터"
        case "3":
            return "와이퍼 블레이드"
        case "4" :
            return "구동벨트"
        case "5":
            return "미션오일"
        case "6" :
            return "배터리"
        case "7":
            return "엔진부동액"
        case "8":
            return"우리집"
        default :
            return "엔진오일 및 오일 필터"
        }
    }
    
    // 뷰 상단에 년도 클릭시 피커뷰를 호출한후 선택한 달로 이동할 수 있게 한다
    func selectMonthView(){
        yearField.tintColor = .clear
        // 피커뷰를 생성
        pickerView.delegate = self
        pickerView.dataSource = self
        //피커뷰에 추가될 툴바를 생성
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // toolbar에 적용버튼 추가
        let acceptButton =  UIBarButtonItem(title: "적용", style: .done, target: self, action: #selector(onPickDone))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // toolbar에 취소버튼 추가
        let cancelButton = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(onPickCancel))
        toolbar.setItems([flexibleSpace,cancelButton,acceptButton], animated: false)
        //년도 버튼 클릭시 피커뷰가 나타나게한다
        yearField.inputView = pickerView
        //피커뷰가 나타날때에 피커뷰 상단에 툴바를 추가합니다.
        yearField.inputAccessoryView = toolbar
        toolbar.isUserInteractionEnabled = true
        pickerView.endEditing(true)
    }
    
    // 피커뷰 적용 버튼 클릭 동작함수
    @objc func onPickDone() {
        yearField.resignFirstResponder()
        yearField.text = searchDates[selectDate.yearRow].year + "년"
        setRepairData(year: searchDates[selectDate.yearRow].year)
        
        let indexPath = IndexPath(row: 0, section: selectDate.monthRow)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            self.totalTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    // 피커뷰 취소 버튼 클릭시 동작함수
    @objc func onPickCancel() {
        /// 피커뷰 내린다
        yearField.resignFirstResponder()
    }
    //    // db에서 데이터를 전부 가져오는 함수
    func setCarbookDateList(){
        let carbookDataBase = CARBOOK_DAO.sharedInstance
        if let list : [Dictionary<String,Any>] = carbookDataBase.selectRangeCarBookDataList() {
            let groupRawData = Dictionary(grouping: list){$0["year"] as? String ?? ""}
            for (key,value) in groupRawData {
                let months = value.map { (dic) -> String in
                    return dic["month"] as? String ?? ""
                }
                searchDates.append(dates(year: key, month: months))
            }
            searchDates = searchDates.sorted{$0.year > $1.year}
        }
        yearField.text = (searchDates.first?.year ?? "") + "년" 
        setRepairData(year: searchDates.first?.year)
    }
    
    // db에서 데이터를 년도 별로 가져오는 함수
    func setCarbookDataList(year : String?) {
        let carbookDataBase = CARBOOK_DAO.sharedInstance
        if let list : [Dictionary<String,Any>] = carbookDataBase.selectRangeyearCarBookDataList(year: year) {
            //저장에 필요한 변수들 선언
            var totalCost : Double = 0.0
            var totalDistance : Double = 0.0
            var date : String = ""
            //db에 있는 데이터들을 월별로 묶는다
            let groupRawData = Dictionary(grouping: list){$0["date"] as? String ?? ""}
            for (key,value) in groupRawData {
                var monthCost : Double = 0.0
                var monthDistance : Double = 0.0
                date = key
                for item in value {
                    // totalCost에 grouprawdata의 value값의 i번째["TotalCost"]의 값을 더해준다
                    totalCost += item["TotalCost"] as? Double ?? 0.0
                    // totalDistance에 grouprawdata의 value값의 i번째["carbookRecordTotalDistance"]의 값을 더해준다
                    totalDistance += item["carbookRecordTotalDistance"] as? Double ?? 0.0
                    monthCost += item["TotalCost"] as? Double ?? 0.0
                    monthDistance += item["carbookRecordTotalDistance"] as? Double ?? 0.0
                }
                
                let carbookdata :Dictionary<String,Any>  = [
                    //날짜는 grouprawdata의 key 값
                    "date" : date ,
                    "monthDistance"  : monthDistance,
                    "monthCost" : monthCost,
                    "items": value
                ]
                
                // cardataList에 carbookdata들을 더해준다
                carDataList.append(carbookdata)
                
            }
            // yearTotalExpenseCostLabel에 monthCost 적용
            yearTotalExpenseCostLabel.text = String(format: "%.f",totalCost)
            // yearTotalDistanceLabel에 monthDistance 적용
            yearTotalDistanceLabel.text = String(format: "%.f",totalDistance)
            // 저장된 데이터들을 월별로 내림차순으로 정리한다
            carDataList = carDataList.sorted {$0["date"] as? String ?? "" > $1["date"] as? String ?? ""}
        }
        
        Swift.print("carDataList\(carDataList)")
    }
    // 이전 페이지로 이동하는 함수
    @IBAction func dismissView(_ sender: Any) {
        // 생성된 뷰를 지워준다
        dismiss(animated: true)
    }
}
//  totalViewController안의 테이블뷰의 delegate 선언
extension TotalViewController: UITableViewDelegate {
    
}
//  totalViewController안의 테이블뷰의 datasource들 선언
extension TotalViewController: UITableViewDataSource {
    // 테이블뷰 섹션 갯수 선언
    func numberOfSections(in tableView: UITableView) -> Int {
        return carDataList.count
    }
    // 테이블뷰 헤더 섹션의 높이 선언
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    // 테이블뷰 헤더뷰의 데이터들 선언
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 헤더뷰로 재사용할 셀을 선언
        let headerView = totalTableView.dequeueReusableHeaderFooterView(withIdentifier: "OilMonthTotalTableViewCellID") as?
        OilMonthTotalTableViewCell
        // cardatalist에서 "date"값을 dates에 저장
        let dates = carDataList[section]["date"] as? String ?? ""
        // dates중 월만 표시함으로  앞에 년도는 제거하고 date에 저장
        let date = String(dates.dropFirst(4))
        //헤더뷰의 monthlabel에 date값 저장
        headerView?.monthLabel.text = date
        // 헤더뷰의 totalDisacneLabel에 cardatalist[section]에["totalDistance"]값이 더블형인데 스트링형으로 변환해서 보여준다
        headerView?.totalDistacneLabel.text = String(format: "%.f",carDataList[section]["monthDistance"] as? Double ?? "")
        //헤더뷰의 totalCostLabel에 cardatalist[section]에["totalCost"]값이 더블형인데 스트링형으로 변환해서 보여준다
        headerView?.totalCostLabel.text = String(format: "%.f",carDataList[section]["monthCost"] as? Double ?? "")
        return headerView
    }
    //  열을 눌렀을때 동작하는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath : IndexPath) {
        // 만약 carDataList["items"]값이 있으면 items에 저장
        if let items = carDataList[indexPath.section]["items"] as? [Dictionary<String,Any>] {
            Swift.print("items\(items)")
            // item는 items의 indexPath.row열의 데이터
            let item = items[indexPath.row]
            // id는 item안의 carbookRecordId 값
            Swift.print("items\(item)")
            let id = item["carbookRecordId"] as? Int ?? 0
            let types = item["carbookRecordType"] as? String
            
            if types == "정비" {
                
                // 해당열을 눌렀을때에 "RepairViewController"로 이동
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepairViewController")
                    as? RepairViewController  {
                    vc.modalTransitionStyle = .coverVertical
                    vc.modalPresentationStyle = .fullScreen
                    // 이동하는데 totalviewcontroller에서 선택한 열의 아이디 값
                    vc.celId = id
                    // totalviewcontroller에서 선언해준 delegate 값을 전달해준다
                    vc.repairDelegate = delegate
                    self.present(vc, animated: true, completion: nil)
                }
            }else {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OilEditsViewController")
                    as? OilEditsViewController  {
                    vc.modalTransitionStyle = .coverVertical
                    vc.modalPresentationStyle = .fullScreen
                    // 이동하는데 totalviewcontroller에서 선택한 열의 아이디 값
                    vc.cellId = id
                    // totalviewcontroller에서 선언해준 delegate 값을 전달해준다
                    vc.repairDelegate = delegate
                    self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    }
    
    // 테이블뷰의 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = carDataList[section]["items"] as? [Dictionary<String,Any>] ?? []
        return items.count
    }
    // 테이블뷰 셀안에 들어갈 것들 선언
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : rePairListTableViewCell  = totalTableView.dequeueReusableCell(withIdentifier: "rePairListTableViewCellID", for: indexPath) as! rePairListTableViewCell
        let items = carDataList[indexPath.section]["items"] as? [Dictionary<String,Any>] ?? []
        let item = items[indexPath.row] as? Dictionary<String,Any> ?? [:]
        let types = item["carbookRecordType"] as? String ?? ""
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = formatter.date(from : item["carbookRecordExpendDate"] as? String ?? "")
        formatter.dateFormat = "MM.dd"
        
        cell.rePairDateLabel.text = formatter.string(for: dateString) ?? ""
      
        if types == "정비"{
        cell.totalDistanceLabel.text = String(format: "%.f", item["carbookRecordTotalDistance"] as? Double ?? 0.0)
        cell.rePairExpenseCost.text = String(format: "%.f", item["TotalCost"] as? Double ?? 0.0)
        // memoView를 숨겨준다
        cell.memoView.isHidden = true
        //cell의 ID값을 버튼의 태그 값에 저장을 합니다
        cell.changeItemButton.tag = item["carbookRecordId"] as? Int ?? 0
        //cell의 버튼의 액션을 할 수 있게 추가해줍니다.
        cell.changeItemButton.addTarget(self, action: #selector(changeItem(_:)), for: .touchUpInside)
        // 만약 item의 carbookRecordItemCategoryCode의 문자형이면 categoryName에 저장하고
        if let categoryName = item["carbookRecordItemCategoryCode"] as? String {
            // 아이템의 "COUNT"를 items로 저장
            let items = item["COUNT"] as? Int ?? 0
            // 만약 items가 2보다 크거나 같으면
            if items >= 2{
                // repairItemTitleLabel는 categoryName을 정비목록으로 바꾸고 추가로 정비목록 갯수를 뺀 것의 숫자를 표기
                cell.rePairItemTitleLabel.text = getCodeText(Code: categoryName) + (" 외 \((item["COUNT"] as? Int ?? 1)-1)건")
            }else{
                // 2보다 작을 경우 하나의 항목만 보여준다
                cell.rePairItemTitleLabel.text = getCodeText(Code: categoryName)
            }
        }
        // 만약 item의 carbookRecordItemExpenseMemo가 문자형이면 memoText에 저장하고
        if let memoText = item["carbookRecordItemExpenseMemo"] as? String  {
            // 만약 memoText 값이 있으면
            if memoText != "" {
                // memoView를 숨기지 않고 memoText값을 memoTextView에 넣어준다
                cell.memoView.isHidden = false
                cell.memoTextView.text = memoText
            }
        }
        // 만약 item의 "categoryCodes"가 문자형이고,item의 "categoryCodesCost"가 문자형이면
        if let categoryCodes = item["categoryCodes"] as? String, let categoryCodesCost = item["categoryCodesCost"] as? String{
            // 정비항목 코드를,를 이용해 분리해서 codeList에 저장한다
            let codeList = categoryCodes.components(separatedBy: ",")
            // 정비항목비용코드를,를 이용해 분리해서 costList에 저장한다
            let costList = categoryCodesCost.components(separatedBy: ",")
            // 만약 codeList와 costList의 수가 1보다 크면
            if codeList.count > 1, costList.count > 1 {
                cell.rePairItmeStackView.removeAllArrangedSubviews()
                //repairItemListView를 숨기지않는다
                cell.rePairItemListView.isHidden = false
                // 코드리스트의 갯수만큼 for문 동작
                for (index,value) in codeList.enumerated() {
                    // UIView의 높이를 30으로 지정하고 폭은 repairitemListview의 폭으로 줘서 itemView에 저장한다
                    let itemView = UIView(frame: CGRect(x: 0, y: 0, width: cell.rePairItemListView.frame.width, height: 30))
                    // titleLabel의 값을 폭은 100 높이는 30으로 지정해서 저장한다
                    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
                    // valueLabel의 값을 폭은 100 높이는 30으로 지정해서 저장한다
                    let valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
                    itemView.translatesAutoresizingMaskIntoConstraints = false
                    titleLabel.translatesAutoresizingMaskIntoConstraints = false
                    valueLabel.translatesAutoresizingMaskIntoConstraints = false
                    // titleLabel의 텍스트는 value 정비항목 코드를 변환해서 보여준다
                    titleLabel.text = getCodeText(Code: value)
                    // valueLabel은 costList의 값을 index순서에 맞게 보여준다
                    valueLabel.text =  "₩ \((Double(costList[index]) ?? 0.0).clean)"
                    // titleLabel 폰트 사이즈를 지정해준다
                    titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                    // valueLabel 폰트 사이즈를 지정해준다
                    valueLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                    // valueLabel의 문자 위치를 지정해준다
                    valueLabel.textAlignment = .right
                    // titleLabel의 문자 색을 지정해준다
                    titleLabel.textColor = .lightGray
                    // valueLabel의 문자 색을 지정해준다
                    valueLabel.textColor = .darkGray
                    // 아이템 뷰에 titleLabel을 추가해준다
                    itemView.addSubview(titleLabel)
                    // 아이템 뷰에 valueLabel을 추가해준다
                    itemView.addSubview(valueLabel)
                    //titleLabel leading값을 지정해준다
                    titleLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 10).isActive = true
                    //titleLabel width값의 간격을 지정해준다
                    titleLabel.widthAnchor.constraint(equalTo: itemView.widthAnchor, multiplier: 0.5).isActive = true
                    titleLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor, constant: 0).isActive = true
                    //valueLabel trailing값의 간격을 지정해준다
                    valueLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -10).isActive = true
                    //valueLabel width값의 간격을 지정해준다
                    valueLabel.widthAnchor.constraint(equalTo: itemView.widthAnchor, multiplier: 0.5).isActive = true
                    valueLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor, constant: 0).isActive = true
                    // repairItemStackView에 itemview를 추가해준다
                    cell.rePairItmeStackView.addArrangedSubview(itemView)
                    // itemView의 width값을 지정해준다
                    itemView.widthAnchor.constraint(equalTo: cell.rePairItmeStackView.widthAnchor, constant: 0).isActive = true
                    // itemView의 높이값을 지정해준다
                    itemView.heightAnchor.constraint(equalToConstant: 30).isActive = true
                }
            }else {
                // 1보다 작을 경우 rePairItemListView를 숨긴다
                cell.rePairItemListView.isHidden = true
            }
        }
        } else {
            cell.fuelStatusLabel.isHidden  = false ㄴ
            cell.fuelCostLabel.isHidden = false
            cell.totalDistanceLabel.text = String(format: "%.f", item["carbookRecordTotalDistance"] as? Double ?? 0.0)
            cell.rePairExpenseCost.text = String(format: "%.f", item["carbookRecordOilItemExpenseCost"] as? Double ?? 0.0)
            // memoView를 숨겨준다
            cell.memoView.isHidden = true
            //cell의 ID값을 버튼의 태그 값에 저장을 합니다
            cell.changeItemButton.tag = item["carbookRecordId"] as? Int ?? 0
            //cell의 버튼의 액션을 할 수 있게 추가해줍니다.
            cell.changeItemButton.addTarget(self, action: #selector(changeItem(_:)), for: .touchUpInside)
            cell.rePairItemTitleLabel.text = "주유"
            cell.rePairLocationLabel.text = "동일주유소"
            cell.rePairItemListView.isHidden =  true
            
            // 만약 item의 carbookRecordItemExpenseMemo가 문자형이면 memoText에 저장하고
            if let memoText = item["carbookRecordItemExpenseMemo"] as? String  {
                // 만약 memoText 값이 있으면
                if memoText != "" {
                    // memoView를 숨기지 않고 memoText값을 memoTextView에 넣어준다
                    cell.memoView.isHidden = false
                    cell.memoTextView.text = memoText
                }
            }
            
            // 만약 item의 "categoryCodes"가 문자형이고,item의 "categoryCodesCost"가 문자형이면
            if let washCosts = item["carbookRecordWashCost"] as? Double  {
                // 정비항목 코드를,를 이용해 분리해서 codeList에 저장한다
                // 만약 codeList와 costList의 수가 1보다 크면
                if washCosts != 0.0 {
                    cell.rePairItmeStackView.removeAllArrangedSubviews()
                    //repairItemListView를 숨기지않는다
                    cell.rePairItemListView.isHidden = false
                    let itemView = UIView(frame: CGRect(x: 0, y: 0, width: cell.rePairItemListView.frame.width, height: 30))
                    // titleLabel의 값을 폭은 100 높이는 30으로 지정해서 저장한다
                    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
                    // valueLabel의 값을 폭은 100 높이는 30으로 지정해서 저장한다
                    let valueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
                    itemView.translatesAutoresizingMaskIntoConstraints = false
                    titleLabel.translatesAutoresizingMaskIntoConstraints = false
                    valueLabel.translatesAutoresizingMaskIntoConstraints = false
                    
                    titleLabel.text = "세차비"
                    // valueLabel은 costList의 값을 index순서에 맞게 보여준다
                    valueLabel.text = "₩" + String(format: "%.f", item["carbookRecordWashCost"] as? Double ?? 0.0)
                    titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                    // valueLabel 폰트 사이즈를 지정해준다
                    valueLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
                    // valueLabel의 문자 위치를 지정해준다
                    valueLabel.textAlignment = .right
                    // titleLabel의 문자 색을 지정해준다
                    titleLabel.textColor = .lightGray
                    // valueLabel의 문자 색을 지정해준다
                    valueLabel.textColor = .darkGray
                    // 아이템 뷰에 titleLabel을 추가해준다
                    itemView.addSubview(titleLabel)
                    // 아이템 뷰에 valueLabel을 추가해준다
                    itemView.addSubview(valueLabel)
                    //titleLabel leading값을 지정해준다
                    titleLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 10).isActive = true
                    //titleLabel width값의 간격을 지정해준다
                    titleLabel.widthAnchor.constraint(equalTo: itemView.widthAnchor, multiplier: 0.5).isActive = true
                    titleLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor, constant: 0).isActive = true
                    //valueLabel trailing값의 간격을 지정해준다
                    valueLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -10).isActive = true
                    //valueLabel width값의 간격을 지정해준다
                    valueLabel.widthAnchor.constraint(equalTo: itemView.widthAnchor, multiplier: 0.5).isActive = true
                    valueLabel.centerYAnchor.constraint(equalTo: itemView.centerYAnchor, constant: 0).isActive = true
                    cell.rePairItmeStackView.addArrangedSubview(itemView)
                    // itemView의 width값을 지정해준다
                    itemView.widthAnchor.constraint(equalTo: cell.rePairItmeStackView.widthAnchor, constant: 0).isActive = true
                    // itemView의 높이값을 지정해준다
                    itemView.heightAnchor.constraint(equalToConstant: 30).isActive = true
                    // 코드리스트의 갯수만큼 for문 동작
                    
                    
                }else {
                    // 1보다 작을 경우 rePairItemListView를 숨긴다
                    cell.rePairItemListView.isHidden = true
                }
            }

           
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 셀의 버튼을 눌렀을때에 동작하는 함수
    @objc func changeItem(_ sender: UIButton) {
        // 각 셀의 Id 아이디 값을 버튼 태그 값에 저장했으므로 ID 값을 다시 불러 옵니다.
        let Id = sender.tag
        // 버튼 클릭시 수정 또는 삭제 문구가 액션시트 형식으로 나오게 해줍니다.
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        //수정 버튼을 클릭시 동작하는 방식
        let updateData = UIAlertAction(title: "수정", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            // 수정 버튼을 클릭하면 repairViewController로 이도한다
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepairViewController")
                as? RepairViewController  {
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                // 이동시 Id 값이랑 delegate값을 전달해줍니다
                vc.celId = Id
                vc.repairDelegate = delegate
                self.present(vc, animated: true, completion: nil)
            }
            
        })
        // 삭제 버튼을 클릭했을때 동작하는 방식
        let deleteData = UIAlertAction(title: "삭제", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            // 선택한 셀의 데이터를 삭제합니다.
            let carBookDataBase = CARBOOK_DAO.sharedInstance
            _ = carBookDataBase.deleteCarBookData(deleteId: Id)
            // 선택한 셀의 데이터를 삭제후 데이터를 삭제한 데이터를 없앤 것을 바로 보여줍니다.
            setRepairData(year: nil)
        })
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler:nil)
        
        alert.addAction(updateData)
        alert.addAction(deleteData)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension TotalViewController : RepairCallbackDelegate {
    func setRepairData(year : String?) {
        // 먼저 기존의 데이터를 전부 지웁니다.
        self.carDataList.removeAll()
        // 내부 db에서 데이터를 불러옵니다
        self.setCarbookDataList(year: year)
        // 불러온 데이터를 테이블뷰에서 리로드해서 보여줍니다.
        self.totalTableView.reloadData()
    }
}
// 피커뷰에 필요한 datasource와 delegate 선언
extension TotalViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    // 피커뷰의 구성요소를 두개로 선언
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    //피커뷰 구성요소 중 첫번째와 두번째의 갯수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0 :
            return searchDates.count
        case 1:
            return searchDates[selectDate.yearRow].month.count
        default:
            return 0
        }
    }
    //피커뷰 구성요소 중 첫번째와 두번째의 선언
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0 :
            return "\(searchDates[row].year)년"
        case 1:
            return "\(searchDates[selectDate.yearRow].month[row])월"
        default:
            return nil
        }
    }
    // 피커뷰 안의 값을 선택했을때
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectDate.yearRow = row
            selectDate.monthRow = 0
            pickerView.reloadComponent(1)
        }else {
            selectDate.yearRow = pickerView.selectedRow(inComponent: 0)
            selectDate.monthRow = pickerView.selectedRow(inComponent: 1)
        }
    }
}
