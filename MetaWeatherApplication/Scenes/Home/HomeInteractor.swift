//
//  HomeInteractor.swift
//  MetaWeatherApplication
//
//  Created by bora on 16.09.2021.
//

import Foundation
import PromiseKit

class HomeInteractor {
    var presenter: HomeInteractorOutputProtocol!
    var searchTimer: Timer?

    private var homeApi: HomeApi
    
    init(homeApi: HomeApi) {
        self.homeApi = homeApi
    }
    
    convenience required init () {
        self.init(homeApi: HomeApi())
    }
}

extension HomeInteractor: HomeInteractorInputProtocol {
    
    func fetchCurrentLocation() {
        let lattitude = SplashViewController.userDefaults.double(forKey: "latt")
        let longitude = SplashViewController.userDefaults.double(forKey: "long")
        
        self.homeApi.fetchCurrentLocationResult(latt: String(lattitude), long: String(longitude)).done {
            [unowned self] response in
            print(response as Any)
            self.presenter.fetchCurrentLocationResponse(response: response ?? [])
        }.catch { [unowned self] error in
            presenter.errorResponse(error: error)
        }
        
    }
    
    func fetchSearchCity(cityName: String) {
        let params = SearchCityRequest(query: cityName)
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            self.searchTimer?.invalidate()
            self.searchTimer = nil
            self.homeApi.fetchSearchedCity(query: params).done { [unowned self] searchResponse in
                self.presenter.searchedCityResponse(response: searchResponse ?? [])
            }.catch { [unowned self] error in
                presenter.errorResponse(error: error)
            }
        })
    }

}
