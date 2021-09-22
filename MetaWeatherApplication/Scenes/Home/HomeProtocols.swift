//
//  HomeProtocols.swift
//  MetaWeatherApplication
//
//  Created by bora on 16.09.2021.
//

import UIKit

//MARK: Router
protocol HomeRouterProtocol: class {
    func showDetail(withId: Int)
}

//MARK: Presenter
protocol HomePresenterProtocol: class {
    var interactor: HomeInteractorInputProtocol! { get set }
    func searchedCity(cityName: String)
    func viewDidLoad()
    func selectedNearLocationCityIndex(index: IndexPath)
    func selectedSearchedCityIndex(index: IndexPath)
}

//MARK: Interactor

// Interactor -> Presenter
protocol HomeInteractorOutputProtocol: class {
    func fetchCurrentLocationResponse(response: [ResultModelElement])
    func searchedCityResponse(response: [ResultModelElement])
    func errorResponse(error: Error)
}

// Presenter -> Interactor
protocol HomeInteractorInputProtocol: class {
    var presenter: HomeInteractorOutputProtocol! { get set }
    func fetchCurrentLocation()
    func fetchSearchCity(cityName: String)
}

//MARK: View
protocol HomeViewProtocol: class {
    var presenter: HomePresenterProtocol! { get set }
    func fetchCurrentLocation(response: [ResultModelElement])
    func searchedCityResponse(response: [ResultModelElement])
    func showError(descriptiom: String)
}
