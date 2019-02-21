//
//  WriteViewController.swift
//  TODOLIST
//
//  Created by RAK on 20/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class WriteViewController: UIViewController, UITextFieldDelegate {
    
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
    
    @IBOutlet weak var locationMapView: GMSMapView!
    @IBOutlet weak var locationLabel: UILabel!
    
    var placesClient: GMSPlacesClient!
    
//    let locationManager = CLLocationManager()
    // ----------------------------------------------------------
    
    @IBAction func tappedWriteButton(_ sender: UIButton) {
    }
    
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isToday = true
        
        todoTextField.delegate = self
        memoTextField.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        getCurrentPlace()
    }

    func getCurrentPlace() {    
        placesClient.currentPlace { (placeLikelihoodList, error) in
            if error != nil {
                print("==================ERROR================")
                print(error)
                print("=======================================")
                return
            }
            
            self.locationLabel.text = "No current place"
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.locationLabel.text = place.name
                    print("=======================================")
                    print(place)
                    print("=======================================")
                    
                    let latitude = place.coordinate.latitude
                    let longitude = place.coordinate.longitude
                    let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14.0)
                    self.locationMapView.camera = camera
                    
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    marker.title = place.name
                    marker.snippet = place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n")
                    marker.map = self.locationMapView
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
