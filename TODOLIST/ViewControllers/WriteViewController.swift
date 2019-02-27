//
//  WriteViewController.swift
//  TODOLIST
//
//  Created by RAK on 20/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class WriteViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: AddTaskDelegate?
    
    var isToday: Bool! {
        didSet {
            todayButton.isSelected = isToday
            tomorrowButton.isSelected = !isToday
        }
    }
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var tomorrowButton: UIButton!
    
    @IBAction func tappedTodayButton(_ sender: UIButton) {
        isToday = true
    }
    @IBAction func tappedTomorrowButton(_ sender: UIButton) {
        isToday = false
    }
    
    @IBOutlet weak var todoTextField: UITextField!
    
    @IBOutlet weak var memoTextField: UITextField!
    
    // Time Alarm Setting ---------------------------------------
    @IBOutlet weak var timeSettingButton: UIButton!
    
    @IBAction func tappedTimeSettingButton(_ sender: UIButton) {
        timeSettingButton.isSelected = !timeSettingButton.isSelected
        
    }
    
    @IBOutlet weak var timePicker: UIDatePicker!
    // ----------------------------------------------------------
    
    // Location Alarm Setting -----------------------------------
    @IBOutlet weak var locationSettingButton: UIButton!
    
    @IBAction func tappedLocationSettingButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }
    }
    
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet var locationMapView: MKMapView!
    
    var selectedLocation: Location?
    // ----------------------------------------------------------
    
    @IBAction func tappedWriteButton(_ sender: UIButton) {
        if todoTextField.text == "" {
            let alert = UIAlertController(title: nil, message: "할 일을 입력해주세요✍🏻", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if isToday {
            let task = TodayTask(context: context)
            task.todoText = todoTextField.text
            task.memoText = memoTextField.text
            task.creationTime = Date()
            
            if timeSettingButton.state == .selected {
                task.alarmOnOff = true
                task.alarmTime = timePicker.date
            }
            
            if locationSettingButton.state == .selected {
                task.alarmOnOff = true
                task.alarmLocation = selectedLocation?.nsDictionary
            }
            
            if timeSettingButton.state == .normal && locationSettingButton.state == .normal {
                task.alarmOnOff = false
            }
            
            task.checkDone = false
        } else {
            let alert = UIAlertController(title: nil, message: "미구현단계", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

        self.dismiss(animated: true, completion: nil)
        self.delegate?.addTask()
    }
    
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isToday = true
        
        todoTextField.delegate = self
        memoTextField.delegate = self
        
        locationMapView.isUserInteractionEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let button = sender as? UIButton else { return false }
        if button.isSelected {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MapViewController {
            vc.delegate = self
        }
    }
}

protocol SetLocationDelegate {
    func setLocation(location: Location)
}

extension WriteViewController: SetLocationDelegate {
    func setLocation(location: Location) {
        self.locationSettingButton.isSelected = true
        
        self.selectedLocation = location
        
        self.placeNameLabel.text = location.placeName
        self.addressNameLabel.text = location.roadAddressName
        
        let latitude = Double(location.y)
        let longitude = Double(location.x)
        let location = CLLocationCoordinate2DMake(latitude!, longitude!)
        let viewRegion = MKCoordinateRegion(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
        self.locationMapView.setRegion(viewRegion, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.locationMapView.addAnnotation(annotation)
    }
}
