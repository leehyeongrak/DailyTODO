//
//  ViewController.swift
//  TODOLIST
//
//  Created by RAK on 18/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var todayTableView: UITableView!
    @IBOutlet weak var tomorrowTableView: UITableView!
    
    private var selectedRowIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayTableView.delegate = self
        todayTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == selectedRowIndex {
            selectedRowIndex = nil
        } else {
            selectedRowIndex = indexPath
        }
        
        todayTableView.beginUpdates()
        todayTableView.endUpdates()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let index = selectedRowIndex {
            if index == indexPath {
                return 200
            }
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayCell", for: indexPath)
        
        return cell
    }


}

class TodayTableViewCell: UITableViewCell {
    
}
