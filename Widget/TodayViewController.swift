//
//  TodayViewController.swift
//  Widget
//
//  Created by RAK on 01/03/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding {
    let context = CoreDataStack.shared.persistentContainer.viewContext
    let container = PersistentContainer(name: "TODOLIST")
    
    var tasks: [Task] = []
    var todayTasks: [Task] = []
    
    @IBOutlet weak var widgetTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        widgetTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openApp)))
        fetchData()
        
        widgetTableView.delegate = self
        widgetTableView.dataSource = self
    }
    
    @objc func openApp() {
        let myAppUrl = NSURL(string: "DailyTODO://")!
        extensionContext?.open(myAppUrl as URL, completionHandler: { (success) in
            if (!success) {
                print("error")
            }
        })
    }
    
    func fetchData() {
        do {
            tasks = try context.fetch(Task.fetchRequest())
            
            var tempTodays: [Task] = []
            
            for task in tasks {
                let date = task.classifiedTime
                let calendar = Calendar.current
                let dateComponent = calendar.dateComponents([.year, .month, .day], from: date!)
                
                let currentDate = Date()
                let currentDateComponent = calendar.dateComponents([.year, .month, .day], from: currentDate)
                
                if dateComponent.year! == currentDateComponent.year! && dateComponent.month! == currentDateComponent.month! && dateComponent.day! == currentDateComponent.day! {
                    tempTodays.append(task)
                }
            }
            todayTasks = tempTodays
        } catch  {
            print("Fetching Failed")
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: maxSize.width, height: CGFloat(45 * todayTasks.count))
        }else if activeDisplayMode == .compact{
            self.preferredContentSize = CGSize(width: maxSize.width, height: 100)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

class WidgetTableViewCell: UITableViewCell {
    
    var task: Task? {
        didSet {
            matchData()
        }
    }
    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var alarmOnOffButton: UIButton!
    @IBOutlet weak var checkDoneButton: UIButton!
   
    @IBAction func tappedCheckDoneButton(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.1,
//                       animations: {
//                        self.checkDoneButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        },
//                       completion: { _ in
//                        UIView.animate(withDuration: 0.1) {
//                            self.checkDoneButton.transform = CGAffineTransform.identity
//                        }
//        })
//
//        checkDoneButton.isSelected = !checkDoneButton.isSelected
//        task?.checkDone = !((task?.checkDone)!)
//        CoreDataStack.shared.saveContext()
    }
    
    @IBAction func tappedAlarmOnOffButton(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.1,
//                       animations: {
//                        self.alarmOnOffButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        },
//                       completion: { _ in
//                        UIView.animate(withDuration: 0.1) {
//                            self.alarmOnOffButton.transform = CGAffineTransform.identity
//                        }
//        })
//
//        if task?.alarmTime == nil && task?.alarmLocation == nil {
//            return
//        }
//
//        if task!.alarmOnOff {
//            if task?.alarmTime != nil {
//                NotificationProcessor.removeTimeNotification(task: task!)
//            }
//            if task?.alarmLocation != nil {
//                NotificationProcessor.removeTimeNotification(task: task!)
//            }
//            alarmOnOffButton.isSelected = false
//        } else {
//            if task?.alarmTime != nil {
//                NotificationProcessor.addTimeNotification(task: task!)
//            }
//            if task?.alarmLocation != nil {
//                NotificationProcessor.addLocationNotification(task: task!)
//            }
//            alarmOnOffButton.isSelected = true
//        }
//
//        task?.alarmOnOff = !((task?.alarmOnOff)!)
//        CoreDataStack.shared.saveContext()
    }
    
    func matchData() {
        guard let task = self.task else { return }
        
        todoLabel.text = task.todoText
        alarmOnOffButton.isSelected = task.alarmOnOff
        checkDoneButton.isSelected = task.checkDone
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        todoLabel.text = nil
        checkDoneButton.isSelected = false
        alarmOnOffButton.isSelected = false
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetCell", for: indexPath) as? WidgetTableViewCell else {
            return UITableViewCell()
        }
        
        let task = todayTasks[indexPath.row]
        cell.task = task
        
        return cell
    }
    
}
