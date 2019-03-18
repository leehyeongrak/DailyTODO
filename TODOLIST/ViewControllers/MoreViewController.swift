//
//  MoreViewController.swift
//  TODOLIST
//
//  Created by RAK on 18/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import CoreData

class MoreViewController: UIViewController {
    
    @IBAction func tappedResetButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "데이터를 초기화 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .default, handler: { (action) in
            let context = CoreDataStack.shared.persistentContainer.viewContext
            
            do {
                let tasks = try context.fetch(Task.fetchRequest())
                for task in tasks {
                    guard let objectData = task as? NSManagedObject else { return }
                    context.delete(objectData)
                }
            } catch let error {
                print(error)
            }
            CoreDataStack.shared.saveContext()
        }))
        alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    @IBAction func tappedQuestionButton(_ sender: UIButton) {
    }
    
    @IBAction func tappedDeveloperButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "HYEONGRAK LEE🇰🇷", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont(name: "Apple Color Emoji", size: 20)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Do any additional setup after loading the view.
    }
}
