//
//  ViewController.swift
//  TODOLIST
//
//  Created by RAK on 18/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todayTasks: [TodayTask] = []
    var tomorrowTasks: [TomorrowTask] = []
    
    @IBOutlet weak var todayTableView: UITableView!
    @IBOutlet weak var tomorrowTableView: UITableView!
    
    private var selectedRowIndex: IndexPath?
    private var selectedTableIndex: Int?
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        reloadDataWithGettingData()
    }
    
    func reloadDataWithGettingData() {
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
            reloadDataWithGettingData()
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
            
            if let todoText = task.todoText, let memoText = task.memoText, let alarmTime = task.alarmTime {
                cell.todoLabel.text = todoText
                cell.memoLabel.text = memoText
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm a"
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                cell.alarmTimeLabel.text = dateFormatter.string(from: alarmTime)

                if task.alarmOnOff {
                    cell.alarmOnOffButton.backgroundColor = .yellow
                } else {
                    cell.alarmOnOffButton.backgroundColor = .white
                }
                
                if task.checkDone {
                    cell.checkDoneButton.backgroundColor = .blue
                } else {
                    cell.checkDoneButton.backgroundColor = .white
                }
                
                
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
            print("성공")
        }
        print("실패")
        
    }
}

class TodayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var checkDoneButton: UIButton!
    @IBOutlet weak var alarmOnOffButton: UIButton!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
}

class TomorrowTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
}

protocol NotifyWritingDelegate {
    func notifyWriting()
}

extension ViewController: NotifyWritingDelegate {
    func notifyWriting() {
        reloadDataWithGettingData()
    }
}

extension UIColor {
    class var whiteGray: UIColor {
        get {
            return UIColor(red: 200, green: 200, blue: 200, alpha: 1)
        }
    }
}
