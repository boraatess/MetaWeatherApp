//
//  DetailRouter.swift
//  MetaWeatherApplication
//
//  Created by bora on 15.09.2021.
//

import UIKit

class DetailRouter {
    
    internal var controller: DetailViewController!
    internal var presenter: DetailPresenter!
    internal var interactor: DetailInteractor!
    
    init(cityId: Int) {
        interactor = DetailInteractor()
        presenter = DetailPresenter(cityId: cityId)
        controller = DetailViewController()
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.router = self
        presenter.view = controller
        controller.presenter = presenter
    }
}

extension DetailRouter: DetailRouterProtocol {
    func showCityDetail(withId: Int) {
        guard let vc = DetailRouter(cityId: withId).controller else { return }
        controller.show(vc, sender: nil)
    }
    
}
