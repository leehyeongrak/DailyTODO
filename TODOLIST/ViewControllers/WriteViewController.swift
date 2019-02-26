//
//  WriteViewController.swift
//  TODOLIST
//
//  Created by RAK on 20/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import CoreData

class WriteViewController: UIViewController, UITextFieldDelegate, MTMapViewDelegate {
    
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
        timeSettingButton.setTitle("설정■", for: .selected)
        timeSettingButton.isSelected = !timeSettingButton.isSelected
        
    }
    
    @IBOutlet weak var timePicker: UIDatePicker!
    // ----------------------------------------------------------
    
    // Location Alarm Setting -----------------------------------
    @IBOutlet weak var locationSettingButton: UIButton!
    
    @IBAction func tappedLocationSettingButton(_ sender: UIButton) {
        locationSettingButton.setTitle("설정■", for: .selected)
        locationSettingButton.isSelected = !locationSettingButton.isSelected
    }
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet var locationMapView: MTMapView!
    
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
            } else {
                task.alarmOnOff = false
                task.alarmTime = nil
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
        
        locationMapView.delegate = self
        setupMapView()
        
        todoTextField.delegate = self
        memoTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setupMapView() {
        locationMapView.baseMapType = .standard
        DispatchQueue.global().async {
            self.locationMapView.currentLocationTrackingMode = MTMapCurrentLocationTrackingMode.onWithoutHeading
        }
        print("SetupMapView")
    }
    
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        if let address = MTMapReverseGeoCoder.findAddress(for: location, withOpenAPIKey: "d9a4fa482d1ff0ad685736ffd7c9bb2a") {
            self.locationLabel.text = address
            locationMapView.currentLocationTrackingMode = MTMapCurrentLocationTrackingMode.off
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MapViewController {
            vc.currentCoordinate = locationMapView.mapCenterPoint.mapPointGeo()
            vc.currentAddress = locationLabel.text
            vc.delegate = self
        }
    }
}

protocol SetLocationDelegate {
    func setLocation(location: Location)
}

extension WriteViewController: SetLocationDelegate {
    func setLocation(location: Location) {
        selectedLocation = location
        
        locationLabel.text = selectedLocation?.roadAddressName
        
        
        guard let latitude = Double(selectedLocation!.y), let longitude = Double(selectedLocation!.x) else { return }
        print(latitude)
        print(longitude)
        locationMapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude)), animated: true)
        print(locationMapView.mapCenterPoint)
    }
}
