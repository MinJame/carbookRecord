//
//  selectFueltypeCell.swift
//  pagetest
//
//  Created by min on 2022/03/30.
//

import UIKit

class selectFueltypeCell: UITableViewCell {

    @IBOutlet weak var sliderValueLabel: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var changeoil: UISegmentedControl!
    @IBOutlet weak var ItemsView: UIView!
    @IBOutlet weak var changeDrag: UIView!
    @IBOutlet weak var selectrefillOil: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        slider.value = 50
        sliderValueLabel.titleLabel?.text = String(Int(slider.value))+"%"
      
        changeDrag.isHidden = true
    }
    @IBAction func askInfo(_ sender: Any) {
        
        let alert = UIAlertController(title: "가득/부분 주유", message: "가득주유시 정황한 연비 측정과 구간연비 값을 지원합니다.\n 부분주유시 구간 연비 값은 측정되지 않으며, 추가적으로 주유 후 연료게이지 값을 설정할 경우에만 구간연비를 예측합니다", preferredStyle: UIAlertController.Style.alert)
       
        let cancel = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel)
        
        alert.addAction(cancel) // 알림창에 버튼추가
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
         }
    @IBAction func changereFilButton(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0 :
            Swift.print("야호")
            changeDrag.isHidden = true
        case 1 :
            Swift.print("야호1")
            changeDrag.isHidden = false
            
        default:

            Swift.print("야호")
         
           
        }
        
        
        
    }
    @IBAction func changeValues(_ sender: UISlider) {
        let values = sender.value
        
        sliderValueLabel.titleLabel?.text = String(Int(values))+"%"
  
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
