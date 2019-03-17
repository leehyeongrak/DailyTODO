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
import CoreLocation
import NotificationCenter

class ViewController: UIViewController {
    
    // CoreDate 프로퍼티
    let context = CoreDataStack.shared.persistentContainer.viewContext
    
    var tasks: [Task] = []
    var todayTasks: [Task] = []
    var tomorrowTasks: [Task] = []
    
    // UserNotifications 프로퍼티
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]
    
    // CoreLocation 프로퍼티
    let locationManager = CLLocationManager()
    
    // Storyboard 아울렛
    @IBOutlet weak var todayTableView: UITableView!
    @IBOutlet weak var tomorrowTableView: UITableView!
    
    private var selectedRowIndex: IndexPath?
    private var selectedTableIndex: Int?
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    // ViewDidLoad() //////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont(name: "Apple Color Emoji", size: 20)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. EEEE"
        currentTimeLabel.text = dateFormatter.string(from: Date())
        
        center.delegate = self
        center.requestAuthorization(options: options) { (didAllow, error) in
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        setupLocationManager()
        
        todayTableView.delegate = self
        todayTableView.dataSource = self
        tomorrowTableView.delegate = self
        tomorrowTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAndReloadData()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startMonitoringSignificantLocationChanges()
        alwaysAuthorization()
    }
    
    func alwaysAuthorization(){
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func fetchAndReloadData() {
        do {
            tasks = try context.fetch(Task.fetchRequest())
            
            var tempTodays: [Task] = []
            var tempTomorrows: [Task] = []
            
            for task in tasks {
                let date = task.classifiedTime
                let calendar = Calendar.current
                let dateComponent = calendar.dateComponents([.year, .month, .day], from: date!)
                
                let currentDate = Date()
                let currentDateComponent = calendar.dateComponents([.year, .month, .day], from: currentDate)
                
                if dateComponent.year! == currentDateComponent.year! && dateComponent.month! == currentDateComponent.month! && dateComponent.day! == currentDateComponent.day! {
                    tempTodays.append(task)
                } else {
                    let dateTimeInterval = date?.timeIntervalSince1970
                    let currentDateTimeInterval = currentDate.timeIntervalSince1970
                    
                    if dateTimeInterval! > currentDateTimeInterval {
                        tempTomorrows.append(task)
                    }
                }
            }
            todayTasks = tempTodays
            tomorrowTasks = tempTomorrows
        } catch  {
            print("Fetching Failed")
        }
        
        self.todayTableView.reloadData()
        self.tomorrowTableView.reloadData()
    }
    
    @objc func applicationWillEnterForeground() {
        fetchAndReloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WriteViewController {
            vc.delegate = self
        }
    }
}

// Protocols & Extensions //////////////////////////////////////////////////
protocol AddTaskDelegate {
    func addTask(task: Task)
}

extension ViewController: AddTaskDelegate {
    func addTask(task: Task) {
        fetchAndReloadData()
        
        if task.alarmTime != nil {
            NotificationProcessor.addTimeNotification(task: task)
        }
        
        if task.alarmLocation != nil {
            NotificationProcessor.addLocationNotification(task: task)
        }
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
        let context = CoreDataStack.shared.persistentContainer.viewContext
        if editingStyle == .delete {
            
            if tableView == todayTableView {
                let task = todayTasks[indexPath.row]
                if task.alarmTime != nil {
                    NotificationProcessor.removeTimeNotification(task: task)
                }
                if task.alarmLocation != nil {
                    NotificationProcessor.removeTimeNotification(task: task)
                }
                context.delete(task)
                CoreDataStack.shared.saveContext()
            } else if tableView == tomorrowTableView {
                let task = tomorrowTasks[indexPath.row]
                context.delete(task)
                CoreDataStack.shared.saveContext()
            }
            fetchAndReloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let index = selectedRowIndex {
            if index == indexPath {
                return 115
            }
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case todayTableView:
            return todayTasks.count
        default:
            return tomorrowTasks.count
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
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TomorrowCell", for: indexPath) as? TomorrowTableViewCell else {
                return UITableViewCell()
            }
            let task = tomorrowTasks[indexPath.row]
            cell.task = task
            
            return cell
        }
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    // Foreground notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

extension ViewController: CLLocationManagerDelegate {
}

