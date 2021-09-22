//
//  HomeViewController.swift
//  MetaWeatherApplication
//
//  Created by bora on 15.09.2021.
//

import UIKit
import CoreLocation
import SnapKit
import Kingfisher

class HomeViewController: UIViewController {
    
    let screen = UIScreen.main.bounds
    private var locationResults: [ResultModelElement]?
    private var searchResults: [ResultModelElement]? = []
    private var cityDetail: [ConsolidatedWeather]? = []
    public static var cityDetailModel: DetailResultModel?
    var presenter: HomePresenterProtocol!
    private var homeApi = HomeApi()
    private var detailApi = DetailApi()
    public static var userDefaults = UserDefaults.standard
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.setValue("Cancel", forKey: "cancelButtonText")
        searchBar.placeholder = "Search Cities"
        searchBar.autocapitalizationType = .none
        return searchBar
    }()

    private lazy var tableViewList: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "gradient"))
        tableView.register(SlideTableviewCell.self, forCellReuseIdentifier: "slideCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var tableViewOfSearchBar: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.isHidden = true
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        tableView.alpha = 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layout()
        presenter?.viewDidLoad()
        getCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView = searchBar
    }

    func getCurrentLocation() {
        let lattitude = SplashViewController.userDefaults.double(forKey: "latt")
        let longitude = SplashViewController.userDefaults.double(forKey: "long")
        
        self.homeApi.fetchCurrentLocationResult(latt: String(lattitude), long: String(longitude)).done {
            [unowned self] response in
            print(response as Any)
            self.locationResults = response
            let id = response?[0].woeid ?? 0
            getCityDetail(cityId: id)
            DispatchQueue.main.async {
                self.tableViewList.reloadData()
            }
            self.tableViewList.isHidden = false
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    private func getCityDetail(cityId: Int) {
        detailApi.fetchCityDetailResult(id: String(cityId )).done { [unowned self] response in
            self.cityDetail = response.consolidatedWeather
            HomeViewController.cityDetailModel = response
            print(response as Any)
            DispatchQueue.main.async {
                self.tableViewList.reloadData()
            }
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
}

extension HomeViewController {
    
    private func layout() {
        view.backgroundColor = .white
        view.addSubview(tableViewList)
        tableViewList.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        view.addSubview(tableViewOfSearchBar)
        tableViewOfSearchBar.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        tableViewList.tableFooterView = UIView()
    }
    
    private func tableViewOfSearchBar(isVisiable: Bool) {
        isVisiable ? (tableViewOfSearchBar.isHidden = !isVisiable) : nil
        UIView.animate(withDuration: 0.3) {
            self.tableViewOfSearchBar.alpha = isVisiable ? 1 : 0
        } completion: { [unowned self]_ in
            isVisiable ? nil : (self.tableViewOfSearchBar.isHidden = !isVisiable)
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let Count = ((locationResults?.count ?? 0) + 2) > 1 ? (locationResults?.count ?? 0) + 2 : 0
        return tableView == tableViewList ? Count : (searchResults?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableViewList == tableView && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "slideCell", for: indexPath) as! SlideTableviewCell
            guard let city = cityDetail else { return UITableViewCell() }
            cell.refreshWith(cityDetail: city )
            cell.selectionStyle = .none
            return cell
        }
        else if tableViewList == tableView && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.font = .boldSystemFont(ofSize: 18)
            cell.backgroundColor = .systemGray6
            cell.textLabel?.text = "Near by you"
            cell.textLabel?.textColor = .systemGray
            cell.selectionStyle = .none
            return cell
        } else if tableViewList == tableView && indexPath.row > 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.font = .boldSystemFont(ofSize: 18)
            cell.textLabel?.text = locationResults?[indexPath.row-2].title
            cell.accessoryType = .disclosureIndicator
            cell.backgroundView = UIImageView(image: UIImage(named: "gradient"))
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            guard let search = searchResults?[indexPath.row] else { return UITableViewCell() }
            cell.textLabel?.text = search.title
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableViewList == tableView && indexPath.row == 0 {
            return screen.width
        }
        else if tableViewList == tableView && indexPath.row >= 1{
            return 75
        }
        else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == tableViewList && indexPath.row > 1 {
            let id = locationResults?[indexPath.row-2].woeid
            let title = locationResults?[indexPath.row-2].title
            let vc = DetailViewController()
            vc.cityId = id
            DetailViewController.name = title
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if tableView == tableViewOfSearchBar  {
            let cityID = searchResults?[indexPath.row].woeid
            let title = searchResults?[indexPath.row].title
            let vc = DetailViewController()
            vc.cityId = cityID
            DetailViewController.name = title
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar(searchBar: searchBar ,isEditing: false)
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar(searchBar: searchBar, isEditing: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText.lowercased()
        presenter?.searchedCity(cityName: searchText)
       if searchText.count > 1 {
            let params = SearchCityRequest(query: searchText)
            homeApi.fetchSearchedCity(query: params).done { [unowned self] response in
                self.searchResults = response
                DispatchQueue.main.async {
                    self.tableViewOfSearchBar.reloadData()
                }
            }.catch { error in
                print(error.localizedDescription)
            }
        }
    }
    
    private func searchBar(searchBar: UISearchBar, isEditing: Bool) {
        searchBar.showsCancelButton = isEditing
        _ = isEditing ? searchBar.becomeFirstResponder() :  searchBar.endEditing(true)
        tableViewOfSearchBar(isVisiable: isEditing)
    }
    
}

extension HomeViewController: HomeViewProtocol {
    func fetchCurrentLocation(response: [ResultModelElement]) {
        self.locationResults = response
        self.tableViewList.reloadData()
    }
    
    func searchedCityResponse(response: [ResultModelElement]) {
        self.tableViewOfSearchBar.reloadData()
        self.searchResults = response
    }
    
    func showError(descriptiom: String) {
        print(description)
    }
    
}
