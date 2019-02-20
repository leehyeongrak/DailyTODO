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
    
    let locationManager = CLLocationManager()
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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
//        move(at: locationManager.location?.coordinate)
//        setupMapView()
    }
    
    func setupMapView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 10.0)
        locationMapView.camera = camera
        locationMapView.isUserInteractionEnabled = false
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
        marker.title = "Delhi"
        marker.snippet = "India’s capital"
        marker.map = locationMapView
    }
    
    func locate(at coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else { return }
        
        print("move = \(coordinate)")
        locationMapView.clear()
        
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14.0)
        locationMapView.camera = camera
        locationMapView.isUserInteractionEnabled = false
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "My Position"
        marker.snippet = "Known"
        marker.map = locationMapView
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension WriteViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {
            return
        }
        
        locate(at: firstLocation.coordinate)
    }
}
