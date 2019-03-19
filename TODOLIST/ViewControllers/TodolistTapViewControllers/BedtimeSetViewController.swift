//
//  BedtimeSetViewController.swift
//  TODOLIST
//
//  Created by RAK on 28/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class BedtimeSetViewController: UIViewController {
    
    var dismissViewControllerDelegate: DismissViewControllerDelegate?
    
    @IBOutlet var bedtimeLabel: UILabel!
    @IBOutlet var bedtimeSetButton: UIButton!
    @IBOutlet var bedtimePicker: UIDatePicker!
    
    @IBAction func tappedTimeSettingButton(_ sender: UIButton) {
        bedtimeSetButton.isSelected = !bedtimeSetButton.isSelected
        
    }
    @IBAction func tappedClosedButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.dismissViewControllerDelegate?.removeCoverView()
    }
    @IBAction func tappedSetButton(_ sender: UIButton) {
        if bedtimeSetButton.isSelected {
            let date = bedtimePicker.date
            UserDefaults.standard.set(true, forKey: "isConfiguredBedtime")
            UserDefaults.standard.set(date, forKey: "bedtime")
            NotificationProcessor.addBedtimeNotification(date: date)
        } else {
            UserDefaults.standard.set(false, forKey: "isConfiguredBedtime")
            NotificationProcessor.removeBedtimeNotification()
        }
        self.dismiss(animated: true, completion: nil)
        self.dismissViewControllerDelegate?.removeCoverView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadConfiguration()
        bedtimePicker.addTarget(self, action: #selector(changedDate), for: .valueChanged)
    }
    
    @objc func changedDate() {
        if UserDefaults.standard.bool(forKey: "isConfiguredBedtime") == false {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            
            bedtimeLabel.text = dateFormatter.string(from: bedtimePicker.date)
        }
    }
    
    func loadConfiguration() {
        
        bedtimeSetButton.isSelected = UserDefaults.standard.bool(forKey: "isConfiguredBedtime")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        let date = bedtimePicker.date
        
        if UserDefaults.standard.bool(forKey: "isConfiguredBedtime") == true {
            if let configuredBedtime = UserDefaults.standard.value(forKey: "bedtime") as? Date {
                bedtimeLabel.text = dateFormatter.string(from: configuredBedtime)
            }
        } else {
            bedtimeLabel.text = dateFormatter.string(from: date)
        }
    }

}
