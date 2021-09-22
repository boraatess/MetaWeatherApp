//
//  HomeRouter.swift
//  MetaWeatherApplication
//
//  Created by bora on 15.09.2021.
//

import UIKit

class HomeRouter {
    
    internal var controller: HomeViewController!
    internal var presenter: HomePresenter!
    internal var interactor: HomeInteractor!
    
    init() {
        interactor = HomeInteractor()
        presenter = HomePresenter()
        controller = HomeViewController()
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.router = self
        presenter.view = controller
        controller.presenter = presenter
    }
    
}

extension HomeRouter: HomeRouterProtocol {
    func showDetail(withId: Int) {
        guard let vc = DetailRouter(cityId: withId).controller  else { return }
        controller.show(vc, sender: nil)
    }

}
