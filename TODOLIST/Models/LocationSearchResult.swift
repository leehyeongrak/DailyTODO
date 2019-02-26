//
//  LocationSearchResult.swift
//  TODOLIST
//
//  Created by RAK on 26/02/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import Foundation

struct LocationSearchResult: Codable {
    var meta: Meta
    var documents: Array<Document>
}

struct Meta: Codable {
    var sameName: SameName
    var pageableCount: Int
    var totalCount: Int
    var isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case sameName = "same_name"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
        case isEnd = "is_end"
    }
}

struct SameName: Codable {
    var region: Array<String>
    var keyword: String
    var selectedRegion: String
    
    enum CodingKeys: String, CodingKey {
        case region
        case keyword
        case selectedRegion = "selected_region"
    }
}

struct Document: Codable {
    var id: String
    var placeName: String
    var categoryName: String
    var categoryGroupCode: String
    var categoryGroupName: String
    var phone: String
    var addressName: String
    var roadAddressName: String
    var x: String
    var y: String
    var placeUrl: String
    var distance: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case placeName = "place_name"
        case categoryName = "category_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case phone
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case x
        case y
        case placeUrl = "place_url"
        case distance
    }
}
