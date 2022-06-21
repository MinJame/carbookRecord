//
//  repairsTableViewCell.swift
//  pagetest
//
//  Created by min on 2022/03/28.
//
import Foundation
import UIKit
import BSImagePicker
import Photos

protocol CollectionViewCellDelegate: class {
    func CollectionView(collectionviewcell: ImageCollectionViewCell?, index: Int, didTappedInTableViewCell: repairsTableViewCell)
}

class repairsTableViewCell: UITableViewCell {

    weak var  cellDelegate: CollectionViewCellDelegate?
    
    var rowWithColors: [CollectionViewCellModel]?
    
    @IBOutlet weak var rePairShopView: UIView!
    @IBOutlet weak var addShopBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var changeRepairIabel: UIButton!
    @IBOutlet weak var rePairDistance: UILabel!
    @IBOutlet weak var changeLabelButton: UIButton!
    @IBOutlet weak var driveDistance: UITextField!
//    @IBOutlet weak var rePairDistanceInfoView: UIView!    
    @IBOutlet weak var rePairLocationView: UIView!
    @IBOutlet weak var addRepairShopView: UIView!
    @IBOutlet weak var rePairTitleView: UIView!
    @IBOutlet weak var addLocation: UIButton!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var addimageViews: UIView!
    public private(set) var assets: [PHAsset] = []
    @IBOutlet weak var noLocateBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        firstView.isHidden = false
        addShopBtn.layer.borderWidth = 1
        addShopBtn.layer.borderColor = UIColor.lightGray.cgColor
        addShopBtn.layer.cornerRadius = 10
        changeRepairIabel.layer.borderColor = UIColor.lightGray.cgColor
        changeRepairIabel.layer.borderWidth = 1
        changeRepairIabel.layer.cornerRadius = 3
        addImageButton.layer.cornerRadius = 5
        toolbarItems()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        driveDistance.delegate = self
        let cellNib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "ImageCollectionViewCellID")

    }

    @IBAction func changeViews(_ sender: Any) {
       rePairLocationView.isHidden = true
      rePairShopView.isHidden = true
     addRepairShopView.isHidden = false
    }
