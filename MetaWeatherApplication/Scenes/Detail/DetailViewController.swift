//
//  DetailViewController.swift
//  MetaWeatherApplication
//
//  Created by bora on 15.09.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    let screen = UIScreen.main.bounds
    public static var name: String?
    var cityId: Int?
    private var detailApi = DetailApi()
    private var cityDetailResult: DetailResultModel?
    private var sources: [Source]? = []
    private var cityDetail: [ConsolidatedWeather]? = []
    var presenter: DetailPresenterProtocol!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailTableviewCell.self, forCellReuseIdentifier: "detailCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.layout()
        title = DetailViewController.name
        getCityDetail()
    }
    
    private func getCityDetail() {
        detailApi.fetchCityDetailResult(id: String(cityId ?? 2344116)).done { [unowned self] response in
            self.cityDetailResult = response
            self.sources = response.sources
            self.cityDetail = response.consolidatedWeather
            print(response as Any)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.tableView.isHidden = false
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
}

extension DetailViewController {
    
    private func layout() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
}

extension DetailViewController: DetailViewProtocol {
    func selectedCityDetail(cityDetail: DetailResultModel) {
        self.cityDetailResult = cityDetail
        self.sources = cityDetail.sources
    }
    func showError(descriptiom: String) {
        print(description)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return sources?.count ?? 0
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailTableviewCell
            cell.backgroundColor = .black
            guard let city = cityDetail else { return UITableViewCell() }
            cell.refreshWith(cityDetail: city)
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = sources?[indexPath.row].title
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            return cell
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return screen.width
        }
        else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = sources?[indexPath.row].url
        if indexPath.section == 1 {
            let vc = WebViewController()
            vc.weburl = url
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: screen.width, height: 50))
        let label = UILabel.init(frame: CGRect(x: 20, y: 0, width: screen.width, height: 50))
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16)
        if section == 1 {
            view.backgroundColor = .systemGray6
            view.addSubview(label)
            label.text = "Sources"
        }
        else {
            
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else if section == 1{
            return 50
        }
        else {
            return 100
        }
    }
    
}
