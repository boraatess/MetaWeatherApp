//
//  HomePresenter.swift
//  MetaWeatherApplication
//
//  Created by bora on 16.09.2021.
//

import Foundation

class HomePresenter: NSObject {
    
    var view: HomeViewProtocol!
    var interactor: HomeInteractorInputProtocol!
    var router: HomeRouterProtocol!
  
    private var currentLocationResponse: [ResultModelElement]?
    private var searchedCityResponse: [ResultModelElement]?
}

extension HomePresenter: HomePresenterProtocol {
    func selectedNearLocationCityIndex(index: IndexPath) {
        guard let cityId = currentLocationResponse?[index.row].woeid else { return }
        router.showDetail(withId: cityId)
    }
    
    func selectedSearchedCityIndex(index: IndexPath) {
        guard let cityId = searchedCityResponse?[index.row].woeid else { return }
        router.showDetail(withId: cityId)
    }
    
    func showMovieDetail(withId: Int) {
        router.showDetail(withId: withId)
    }
    
    func viewDidLoad() {
        interactor.fetchCurrentLocation()
    }
    func searchedCity(cityName: String) {
        cityName.count > 2 ? interactor.fetchSearchCity(cityName: cityName) :
            view.searchedCityResponse(response: [])
    }
   
}

extension HomePresenter: HomeInteractorOutputProtocol {
    func searchedCityResponse(response: [ResultModelElement]) {
        let searchresults = response
        self.searchedCityResponse = response
        view.searchedCityResponse(response: searchresults)
    }
    
    func errorResponse(error: Error) {
        view.showError(descriptiom: error.localizedDescription)
    }
    
    func fetchCurrentLocationResponse(response: [ResultModelElement]) {
        let currentLocationResults = response
        self.currentLocationResponse = currentLocationResults
        view.fetchCurrentLocation(response: currentLocationResults)
        
    }
    
    func searchedMovieResponse(response: [ResultModelElement]) {
        let results = response
        self.searchedCityResponse = response
        view.searchedCityResponse(response: results)
    }
    
}
