//
//  SearchViewController.swift
//  pagetest
//
//  Created by min on 2022/06/07.
//

import Foundation
import UIKit




class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchItemText: UITextField!
    @IBOutlet weak var goBackButton: UIButton!
    var dataList : [Dictionary<String,Any>] = []
    var delegate : RepairCallbackDelegate?
    var categoryNames : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        initTableView()
        self.delegate?.setRepairData(year: nil)
    }
    
    func setDelegates() {
        // searchTableView의 delegate와 dataSource 값 선언
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    func initTableView () {
        // rePairListTableViewCell을 cell로 저장하고
        let cell: UINib = UINib(nibName: "RepairListTableViewCell", bundle: nil)
        // searchTableView에 등록한다
        self.searchTableView.register(cell, forCellReuseIdentifier: "RepairListTableViewCellID")
        // searchTableView 열의 높이가 지정
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
    }
    // db에 저장했던 정비항목 코드를 보여줄때에는 정비항목 명으로 변환한다
    func getCodeText(Code : String) -> String {
        switch Code {
        case "1" :
            return "엔진오일 및 오일 필터"
        case "2":
            return"에어콘 필터"
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
            return "우리집"
        default :
            return "엔진오일 및 오일 필터"
        }
    }
    
    // 전에 페이지로 이동
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true)
    }
    // 아이템 항목 검색시 해당하는 데이터 불러오기 위한 함수
    @IBAction func searchItems(_ sender: Any) {
        // 만약 텍스트필드가 비어있지 않으면  텍스트 필드에 있는 내용을 검색한다
        if searchItemText.text != "" {
            //먼저 기존데이터들을 삭제한다
            dataList.removeAll()
            // 기존 데이터 삭제후 텍스트 필드에 있는 내용을 검색한다
            researchItems()
            // 키보드를 내린다
            dismissKeyboard()
            // 검색한 데이터를 테이블뷰에서 다시 보여준다
            searchTableView.reloadData()
        }else {
            dataList.removeAll()
            searchTableView.reloadData()
        }
        
    }
    // 텍스트 필드에 있는 내용을 db에서 검색하는 함수
    func researchItems() {
        // db에 접속할수 있게 선언
        let carBookDatabase = CARBOOK_DAO.sharedInstance
        var categoryName : String = ""
        var categoryMemo : String = ""
        var categoryMemoitem : String = ""
        var categoryCodes : String = ""
        var categoryMemos : String = ""
        var oilSearchItem : Dictionary<String,Any> = [:]
        // db에서 텍스트 필드의 내용이 있으면 검색할수 있는 동작 구현
        if let list : [Dictionary<String,Any>] = carBookDatabase.searchCarbookDataList(name: searchItemText.text ?? "") {
            
            let listItem : [Dictionary<String,Any>] = carBookDatabase.searchOilDataList(name: searchItemText.text ?? "") ?? []
            //배열 안에 있는 것들을 i인덱스수 만큼 for문 동작
            Swift.print("첫번째\(listItem)")
            
            for item in list {
                //searchItem에 dictionary 형으로 필요한 데이터들을 저장
                let searchItem : Dictionary<String,Any> = [
                    "repairMode": item["repairMode"] as? Int ?? 0,
                    "repairPlace" : item["repairPlace"] as? String ?? "",
                    "repairAddress" : item["repairAddress"] as? String ?? "",
                    "repairExpendDate" : item["repairExpendDate"] as? String ?? "",
                    "TotalCost" : item["TotalCost"] as? Double ?? 0.0,
                    "repairDist" : item["repairDist"] as? Double ?? 0.0,
                    "repairItemIsHidden" : item["repairItemIsHidden"] as? Int ?? 0,
                    "repairltemMemo" : item["repairltemMemo"] as? String ?? "",
                    "repairltemName": item["repairltemName"] as? String ?? "",
                    "repairItemCost": item["repairItemCost"] as? Double ?? 0.0,
                    "repairltemCategoryCode": item["repairltemCategoryCode"] as? String ?? "",
                    "repairSN" : item["repairSN"] as? Int ?? 0,
                    "COUNT" : item["COUNT"] as? Int ?? 0,
                    "categoryCodes" : item["categoryCodes"] as? String ?? "",
                    "categoryCodesCost" : item["categoryCodesCost"] as? String ?? "",
                    "carbookRecordItemMemos" : item["carbookRecordItemMemos"] as? String ?? ""
                ]
                // searchItem들의 dataList에 합해줍니다
                dataList.append(searchItem)
                
                // 차량 정비 목록을 categoryName으로 저장
                categoryCodes = item["categoryCodes"] as? String ?? ""
                categoryMemo = item["repairItemMemo"] as? String ?? ""
                categoryMemos = item["carbookRecordItemMemos"] as? String ?? ""
                let codeList = categoryCodes.components(separatedBy: ",")
                let memoList = categoryMemos.components(separatedBy: ",")
                for (index,value) in codeList.enumerated() {
                    categoryName = getCodeText(Code: value)
                    categoryMemoitem = memoList[index]
                }
                // 만약 차량정비 목록이 searItemText의 내용을 가지고 있으면
                if categoryName.contains(searchItemText.text ?? "") && !categoryMemoitem.contains(searchItemText.text ?? "")   {
                    //categoryNames에 categoryName 저장
                    categoryNames = categoryName
                    Swift.print("이름가져와\(categoryName)")
                }
                
                
            }
            for item in listItem {
                let oilItem : Dictionary<String,Any> = [
                    "fuelingID" : item["fuelingID"] as? String ?? "",
                    "fuelingPlace" : item["fuelingPlace"] as? String ?? "",
                    "fuelingAddress" : item["fuelingAddress"] as? String ?? "",
                    "fuelingMemo": item["fuelingMemo"] as? String ?? "",
                    "fuelingIsHidden" : item["fuelingIsHidden"] as? Int ?? 0,
                    "fuelingLatitude" : item["fuelingLatitude"] as? Double ?? 0.0,
                    "fuelingLongitude" : item["fuelingLongitude"] as? Double ?? 0.0,
                    "fuelingExpendDate" : item["fuelingExpendDate"] as? String ?? "",
                    "fuelingDist" : item["fuelingDist"]as? Double ?? 0.0,
                    "fuelingTotalCost":item["fuelingTotalCost"] as? Double ?? 0.0,
                    "fuelType": item["fuelType"] as? String ?? "",
                    "fuelingFuelCost":item["fuelingFuelCost"] as? Double ?? 0.0,
                    "fuelingItemVolume": item["fuelingItemVolume"] as? Double ?? 0.0,
                    "fuelingImage":item["fuelingMemo"] as? String ?? ""
                    
                ]
                oilSearchItem = oilItem
                dataList.append(oilSearchItem)
            }
            Swift.print("이름가져와\(dataList)")
        }
    }
    // 키보드가 내려가는 함수 입니다
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
}
// MARK: - TableView Delegate,DataSource 선언
extension SearchViewController: UITableViewDelegate {
    
}
extension SearchViewController : UITableViewDataSource {
    // 테이블뷰의 열을 선택했을때 동작하는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath : IndexPath) {
        // dataList의 값들을 item에 저장
        let item = dataList[indexPath.row]
        // 저장된 데이터 중에 정비기록Id 값을 불러와서 id에 저장
        let types = item["carbookRecordType"] as? String
        let id = item["repairSN"] as? Int ?? 0
        let fuelId = item["fuelingID"] as? String ?? ""
        Swift.print("키값1\(fuelId)")
        if id != 0 {
            // 해당열을 눌렀을때에 "RepairViewController"로 이동
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepairViewController")
                as? RepairViewController  {
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                // 이동하는데 totalviewcontroller에서 선택한 열의 아이디 값
                vc.cellId = String(id)
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
                vc.cellId = fuelId
                // totalviewcontroller에서 선언해준 delegate 값을 전달해준다
                vc.repairDelegate = delegate
                self.present(vc, animated: true, completion: nil)
            }
            
        }
    }
    // 테이블뷰의 셀의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    // 테이블뷰 셀에 들어갈 데이터들
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RepairListTableViewCell  = searchTableView.dequeueReusableCell(withIdentifier: "RepairListTableViewCellID", for: indexPath) as! RepairListTableViewCell
        let item = dataList[indexPath.row]
        
        let fuelId = item["fuelingID"] as? String ?? ""
        
        if fuelId != "" {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyyMMddHHmmss"
            let fuelCost = item["fuelingTotalCost"] as? Double ?? 0.0
            let fuelDist = item["fuelingDist"] as? Double ?? 0.0
            let fuelDate = formatter.date(from : item["fuelingExpendDate"] as? String ?? "")
            formatter.dateFormat = "MM.dd"
            let fuelDates = formatter.string(for: fuelDate) ?? ""
            // memoView를 숨겨준다
            cell.memoView.isHidden = true
            if item["fuelingID"] as? String  != "" {
                cell.rePairItemTitleLabel.text = item["fuelingPlace"] as? String ?? ""
                cell.rePairLocationLabel.text = item["fuelingAddress"] as? String ?? ""
                cell.totalDistanceLabel.text = String(format: "%.f", fuelDist)
                cell.rePairExpenseCost.text = String(format: "%.f", fuelCost)
                cell.rePairDateLabel.text = fuelDates
                cell.rePairItemListView.isHidden = true
                cell.memoView.isHidden = false
                
            }
            cell.changeItemButton.tag  = Int(item["fuelingID"] as? String ?? "") ?? 0
            cell.changeItemButton.addTarget(self, action: #selector(changeOilItem(_:)), for: .touchUpInside)
            if let fuelingFuelCost = item["fuelingFuelCost"] as? Double  {
                cell.fuelCostBtn.setTitle(String(format: "%.f", fuelingFuelCost) + "/" + "L", for: .normal)
                cell.fuelCostBtn.titleLabel?.font = UIFont.systemFont(ofSize: 8)
                cell.fuelCostBtn.isHidden  = false
            }
            
            if let memoText = item["fuelingMemo"] as? String  {
                // 만약 memoText 값이 있으면
                if memoText != "" {
                    // memoView를 숨기지 않고 memoText값을 memoTextView에 넣어준다
                    cell.memoView.isHidden = false
                    cell.memoTextView.text = memoText
                }else {
                    cell.memoView.isHidden = true
                }
            }
            
        }else {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyyMMddHHmmss"
            let dateStrings = formatter.date(from : item["repairExpendDate"] as? String ?? "")
            formatter.dateFormat = "MM.dd"
            cell.rePairDateLabel.text = formatter.string(for: dateStrings) ?? ""
            
            let rePairDist = item["repairDist"] as? Double ?? 0.0
            cell.totalDistanceLabel.text = String(format: "%.f", rePairDist )
            
            let TotalCost =  item["TotalCost"] as? Double ?? 0.0
            cell.rePairExpenseCost.text = String(format: "%.f", TotalCost)
            
            let rePairAddress = item["repairAddress"] as? String ?? ""
            cell.rePairLocationLabel.text = rePairAddress
            
            
            //cell의 ID값을 버튼의 태그 값에 저장을 합니다
            cell.changeItemButton.tag = item["repairSN"] as? Int ?? 0
            //cell의 버튼의 액션을 할 수 있게 추가해줍니다.
            cell.changeItemButton.addTarget(self, action: #selector(changeItem(_:)), for: .touchUpInside)
            // 만약 item의 carbookRecordItemCategoryCode의 문자형이면 categoryName에 저장하고
            if let categoryName = item["repairltemCategoryCode"] as? String {
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
            if let memoText = item["repairltemMemo"] as? String  {
                // 만약 memoText 값이 있으면
                if memoText != "" {
                    // memoView를 숨기지 않고 memoText값을 memoTextView에 넣어준다
                    cell.memoView.isHidden = false
                    cell.memoTextView.text = memoText
                }
                else {
                    cell.memoView.isHidden = true
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
            
        }
        
        
        return cell
    }
    
    
    //셀의 버튼 클릭시 동작하는 함수
    @objc func changeItem(_ sender: UIButton) {
        // 각 셀의 Id 아이디 값을 버튼 태그 값에 저장했으므로 ID 값을 다시 불러 옵니다.
        let Id = sender.tag
        // 버튼 클릭시 수정 또는 삭제 문구가 액션시트 형식으로 나오게 해줍니다.
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        //수정 버튼을 클릭시 동작하는 방식
        let updateData = UIAlertAction(title: "수정", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepairViewController")
                as? RepairViewController  {
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                vc.cellId = String(Id)
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
            self.dataList.removeAll()
            self.searchTableView.reloadData()
        })
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler:nil)
        
        alert.addAction(updateData)
        alert.addAction(deleteData)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func changeOilItem(_ sender: UIButton) {
        // 각 셀의 Id 아이디 값을 버튼 태그 값에 저장했으므로 ID 값을 다시 불러 옵니다.
        let Id = sender.tag
        Swift.print("키값\(Id)")
        // 버튼 클릭시 수정 또는 삭제 문구가 액션시트 형식으로 나오게 해줍니다.
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        //수정 버튼을 클릭시 동작하는 방식
        let updateData = UIAlertAction(title: "수정", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            // 수정 버튼을 클릭하면 repairViewController로 이도한다
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OilEditsViewController")
                as? OilEditsViewController  {
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                // 이동시 Id 값이랑 delegate값을 전달해줍니다
                vc.cellId = String(Id)
                vc.repairDelegate = delegate
                self.present(vc, animated: true, completion: nil)
            }
            
        })
        // 삭제 버튼을 클릭했을때 동작하는 방식
        let deleteData = UIAlertAction(title: "삭제", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            // 선택한 셀의 데이터를 삭제합니다.
            let carBookDataBase = CARBOOK_DAO.sharedInstance
            _ = carBookDataBase.deleteOilData(deleteId: String(Id))
            // 선택한 셀의 데이터를 삭제후 데이터를 삭제한 데이터를 없앤 것을 바로 보여줍니다.
            self.dataList.removeAll()
            self.searchTableView.reloadData()
            
        })
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler:nil)
        
        alert.addAction(updateData)
        alert.addAction(deleteData)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //테이블뷰의 높이지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    
}

//
