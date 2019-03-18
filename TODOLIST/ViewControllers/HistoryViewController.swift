//
//  HistoryViewController.swift
//  TODOLIST
//
//  Created by RAK on 18/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData
import NotificationCenter

class HistoryViewController: UIViewController {
    
    let context = CoreDataStack.shared.persistentContainer.viewContext
    var tasks: [Task] = []
    var todayTasks: [Task] = []
    var selectedTasks: [Task] = []
    var currentTasks: [Task] = []
    
    @IBOutlet var selectedDateLabel: UILabel!
    @IBOutlet var taskCountLabel: UILabel!
    @IBOutlet var calendarView: FSCalendar!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont(name: "Apple Color Emoji", size: 20)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAndReloadData()
    }
    
    func setupOutlets() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. M. dd. EEEE"
        selectedDateLabel.text = dateFormatter.string(from: Date())
        
        let tasksCount = selectedTasks.count
        let checkedDoneTasksCount = selectedTasks.filter { (task) -> Bool in
            task.checkDone
            }.count
        taskCountLabel.text = "\(checkedDoneTasksCount)/\(tasksCount)"
        
        if tasksCount == 0 {
            taskCountLabel.backgroundColor = .white
        } else {
            if checkedDoneTasksCount == 0 {
                taskCountLabel.backgroundColor = UIColor(r: 195, g: 33, b: 32, a: 255)
            } else if checkedDoneTasksCount == tasksCount {
                taskCountLabel.backgroundColor = UIColor(r: 130, g: 183, b: 49, a: 255)
            } else {
                taskCountLabel.backgroundColor = UIColor(r: 40, g: 127, b: 194, a: 255)
            }
        }
    }
    
    func fetchAndReloadData() {
        calendarView.select(Date())
        
        do {
            tasks = try context.fetch(Task.fetchRequest())
            todayTasks = tasks.filter({ (task) -> Bool in
                let calendar = Calendar.current
                
                let date = task.classifiedTime
                let dateComponent = calendar.dateComponents([.year, .month, .day], from: date!)
                
                let currentDate = Date()
                let currentDateComponent = calendar.dateComponents([.year, .month, .day], from: currentDate)
                
                if dateComponent.year! == currentDateComponent.year! && dateComponent.month! == currentDateComponent.month! && dateComponent.day! == currentDateComponent.day! {
                    return true
                } else {
                    return false
                }
            })
        } catch {
            print("Fetching Failed")
        }
        
        selectedTasks = todayTasks
        setupOutlets()
        
        calendarView.reloadData()
        tableView.reloadData()
    }
    
    @objc func applicationWillEnterForeground() {
        fetchAndReloadData()
        selectedTasks = todayTasks
        setupOutlets()
    }
}

extension HistoryViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let currentCalendar = Calendar.current
        let dateComponents = currentCalendar.dateComponents([.year, .month, .day], from: date)
        
        let tasksForCell = tasks.filter { (task) -> Bool in
            let taskDateComponents = currentCalendar.dateComponents([.year, .month, .day], from: task.classifiedTime!)
            if taskDateComponents.month == dateComponents.month && taskDateComponents.year == dateComponents.year && taskDateComponents.day == dateComponents.day {
                return true
            } else {
                return false
            }
        }
        
        let tasksCount = tasksForCell.count
        let doneTasksCount = tasksForCell.filter { (task) -> Bool in
            task.checkDone
            }.count
        
        if tasksCount == 0 {
            return ""
        } else {
            if doneTasksCount == 0 {
                return "📕"
            } else if doneTasksCount == tasksCount {
                return "📗"
            } else {
                return "📘"
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedTasks = tasks.filter({ (task) -> Bool in
            let currentCalendar = Calendar.current
            let selectedDate = task.classifiedTime
            let selectedDateComponents = currentCalendar.dateComponents([.year, .month, .day], from: selectedDate!)
            
            let dateComponents = currentCalendar.dateComponents([.year, .month, .day], from: date)
            
            if selectedDateComponents.year == dateComponents.year && selectedDateComponents.month == dateComponents.month && selectedDateComponents.day == dateComponents.day {
                return true
            } else { return false }
        })
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. M. dd. EEEE"
        selectedDateLabel.text = dateFormatter.string(from: date)
        let tasksCount = selectedTasks.count
        let checkedDoneTasksCount = selectedTasks.filter { (task) -> Bool in
            task.checkDone
        }.count
        
        if tasksCount == 0 {
            taskCountLabel.backgroundColor = .white
        } else {
            if checkedDoneTasksCount == 0 {
                taskCountLabel.backgroundColor = UIColor(r: 195, g: 33, b: 32, a: 255)
            } else if checkedDoneTasksCount == tasksCount {
                taskCountLabel.backgroundColor = UIColor(r: 130, g: 183, b: 49, a: 255)
            } else {
                taskCountLabel.backgroundColor = UIColor(r: 40, g: 127, b: 194, a: 255)
            }
        }
        
        taskCountLabel.text = "\(checkedDoneTasksCount)/\(tasksCount)"
        tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }
        let task = selectedTasks[indexPath.row]
        cell.taskLabel.text = task.todoText
        cell.checkDoneButton.isSelected = task.checkDone
        return cell
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a/255)
    }
}
