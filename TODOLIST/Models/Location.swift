//
//  Location.swift
//  TODOLIST
//
//  Created by RAK on 26/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import Foundation

struct Location {
    var placeName: String
    var roadAddressName: String
    var x: String
    var y: String
    var dictionary: [String: Any] {
        return ["placeName": placeName,
        "roadAddressName": roadAddressName,
        "x": x,
        "y": y]
    }
    
    init(place: String, address: String, x: String, y: String) {
        self.placeName = place
        self.roadAddressName = address
        self.x = x
        self.y = y
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}
