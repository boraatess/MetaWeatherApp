//
//  DetailPresenter.swift
//  MetaWeatherApplication
//
//  Created by bora on 16.09.2021.
//

import Foundation

class DetailPresenter: NSObject {
    
    var view: DetailViewProtocol!
    var interactor: DetailInteractorInputProtocol!
    var router: DetailRouterProtocol!
    
    private let cityId: Int
    private var cityDetailResponse: DetailResultModel?
    
    init(cityId: Int) {
        self.cityId = cityId
        super.init()

    }

}

extension DetailPresenter: DetailPresenterProtocol {
    func selectedCityIndex(indexPath: IndexPath) {
        guard let selectedCityID = cityDetailResponse?.woeid else { return }
        router.showCityDetail(withId: selectedCityID)
    }
    
    func viewDidLoad() {
        interactor.fetchSelectedCityDetails(id: cityId)
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func selectedCityDetailResponse(cityDetailResponse: DetailResultModel) {
        self.cityDetailResponse = cityDetailResponse
        view.selectedCityDetail(cityDetail: cityDetailResponse)
    }
    
    func errorResponse(error: Error) {
        view.showError(descriptiom: error.localizedDescription)
    }
    
}
