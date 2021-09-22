//
//  DetailApi.swift
//  MetaWeatherApplication
//
//  Created by bora on 18.09.2021.
//

import Foundation
import PromiseKit

class DetailApi {
    
    private var baseApi = BaseApi()

    func fetchCityDetailResult(id: String) -> Promise<DetailResultModel> {
        return baseApi.get(url: id+"/", parameters: nil)
    }
    
}
