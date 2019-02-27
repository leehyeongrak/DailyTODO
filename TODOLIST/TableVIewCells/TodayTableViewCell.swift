//
//  TodayTableViewCell.swift
//  TODOLIST
//
//  Created by RAK on 27/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    var task: TodayTask?
    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var checkDoneButton: UIButton!
    @IBOutlet weak var alarmOnOffButton: UIButton!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var alarmLocationLabel: UILabel!
    
    @IBAction func tappedCheckDoneButton(_ sender: UIButton) {
        if task!.checkDone {
            checkDoneButton.setTitle("□", for: .normal)
        } else {
            checkDoneButton.setTitle("■", for: .normal)
        }
        
        task?.checkDone = !((task?.checkDone)!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    @IBAction func tappedAlarmOnOffButton(_ sender: UIButton) {
        
        if task?.alarmTime == nil && task?.alarmLocation == nil {
            return
        }
        
        if task!.alarmOnOff {
            if task?.alarmTime != nil {
                NotificationProcessor.removeTimeNotification(task: task!)
            }
            if task?.alarmLocation != nil {
                NotificationProcessor.removeTimeNotification(task: task!)
            }
            alarmOnOffButton.setTitle("🔕", for: .normal)
        } else {
            if task?.alarmTime != nil {
                NotificationProcessor.addTimeNotification(task: task!)
            }
            if task?.alarmLocation != nil {
                NotificationProcessor.addLocationNotification(task: task!)
            }
            alarmOnOffButton.setTitle("🔔", for: .normal)
        }
        
        task?.alarmOnOff = !((task?.alarmOnOff)!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        
        alarmOnOffButton.layer.cornerRadius = 15
        alarmOnOffButton.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
