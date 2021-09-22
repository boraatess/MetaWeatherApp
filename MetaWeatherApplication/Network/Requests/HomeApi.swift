//
//  HomeApi.swift
//  MetaWeatherApplication
//
//  Created by bora on 17.09.2021.
//

import Foundation
import PromiseKit

class HomeApi {
    
    private let api = BaseApi()
    
    func fetchCurrentLocationResult(latt: String, long: String) -> Promise<ResultModel> {
        return api.get(url: "search?lattlong="+latt+","+long, parameters: nil)
    }
    
    func fetchSearchedCity(query : SearchCityRequest) -> Promise<ResultModel> {
        return api.get(url: "search?query=", parameters: query.dictionary)
    }
    
}
