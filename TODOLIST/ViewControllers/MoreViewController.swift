//
//  MoreViewController.swift
//  TODOLIST
//
//  Created by RAK on 18/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
import UserNotifications

class MoreViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBAction func tappedResetButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "데이터를 초기화 하시겠습니까?", message: "초기화된 데이터는 복구할 수 없습니다.", preferredStyle: .alert)
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
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }))
        alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    @IBAction func tappedQuestionButton(_ sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            present(mailComposeViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "메일 전송에 실패하였습니다.", message: "이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients(["leehrak@gmail.com"])
        mailComposeViewController.setSubject("DailyTODO 문의하기")
        mailComposeViewController.setMessageBody("소중한 의견을 주셔서 감사합니다.", isHTML: false)
        
        return mailComposeViewController
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedDeveloperButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "데일리투두의 개발자", message: "이형락(HYEONGRAK LEE)\nleehrak@gmail.com", preferredStyle: .alert)
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
