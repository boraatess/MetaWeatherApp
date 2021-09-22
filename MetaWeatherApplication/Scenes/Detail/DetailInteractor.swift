//
//  DetailInteractor.swift
//  MetaWeatherApplication
//
//  Created by bora on 16.09.2021.
//

import Foundation
import PromiseKit

class DetailInteractor {
    var presenter: DetailInteractorOutputProtocol!
    private let detailApi: DetailApi

    init(detailApi: DetailApi) {
        self.detailApi = detailApi
    }
    
    convenience required init () {
        self.init(detailApi: DetailApi())
    }
}

extension DetailInteractor: DetailInteractorInputProtocol {
    func fetchSelectedCityDetails(id: Int) {
        detailApi.fetchCityDetailResult(id: String(id)).done { [unowned self] response in
            presenter.selectedCityDetailResponse(cityDetailResponse: response)
        }.catch { [unowned self] error in
            presenter.errorResponse(error: error)
        }
    }
    
}
