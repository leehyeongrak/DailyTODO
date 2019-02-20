//
//  WriteViewController.swift
//  TODOLIST
//
//  Created by RAK on 20/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import MapKit

class WriteViewController: UIViewController, UITextFieldDelegate {
    
    var isToday: Bool = true {
        didSet {
            if isToday {
                todayButton.setTitle("■", for: .normal)
                tomorrowButton.setTitle("□", for: .normal)
            } else {
                todayButton.setTitle("□", for: .normal)
                tomorrowButton.setTitle("■", for: .normal)
            }
        }
    }
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var tomorrowButton: UIButton!
    
    @IBAction func tappedTodayButton(_ sender: UIButton) {
        isToday = true
    }
    @IBAction func tappedTomorrowButton(_ sender: UIButton) {
        isToday = false
    }
    
    @IBOutlet weak var todoTextField: UITextField!
    
    @IBOutlet weak var memoTextField: UITextField!
    
    // Time Alarm Setting ---------------------------------------
    @IBOutlet weak var timeSettingButton: UIButton!
    
    @IBAction func tappedTimeSettingButton(_ sender: UIButton) {
//        timeSettingButton.setTitle("설정■", for: .normal)
        timeSettingButton.setTitle("설정■", for: .selected)
        timeSettingButton.isSelected = !timeSettingButton.isSelected
        
    }
    
    @IBOutlet weak var timePicker: UIDatePicker!
    // ----------------------------------------------------------
    
    // Location Alarm Setting -----------------------------------
    @IBOutlet weak var locationSettingButton: UIButton!
    
    @IBAction func tappedLocationSettingButton(_ sender: UIButton) {
//        locationSettingButton.setTitle("설정■", for: .normal)
        locationSettingButton.setTitle("설정■", for: .selected)
        locationSettingButton.isSelected = !locationSettingButton.isSelected
    }
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var locationMapView: MKMapView!
    // ----------------------------------------------------------
    
    @IBAction func tappedWriteButton(_ sender: UIButton) {
    }
    
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTextField.delegate = self
        memoTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