//    @objc func changeViews() {
////        addRepairShopView.isHidden = false
////        rePairTitleView.isHidden = true
//     //  rePairDistanceInfoView.isHidden = true
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func toolbarItems() {
    
        let doneBT = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.pickeradd))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBT = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.pickerExit))
        var itemtools = UIToolbar()
        itemtools.sizeToFit()
        itemtools.tintColor = UIColor(displayP3Red: 42/255, green: 198/255, blue: 254/255, alpha: 1)
        itemtools.setItems([flexibleSpace,cancelBT,doneBT], animated: false)
        itemtools.isUserInteractionEnabled = true
        driveDistance.inputAccessoryView = itemtools
    
    }
    @objc func pickeradd() {
  
        self.driveDistance.endEditing(true)
    }
    
    
    @objc func pickerExit() {
        /// picker와 같은 뷰를 닫는 함수
        self.driveDistance.endEditing(true)
    }
    
    
    @IBAction func changedistances(_ sender: UIButton) {
        
        let messageitem: String? = "가까운 장소"
        let messageitem2: String? = "방문 장소"
        
      
        var messagetitle = rePairDistance!.text
        if  messagetitle == "방문 장소 기준" {
            messagetitle = messageitem2
        }
        else {
            messagetitle = messageitem
        }

        let alert = UIAlertController(title: "장소 검색 기준", message: "장소 검색 기준에 따라 자동으로 장소가 선택됩니다.\n 현재 검색 기준이 '\(messagetitle!)'로 설정되어있습니다.원하시는 기준을 설정해주세요", preferredStyle: UIAlertController.Style.alert)
        let addDistance = UIAlertAction(title: "가까운 장소", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            rePairDistance.text = "\(messageitem!) 기준"
            rePairDistance.textColor = .lightGray
            UserDefaults.standard.set(rePairDistance.text,forKey: "distance")
      
            
        })
        let selectionDistance = UIAlertAction(title: "방문 장소", style: UIAlertAction.Style.default, handler:{ [self]
            action in
            rePairDistance.text = "\(messageitem2!) 기준"
            rePairDistance.textColor = .lightGray
            
            UserDefaults.standard.set(rePairDistance.text,forKey: "distance")
        
            
        })
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler:nil)
        
        alert.addAction(addDistance)
        alert.addAction(selectionDistance)
        alert.addAction(cancel)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.present(alert, animated: true, completion: nil)
         }
        
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow),
          name: UIResponder.keyboardWillShowNotification,
          object: nil
        )
        
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide),
          name: UIResponder.keyboardWillHideNotification,
          object: nil
        )
      }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
        let keybaordRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keybaordRectangle.height
          driveDistance.frame.origin.y -= keyboardHeight
      }
    }
      
    @objc private func keyboardWillHide(_ notification: Notification) {
      if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
        let keybaordRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keybaordRectangle.height
          driveDistance.frame.origin.y += keyboardHeight
      }
    }
    
    @IBAction func selectImages(_ sender: UIButton) {
        Swift.print("action")
        //멀티 사진 선택
        let imagePicker = ImagePickerController()
//        imagePicker.delegate = self
        imagePicker.settings.selection.max = 5
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        imagePicker.settings.selection.unselectOnReachingMax = true
       
        
        let vc = self.window?.rootViewController
        vc!.presentImagePicker(imagePicker, select: { (asset) in
            
        }, deselect: { (asset) in
            
        }, cancel: { (assets) in
            
        }, finish: { (assets) in
            
            for i in 0..<assets.count {
                self.assets.append(assets[i])
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
                
                let data = thumbnail.jpegData(compressionQuality: 1)
                let newImage = UIImage(data: data!)
  
                var imageView : UIImageView!
                imageView = UIImageView(frame: CGRect(x:20,y:40,width:200,height:200))
                imageView.image = newImage
                
                self.addimageViews.addSubview(imageView)
                
                Swift.print("\(self.assets.append(assets[i]))")
            }
            
          
            
        }, completion: {
        })
    }
}


extension repairsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // The data we passed from the TableView send them to the CollectionView Model
    func updateCellWith(row: [CollectionViewCellModel]) {
        self.rowWithColors = row
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell
        print("I'm tapping the \(indexPath.item)")
        self.cellDelegate?.CollectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rowWithColors?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Set the data for each cell (color and color name)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCellID", for: indexPath) as? ImageCollectionViewCell {
//            cell.colorView.backgroundColor = self.rowWithColors?[indexPath.item].color ?? UIColor.black
//            cell.nameLabel.text = self.rowWithColors?[indexPath.item].name ?? ""
            Swift.print("나옵다")
            return cell
        }
        return UICollectionViewCell()
    }
    
    // Add spaces at the beginning and the end of the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

extension repairsTableViewCell : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // replacementString : 방금 입력된 문자 하나, 붙여넣기 시에는 붙여넣어진 문자열 전체
            // return -> 텍스트가 바뀌어야 한다면 true, 아니라면 false
            // 이 메소드 내에서 textField.text는 현재 입력된 string이 붙기 전의 string
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal // 1,000,000
            formatter.locale = Locale.current
            formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
            
            // formatter.groupingSeparator // .decimal -> ,
            
            if let removeAllSeprator = driveDistance.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
                var beforeForemattedString = removeAllSeprator + string
                if formatter.number(from: string) != nil {
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        driveDistance.text = formattedString
                        return false
                    }
                }else{ // 숫자가 아닐 때먽
                    if string == "" { // 백스페이스일때
                        let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                        beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                        if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                            driveDistance.text = formattedString
                            return false
                        }
                    }else{ // 문자일 때
                        return false
                    }
                }

            }
            
            return true
        }
    
}
