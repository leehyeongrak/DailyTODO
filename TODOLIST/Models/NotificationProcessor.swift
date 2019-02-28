//
//  NotificationProcessor.swift
//  TODOLIST
//
//  Created by RAK on 24/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation

class NotificationProcessor {
    class func addTimeNotification(task: Task) {
        let identifire = "T" + "\(task.classifiedTime!)"
        let content = UNMutableNotificationContent()
        if let todoText = task.todoText {
            content.title = "업무를 수행하실 시간이 됐어요!"
            content.body = "👉\(todoText)"
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
    

    class func removeTimeNotification(task: Task) {
        let identifire = "T" + "\(task.classifiedTime!)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifire])
        print("\(identifire)의 알림이 삭제되었습니다.")
    }
    
    class func addLocationNotification(task: Task) {
        let identifire = "L" + "\(task.classifiedTime!)"
        let content = UNMutableNotificationContent()
        if let todoText = task.todoText {
            content.title = "업무를 수행하실 장소에 왔어요!"
            content.body = "👉\(todoText)"
            content.sound = UNNotificationSound.default
        }
        
        if let location = task.alarmLocation {
            let latitude = Double(location["y"] as! String)!
            let longitude = Double(location["x"] as! String)!
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = CLCircularRegion(center: center, radius: 10.0, identifier: identifire)
            region.notifyOnEntry = true
            region.notifyOnExit = false

            let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
            let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                print(error?.localizedDescription ?? "")
            }
            print("\(identifire)의 알림이 추가되었습니다.")
        } else {
            return
        }
    }
    
    class func removeLocationNofitication(task: Task) {
        let identifire = "L" + "\(task.classifiedTime!)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifire])
        print("\(identifire)의 알림이 삭제되었습니다.")
    }
}
