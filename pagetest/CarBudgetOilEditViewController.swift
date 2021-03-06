//
//  CarBudgetEditViewController.swift
//  pagetest
//
//  Created by min on 2022/03/08.
//

import Foundation
import UIKit

class CarBudgetOilEditViewController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
  
    @IBOutlet weak var filmemoView: UITextView!
    @IBOutlet weak var fueltypeField: UITextField!
    @IBOutlet weak var fuelLiterUnitLabel: UILabel!
    @IBOutlet weak var fueltypeCostLabel: UILabel!
    @IBOutlet weak var fuelCostUnitLabel: UILabel!
    @IBOutlet weak var changeOilStation: UIButton!
    @IBOutlet weak var totalDriveDistanceField: UITextField!
    @IBOutlet weak var oilStationDistanceLabel: UILabel!
    @IBOutlet weak var NoOilStation: UIButton!
    @IBOutlet weak var questionMarkButton: UIButton!
    @IBOutlet weak var fuelCostFiled: UITextField!
    @IBOutlet weak var fuelCostTitle: UILabel!
    @IBOutlet weak var fuelLiterTitle: UILabel!
    @IBOutlet weak var fuelLiterField: UITextField!
    @IBOutlet weak var fuelTextButton: UIButton!
    let picker = UIImagePickerController()
    @IBOutlet weak var selectImage: UIButton!
    @IBOutlet weak var disMeter: UILabel!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTextLabel: UILabel!

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addPlaceView: UIView!
    @IBOutlet weak var addPlaceButton: UIButton!
    var isZoom = true
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)

            
        distanceButton.setTitle(UserDefaults.standard.string(forKey: "distacnes"), for: .normal)
        distanceButton.setTitleColor(.black, for: .normal)
        fuelTextButton.setTitle(UserDefaults.standard.string(forKey: "oiltypes"), for: .normal)
        fuelTextButton.setTitleColor(.black, for: .normal)
        changeOilStation.layer.borderWidth = 1
        changeOilStation.layer.borderColor = UIColor.gray.cgColor
        oilStationDistanceLabel.text =
        UserDefaults.standard.string(forKey: "distance")
