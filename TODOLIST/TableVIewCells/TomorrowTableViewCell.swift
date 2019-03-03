//
//  TomorrowTableViewCell.swift
//  TODOLIST
//
//  Created by RAK on 27/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class TomorrowTableViewCell: UITableViewCell {
    
    var task: Task? {
        didSet {
            matchData()
        }
    }
    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var alarmOnOffButton: UIButton!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var alarmLocationLabel: UILabel!
    
    @IBAction func tappedAlarmOnOffButton(_ sender: UIButton) {
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
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        todoLabel.text = nil
        memoLabel.text = nil
        alarmOnOffButton.isSelected = false
        alarmTimeLabel.text = nil
        alarmLocationLabel.text = nil
    }
    
}
