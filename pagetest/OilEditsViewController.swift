//
//  OilEditsViewController.swift
//  pagetest
//
//  Created by min on 2022/03/29.
//

import Foundation
import UIKit
import BSImagePicker
import Photos

class OilEditsViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var OilTableView: UITableView!
    var names = [String]()
    public private(set) var assets: [PHAsset] = []
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var selectButton: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        initTitle()
        initTableViews()
    }
    var oilItems : [String] = []
    func initTableViews() {
        
        OilTableView.delegate = self
        OilTableView.dataSource = self
        OilTableView.rowHeight = UITableView.automaticDimension
        
        let cellsss: UINib = UINib(nibName: "RepairAddTableViewCell", bundle: nil)
        self.OilTableView.register(cellsss, forCellReuseIdentifier: "RepairAddTableViewCellID")
        
        let cellss: UINib = UINib(nibName: "directInputTableViewCell", bundle: nil)
        OilTableView.register(cellss, forCellReuseIdentifier: "directInputTableViewCellID")
        
        let cells: UINib = UINib(nibName: "repairlocateTableViewCell", bundle: nil)
        OilTableView.register(cells, forCellReuseIdentifier: "repairlocateTableViewCellID")
        setNotification()
        
        let cell: UINib = UINib(nibName: "selectFueltypeCell", bundle: nil)
        OilTableView.register(cell, forCellReuseIdentifier: "selectFueltypeCellID")
        setNotification()
        setItems()
        
    }
    
    func setItems(){
        oilItems = ["INFO1","INFO2","INFO3","ITEM"]
    }
    func initTitle() {
        // 내비게이션 타이틀 레이블
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        // 내비게이션 타이틀 레이블
        let nTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        
        // 타이틀 속성
        
        nTitle.textAlignment = .center
        nTitle.font = UIFont.systemFont(ofSize: 15)
        nTitle.text = "주유기록"
        nTitle.textColor = .white
        containerView.addSubview(nTitle)
        //        containerView.addSubview(nButton)
        self.navigationItem.titleView = containerView
        self.navigationController?.navigationBar.backgroundColor = .systemCyan
        // titleView속성은 뷰 기반으로 타이틀을 사용할 수 있음
        
    }
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        
        return oilItems.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch oilItems[indexPath.row] {
        case "INFO1" :
            let cell =  OilTableView.dequeueReusableCell(withIdentifier: "repairlocateTableViewCellID")
            
            if let btnchangeStation = cell?.contentView.viewWithTag(100) as? UIButton {
                btnchangeStation.addTarget(self, action: #selector(addBtnAction(_ :)), for: .touchUpInside)
            }
            
            if let btnaddStation = cell?.contentView.viewWithTag(103) as? UIButton {
                btnaddStation.addTarget(self, action: #selector(addBtnAction(_ :)), for: .touchUpInside)
            }
            
            return cell!
        case "INFO2" :
            let cell = OilTableView.dequeueReusableCell(withIdentifier: "RepairAddTableViewCellID")
            
            return cell!
        case "INFO3" :
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
            
          
        case "ITEM" :
            let cell = OilTableView.dequeueReusableCell(withIdentifier: "directInputTableViewCellID")
            
            
            return cell!
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
    
    @objc func changereFilButton(_ sender: UISegmentedControl) {

        OilTableView.reloadData()
//        switch sender.selectedSegmentIndex {
//        case 0 :
//            Swift.print("야호")
//            let cell = OilTableView.dequeueReusableCell(withIdentifier: "selectFueltypeCellID")
//            let items =  cell?.contentView.viewWithTag(105)as? UIView
//            items!.isHidden = true
//          //  changeDrag.isHidden = false
//        case 1 :
//            Swift.print("야호1")
//            let cell = OilTableView.dequeueReusableCell(withIdentifier: "selectFueltypeCellID")
//            let items =  cell?.contentView.viewWithTag(105)as? UIView
//            items!.isHidden = false
//         //   OilTableView.reloadData()
//         // changeDrag.isHidden = false
//        default:
//
//            Swift.print("야호")
//
//
//        }
    }
    
    
    //
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch oilItems[indexPath.row] {
        case "INFO1" :
            return UITableView.automaticDimension
        case "INFO2" :
            return UITableView.automaticDimension
        case "INFO3" :
            return UITableView.automaticDimension
        case "ITEM" :
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


