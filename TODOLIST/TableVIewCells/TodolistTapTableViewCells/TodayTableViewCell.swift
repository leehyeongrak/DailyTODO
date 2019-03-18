//
//  TodayTableViewCell.swift
//  TODOLIST
//
//  Created by RAK on 27/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    var task: Task? {
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
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.checkDoneButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            self.checkDoneButton.transform = CGAffineTransform.identity
                        }
        })
        
        checkDoneButton.isSelected = !checkDoneButton.isSelected
        task?.checkDone = !((task?.checkDone)!)
        CoreDataStack.shared.saveContext()
    }
    @IBAction func tappedAlarmOnOffButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.alarmOnOffButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            self.alarmOnOffButton.transform = CGAffineTransform.identity
                        }
        })
        
        if task?.alarmTime == nil && task?.alarmLocation == nil {
            return
        }
        
        if task!.alarmOnOff {
            if task?.alarmTime != nil {
                if (task?.alarmTime)! > Date() {
                    NotificationProcessor.removeTimeNotification(task: task!)
                }
            }
            if task?.alarmLocation != nil {
                NotificationProcessor.removeLocationNotification(task: task!)
            }
            alarmOnOffButton.isSelected = false
        } else {
            if task?.alarmTime != nil {
                if (task?.alarmTime)! > Date() {
                    NotificationProcessor.addTimeNotification(task: task!)
                }
            }
            if task?.alarmLocation != nil {
                NotificationProcessor.addLocationNotification(task: task!)
            }
            alarmOnOffButton.isSelected = true
        }
        
        task?.alarmOnOff = !((task?.alarmOnOff)!)
        CoreDataStack.shared.saveContext()
    }
    
    func matchData() {
        guard let task = self.task else { return }
        
        if let todoText = task.todoText, let memoText = task.memoText {
            
            todoLabel.text = todoText
            if memoText == "" {
                memoLabel.text = "-"
            } else {
                memoLabel.text = memoText
            }
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            
            // 시간설정 여부에 따른 옵셔널값 처리
            if task.alarmTime == nil {
                alarmTimeLabel.text = "-"
            } else {
                alarmTimeLabel.text = dateFormatter.string(from: task.alarmTime!)
                if task.alarmOnOff {
                    if task.alarmTime! < Date() {
                        alarmOnOffButton.isSelected = false
                    } else {
                        alarmOnOffButton.isSelected = true
                    }
                } else {
                    alarmOnOffButton.isSelected = false
                }
                
            }
            
            // 장소설정 여부에 따른 옵셔널값 처리
            if task.alarmLocation == nil {
                alarmLocationLabel.text = "-"
            } else {
                let place = task.alarmLocation!["placeName"] as! String
                let roadAddress = task.alarmLocation!["roadAddressName"] as! String
                alarmLocationLabel.text = "\(place)(\(roadAddress))"
                if task.alarmOnOff {
                    alarmOnOffButton.isSelected = true
                } else {
                    alarmOnOffButton.isSelected = false
                }
            }
            
            checkDoneButton.isSelected = task.checkDone
        }
    }
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        todoLabel.text = nil
        memoLabel.text = nil
        checkDoneButton.isSelected = false
        alarmOnOffButton.isSelected = false
        alarmTimeLabel.text = nil
        alarmLocationLabel.text = nil
    }
    
}
