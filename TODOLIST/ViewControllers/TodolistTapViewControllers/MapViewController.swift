//
//  MapViewController.swift
//  TODOLIST
//
//  Created by RAK on 25/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, MTMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: SetLocationDelegate?
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    var searchResult: LocationSearchResult?
    var selectedLocation: Location?
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var resultPlaceNameLabel: UILabel!
    @IBOutlet var resultAddressNameLabel: UILabel!
    @IBOutlet var resultMapView: MTMapView!
    @IBOutlet var resultsTableView: UITableView!
    
    @IBAction func tappedClosedButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedSetButton(_ sender: UIButton) {
        if selectedLocation != nil {
            self.delegate?.setLocation(location: selectedLocation!)
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: nil, message: "장소를 선택해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultMapView.delegate = self
        
        resultPlaceNameLabel.text = "장소를 검색해주세요!"
        resultAddressNameLabel.text = "설정된 장소를 지날 때 알림을 드립니다."
        
        var panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler))
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 200 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    func setupMapView(lattitude: String, longitude: String) {
        resultMapView.baseMapType = .standard
        guard let latitude = Double(lattitude), let longitude = Double(longitude) else { return }
        resultMapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude)), zoomLevel: 1, animated: true)
        
        let marker = MTMapPOIItem()
        marker.markerType = .redPin
        marker.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
        resultMapView.addPOIItems([marker])
    }
    
    func searchLocation(inputText: String, completion: @escaping (LocationSearchResult) -> ()) {
        let baseURL = "https://dapi.kakao.com/v2/local/search/keyword.json?query=\(inputText)"
        let searchURL = baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: searchURL!) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK 33bbf7d7a5dbc781d5e2c3aa46c21ea6", forHTTPHeaderField: "Authorization")
        
        DispatchQueue.global().async {
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return
                }
                guard let searchData = String(data: data!, encoding: .utf8) else {
                    return
                }
                
                if let jsonData = searchData.data(using: .utf8) {
                    let result = try! JSONDecoder().decode(LocationSearchResult.self, from: jsonData)
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            }
            task.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let result = searchResult {
            return result.documents.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        cell.textLabel?.text = searchResult?.documents[indexPath.row].placeName
        cell.detailTextLabel?.text = searchResult?.documents[indexPath.row].addressName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let document = searchResult?.documents[indexPath.row] else { return }
        selectedLocation = Location(place: document.placeName, address: document.addressName, x: document.x, y: document.y)
        
        setupMapView(lattitude: (selectedLocation?.y)!, longitude: (selectedLocation?.x)!)
        resultPlaceNameLabel.text = selectedLocation?.placeName
        resultAddressNameLabel.text = selectedLocation?.roadAddressName
        resultsTableView.isHidden = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            resultsTableView.isHidden = false
            searchLocation(inputText: text) { (result) in
                self.searchResult = result
                self.resultsTableView.reloadData()
            }
        }
        
        self.view.endEditing(true)
        return true
    }
}
