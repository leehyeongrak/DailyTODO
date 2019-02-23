//
//  NotificationProcessor.swift
//  TODOLIST
//
//  Created by RAK on 24/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationProcessor {
    class func addTimeNotification(task: TodayTask) {
        let identifire = "\(task.creationTime!)"
        let content = UNMutableNotificationContent()
        if let todoText = task.todoText {
            content.title = "고고"
            content.body = "\(todoText)"
            content.sound = UNNotificationSound.default
        }
        
        let calender = Calendar.current
        
        if let date = task.alarmTime {
            let components = calender.dateComponents([.day, .minute, .hour], from: date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
            
            
            UNUserNotificationCenter.current().add(request) { (error) in
                print(error?.localizedDescription ?? "")
            }
            print("\(identifire)의 알림이 추가되었습니다.")
        } else {
            return
        }
    }
    
    class func removeTimeNotification(task: TodayTask) {
        let identifire = "\(task.creationTime!)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifire])
        print("\(identifire)의 알림이 삭제되었습니다.")
    }
}