//        navigationController?.setNavigationBarHidden(true, animated: true)
        let color = UIColor(red: 0.02, green: 0.22, blue: 0.49, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = .black
        placeholderSetting()
        
        self.initTitle()
         }
         
         // ??????????????? ??? ????????? ?????? ?????????
         func initTitle() {
             // ??????????????? ????????? ?????????
             let nTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
             
             // ????????? ??????
//             nTitle.numberOfLines = 2
//             nTitle.textAlignment = .center
//             nTitle.font = UIFont.systemFont(ofSize: 15)
//             nTitle.text = "3???22??? ????????????"
//             nTitle.textColor = .white
             let color = UIColor(red: 0.02, green: 0.22, blue: 0.78, alpha: 1.0)
             self.navigationController?.navigationBar.backgroundColor = color
             self.navigationItem.titleView = nTitle // titleView????????? ??? ???????????? ???????????? ????????? ??? ??????
         }
    
    @IBAction func changeDistanceButton(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)
        let addDistance = UIAlertAction(title: "??????????????????", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            distanceButton.setTitle("??????????????????", for: .normal)
            distanceButton.setTitleColor(.black, for: .normal)
            UserDefaults.standard.set(distanceButton.currentTitle,forKey: "distacnes")
            
        })
        let selectionDistance = UIAlertAction(title: "??????????????????", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            distanceButton.setTitle("??????????????????", for: .normal)
            distanceButton.setTitleColor(.black, for: .normal)
            UserDefaults.standard.set(distanceButton.currentTitle,forKey: "distacnes")
        })
        let cancel = UIAlertAction(title: "??????", style: .destructive, handler:nil)
        
        alert.addAction(addDistance)
        alert.addAction(selectionDistance)
        alert.addAction(cancel)
        
        self.present(alert, animated: false)
        
    }
    @IBAction func addStaitionButtons(_ sender: UIButton) {
        
        addPlaceView.isHidden = false
        topView.sizeToFit()
        topView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        topView.autoresizesSubviews = true
    }
    
    @IBAction func changeOilTypeButton(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)
        let gasoline = UIAlertAction(title: "?????????", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            fuelTextButton.setTitle("?????????", for: .normal)
            fuelTextButton.setTitleColor(.black, for: .normal)
            UserDefaults.standard.set(fuelTextButton.currentTitle,forKey: "oiltypes")
        })
        let diesel = UIAlertAction(title: "??????", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            fuelTextButton.setTitle("??????", for: .normal)
            fuelTextButton.setTitleColor(.black, for: .normal)
            UserDefaults.standard.set(fuelTextButton.currentTitle,forKey: "oiltypes")
        })
        let LPG = UIAlertAction(title: "LPG", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            fuelTextButton.setTitle("LPG", for: .normal)
            fuelTextButton.setTitleColor(.black, for: .normal)
            UserDefaults.standard.set(fuelTextButton.currentTitle,forKey: "oiltypes")
        })
        let cancel = UIAlertAction(title: "??????", style: .destructive, handler:nil)
        
        
        alert.addAction(gasoline)
        alert.addAction(diesel)
        alert.addAction(LPG)
        alert.addAction(cancel)
        
        self.present(alert, animated: false)
    }
    
    
    
    @IBAction func QAButton(_ sender: Any) {
        let messageitem = "????????? ??????"
        let messageitem2 = "?????? ??????"
        var messagetitle = oilStationDistanceLabel.text
        if  messagetitle == "?????? ?????? ??????" {
            messagetitle = messageitem2
        }
        else {
            messagetitle = messageitem
        }
       
        
        let alert = UIAlertController(title: "?????? ?????? ??????", message: "?????? ?????? ????????? ?????? ???????????? ????????? ???????????????.\n ?????? ?????? ????????? '\(messagetitle)'??? ????????????????????????.???????????? ????????? ??????????????????", preferredStyle: UIAlertController.Style.alert)
        let addDistance = UIAlertAction(title: "????????? ??????", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            oilStationDistanceLabel.text = "\(messageitem) ??????"
            oilStationDistanceLabel.textColor = .lightGray
            
            UserDefaults.standard.set(oilStationDistanceLabel.text,forKey: "distance")
      
            
            
        })
        let selectionDistance = UIAlertAction(title: "?????? ??????", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            oilStationDistanceLabel.text = "\(messageitem2) ??????"
            oilStationDistanceLabel.textColor = .lightGray
            
            UserDefaults.standard.set(oilStationDistanceLabel.text,forKey: "distance")
        
            
        })
        let cancel = UIAlertAction(title: "??????", style: .destructive, handler:nil)
        
        alert.addAction(addDistance)
        alert.addAction(selectionDistance)
        alert.addAction(cancel)
        
        
        self.present(alert, animated: false)
        
    }
    
    @IBAction func selectImageFromLib(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)
        let camera = UIAlertAction(title: "????????????", style: .default, handler:{ [self]
            action in
            
            openCamera()
        })
        let album = UIAlertAction(title: "??????", style: .default, handler:{ [self]
            action in
            
            openLibrary()
        })
        
        let cancel = UIAlertAction(title: "??????", style: .destructive, handler:nil)
        
        
        alert.addAction(camera)
        alert.addAction(album)
        alert.addAction(cancel)
        
        present(alert, animated: false)
        
    }
    
//    func memoPlaceholderSetting() {
//        filmemoView.delegate = self // txtvReview??? ????????? ????????? outlet
//        filmemoView.text = "?????? 250??? ????????????/n (???????????? ??????)"
//        filmemoView.textColor = .lightGray
//
//    }
    
    // MARK: - TextField & Keyboard Methods
    
    func placeholderSetting() {
        filmemoView.delegate = self // txtvReview??? ????????? ????????? outlet
        filmemoView.text = "?????? 250??? ????????????\n(???????????? ??????)"
        filmemoView.textColor = UIColor.lightGray
         
     }

    
    
    // TextView Place Holder
     func textViewDidBeginEditing(_ textView: UITextView) {
         if filmemoView.textColor == UIColor.lightGray {
             filmemoView.text = nil
             textView.textColor = UIColor.black
         }
         
     }
     // TextView Place Holder
     func textViewDidEndEditing(_ textView: UITextView) {
         if filmemoView.text.isEmpty {
             filmemoView.text = "?????? 250??? ????????????\n(???????????? ??????)"
             filmemoView.textColor = UIColor.lightGray
         }
     }


    
    @objc func keyboardShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0 {
                
                self.view.frame.origin.y -= keyboardSize.height/2.1
                
            }
            
        }
        
    }
    
    @objc func keyboardHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height/2.1
            }
            
        }
        
    }
    @objc func dismissKeyboard() {
        
        self.view.endEditing(true)
        
    }
    
    //MARK: - "??????????????????"
    //?????? ??????
    func openLibrary(){
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: false, completion: nil)
        
    }
    
    func openCamera(){
        
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: false, completion: nil)
        } else{
            Swift.print("Camera not available")
        }
        
    }
    
}
