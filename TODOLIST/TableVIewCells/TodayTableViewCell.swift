//
//  TodayTableViewCell.swift
//  TODOLIST
//
//  Created by RAK on 27/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    var task: TodayTask? {
        didSet {
            matchData()
        }
    }
    
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
    
    func matchData() {
        guard let task = self.task else { return }
        
        if let todoText = task.todoText, let memoText = task.memoText {
            
            todoLabel.text = todoText
            if memoText == "" {
                memoLabel.text = "--"
            } else {
                memoLabel.text = memoText
            }
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            
            // 시간설정 여부에 따른 옵셔널값 처리
            if task.alarmTime == nil {
                alarmTimeLabel.text = "--"
            } else {
                alarmTimeLabel.text = dateFormatter.string(from: task.alarmTime!)
                if task.alarmOnOff {
                    NotificationProcessor.addTimeNotification(task: task)
                    alarmOnOffButton.setTitle("🔔", for: .normal)
                } else {
                    alarmOnOffButton.setTitle("🔕", for: .normal)
                }
            }
            
            // 장소설정 여부에 따른 옵셔널값 처리
            if task.alarmLocation == nil {
                alarmLocationLabel.text = "--"
            } else {
                let place = task.alarmLocation!["placeName"] as! String
                let roadAddress = task.alarmLocation!["roadAddressName"] as! String
                alarmLocationLabel.text = "\(place)(\(roadAddress))"
                if task.alarmOnOff {
                    NotificationProcessor.addLocationNotification(task: task)
                    alarmOnOffButton.setTitle("🔔", for: .normal)
                } else {
                    alarmOnOffButton.setTitle("🔕", for: .normal)
                }
            }
            
            if task.checkDone {
                checkDoneButton.setTitle("■", for: .normal)
            } else {
                checkDoneButton.setTitle("□", for: .normal)
            }
        }
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
