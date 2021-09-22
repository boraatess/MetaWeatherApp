//
//  DetailProtocols.swift
//  MetaWeatherApplication
//
//  Created by bora on 16.09.2021.
//

import UIKit

//MARK: Router
protocol DetailRouterProtocol: class {
    func showCityDetail(withId: Int)
}

//MARK: Presenter
protocol DetailPresenterProtocol: class {
    var interactor: DetailInteractorInputProtocol! { get set }
    func viewDidLoad()
    func selectedCityIndex(indexPath: IndexPath)
}

//MARK: Interactor

// Interactor -> Presenter
protocol DetailInteractorOutputProtocol: class {
    func selectedCityDetailResponse(cityDetailResponse: DetailResultModel)
    func errorResponse(error: Error)
}

// Presenter -> Interactor
protocol DetailInteractorInputProtocol: class {
    var presenter: DetailInteractorOutputProtocol! { get set }
    func fetchSelectedCityDetails(id: Int)
}

//MARK: View
protocol DetailViewProtocol: class {
    var presenter: DetailPresenterProtocol! { get set }
    func selectedCityDetail(cityDetail: DetailResultModel)
    func showError(descriptiom: String)
}
