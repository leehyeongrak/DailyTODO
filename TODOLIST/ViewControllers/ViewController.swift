//
//  ViewController.swift
//  TODOLIST
//
//  Created by RAK on 18/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {
    
    // CoreDate 프로퍼티
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todayTasks: [TodayTask] = []
    var tomorrowTasks: [TomorrowTask] = []
    
    // UserNotifications 프로퍼티
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]
    
    // Storyboard 아울렛
    @IBOutlet weak var todayTableView: UITableView!
    @IBOutlet weak var tomorrowTableView: UITableView!
    
    private var selectedRowIndex: IndexPath?
    private var selectedTableIndex: Int?
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    // ViewDidLoad() //////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        center.requestAuthorization(options: options) { (didAllow, error) in
            print(didAllow)
        }
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        todayTableView.delegate = self
        todayTableView.dataSource = self
        tomorrowTableView.delegate = self
        tomorrowTableView.dataSource = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. EEEE"
        currentTimeLabel.text = dateFormatter.string(from: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAndReloadData()
        
    }
    
    func fetchAndReloadData() {
        do {
            todayTasks = try context.fetch(TodayTask.fetchRequest())
        } catch  {
            print("Fetching Failed")
        }
        
        self.todayTableView.reloadData()
        self.tomorrowTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == selectedRowIndex {
            selectedRowIndex = nil
        } else {
            selectedRowIndex = indexPath
        }
        
        switch tableView {
        case todayTableView:
            selectedTableIndex = 0
            todayTableView.beginUpdates()
            todayTableView.endUpdates()
        default:
            selectedTableIndex = 1
            tomorrowTableView.beginUpdates()
            tomorrowTableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == todayTableView {
                let task = todayTasks[indexPath.row]
                context.delete(task)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            } else if tableView == tomorrowTableView {
                print("미구현단계입니다")
            }
            fetchAndReloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let index = selectedRowIndex {
            if index == indexPath {
                return 150
            }
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case todayTableView:
            return todayTasks.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case todayTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodayCell", for: indexPath) as? TodayTableViewCell else {
                return UITableViewCell()
            }
            let task = todayTasks[indexPath.row]
            
            cell.task = task
            
            if let todoText = task.todoText, let memoText = task.memoText {
                
                cell.todoLabel.text = todoText
                cell.memoLabel.text = memoText
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm a"
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                
                // 시간설정 여부에 따른 옵셔널값 처리
                if task.alarmTime == nil {
                    cell.alarmTimeLabel.text = "설정되지 않았습니다"
                } else {
                    cell.alarmTimeLabel.text = dateFormatter.string(from: task.alarmTime!)
                    if task.alarmTime! <= Date() {
                        cell.alarmOnOffButton.setTitle("🔕", for: .normal)
                    } else {
                        if task.alarmOnOff {
                            NotificationProcessor.addTimeNotification(task: task)
                            cell.alarmOnOffButton.setTitle("🔔", for: .normal)
                        } else {
                            cell.alarmOnOffButton.setTitle("🔕", for: .normal)
                        }
                    }
                }
                
                if task.checkDone {
                    cell.checkDoneButton.setTitle("✅", for: .normal)
                } else {
                    cell.checkDoneButton.setTitle("✔️", for: .normal)
                }
                
                cell.alarmLocationLabel.text = "설정되지 않았습니다."
            }
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TomorrowCell", for: indexPath) as? TomorrowTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WriteViewController {
            vc.delegate = self
        }
    }
}

// Custom Cells //////////////////////////////////////////////////
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
            checkDoneButton.setTitle("✔️", for: .normal)
        } else {
            checkDoneButton.setTitle("✅", for: .normal)
        }
        
        task?.checkDone = !((task?.checkDone)!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    @IBAction func tappedAlarmOnOffButton(_ sender: UIButton) {
        
        if task?.alarmTime == nil {
            return
        } else {
            if (task?.alarmTime)! <= Date() {
                return
            }
        }
        
        if task!.alarmOnOff {
            NotificationProcessor.removeTimeNotification(task: task!)
            alarmOnOffButton.setTitle("🔕", for: .normal)
        } else {
            NotificationProcessor.addTimeNotification(task: task!)
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
}

class TomorrowTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
}

// Protocols & Extensions //////////////////////////////////////////////////
protocol AddTaskDelegate {
    func addTask()
}

extension ViewController: AddTaskDelegate {
    func addTask() {
        fetchAndReloadData()
    }
}

