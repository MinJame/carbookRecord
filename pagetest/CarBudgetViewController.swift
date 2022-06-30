//
//  ViewController.swift
//  pagetest
//
//  Created by min on 2022/03/07.
//

import UIKit

class CarBudgetViewController: UIViewController {
    
    
    @IBOutlet weak var oilFilButton: UIButton!
    @IBOutlet weak var carRepairButton: UIButton!
    @IBOutlet weak var extraItemButton: UIButton!
    @IBOutlet weak var currentUnitImageView: UIImageView!
    @IBOutlet weak var inputCostLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func moveToOilPageBtn(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OilEditsViewController")
            as? OilEditsViewController  {
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            
        }
        
    }
    @IBAction func moveToTotalPageBtn(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TotalViewController")
            as? TotalViewController  {
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            
        }
    }
    
    @IBAction func moveToRePairPageBtn(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RepairViewController")
            as? RepairViewController  {
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: true)
            
        }
    }
}



