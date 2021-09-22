//
//  SearchResultModel.swift
//  MetaWeatherApplication
//
//  Created by bora on 15.09.2021.
//

import Foundation

// MARK: - SearchResultModelElement
struct ResultModelElement: Codable {
    let title: String?
    let locationType: LocationType?
    let woeid: Int?
    let lattLong: String?

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}

enum LocationType: String, Codable {
    case city = "City"
}

typealias ResultModel = [ResultModelElement]?
