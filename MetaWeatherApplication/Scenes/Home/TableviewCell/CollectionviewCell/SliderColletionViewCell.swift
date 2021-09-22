//
//  SliderColletionViewCell.swift
//  MetaWeatherApplication
//
//  Created by bora on 15.09.2021.
//

import UIKit

class SliderColletionViewCell: UICollectionViewCell {
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let labelState: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let imageCover: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let labelTemp: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 50)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let labelTempMin: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let labelTempMax: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let labelDate: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
 
    private func layout() {
        addSubview(labelTitle)
        labelTitle.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(30)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().inset(10)
        }
        addSubview(labelState)
        labelState.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.labelTitle.snp.bottom).offset(30)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().inset(10)
        }
        addSubview(labelTemp)
        labelTemp.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.labelState.snp.bottom).offset(20)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().inset(10)
        }
        addSubview(labelTempMin)
        labelTempMin.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.labelState.snp.bottom).offset(50)
            maker.leading.equalToSuperview().offset(70)
        }
        addSubview(labelTempMax)
        labelTempMax.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.labelState.snp.bottom).offset(50)
            maker.trailing.equalToSuperview().inset(70)
        }
        addSubview(labelDate)
        labelDate.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.labelTemp.snp.bottom).offset(30)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().inset(10)
        }
        addSubview(imageCover)
        imageCover.snp.makeConstraints { (maker) in
            maker.height.equalTo(70)
            maker.width.equalTo(70)
            maker.top.equalTo(self.labelDate.snp.bottom).offset(30)
            maker.trailing.equalToSuperview().inset(16)
            maker.leading.equalToSuperview().offset(20)
        }
     
    }
    
    func refreshWith(cityDetail: ConsolidatedWeather) {
        let title = HomeViewController.cityDetailModel?.title
        labelTitle.text = title
        labelState.text = cityDetail.weatherStateName
        let temp = Int(cityDetail.theTemp)
        let tempmin = Int(cityDetail.minTemp)
        let tempmax = Int(cityDetail.maxTemp)
        labelTemp.text = String(temp)+"°"
        labelTempMin.text = "Min:"+String(tempmin)+"°"
        labelTempMax.text = "Max:"+String(tempmax)+"°"
        let date = cityDetail.applicableDate.formatDateString()
        labelDate.text = date
        let appr = cityDetail.weatherStateAbbr
        let urlString = Constants.imageBaseUrl+appr+".png"
        let url = URL(string: urlString)
        imageCover.kf.setImage(with: url)
    }
    
}

