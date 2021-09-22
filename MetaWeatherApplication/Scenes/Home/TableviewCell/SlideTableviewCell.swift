//
//  SlideTableviewCell.swift
//  MetaWeatherApplication
//
//  Created by bora on 15.09.2021.
//

import UIKit

class SlideTableviewCell: UITableViewCell {
    
    let screen = UIScreen.main.bounds
    private var cityDetail: [ConsolidatedWeather]?
    private var detailModel: DetailResultModel?
    var timer = Timer()
    var counter = 0
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: screen.width,
                                 height: screen.width)
        let collectionview = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0 ), collectionViewLayout: layout)
        collectionview.isPagingEnabled = true
        collectionview.register(SliderColletionViewCell.self, forCellWithReuseIdentifier: "sliderCell")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundView = UIImageView(image: UIImage(named: "gradient"))
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.showsVerticalScrollIndicator = false
        return collectionview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func changeImage() {
        DispatchQueue.main.async {
            if self.counter < self.cityDetail?.count ?? 0 {
                let index = IndexPath.init(item: self.counter, section: 0)
                self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                self.pageControl.currentPage = self.counter
                self.counter += 1
            }
            else {
                self.counter = 0
                let index = IndexPath.init(item: self.counter, section: 0)
                self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                self.pageControl.currentPage = self.counter
                self.counter = 1
            }
        }
    }
    
    private func layout() {
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
            maker.height.equalTo(screen.width)
        }
        
        contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints { (maker) in
            maker.leading.greaterThanOrEqualTo(self.snp.leading).offset(10)
            maker.trailing.lessThanOrEqualTo(self.snp.trailing).offset(-10)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(10)
            maker.height.equalTo(20)
        }
    }

    func refreshWith(cityDetail: [ConsolidatedWeather]) {
        self.cityDetail = cityDetail
        self.pageControl.numberOfPages = cityDetail.count
        self.collectionView.reloadData()
    }
    
}

//MARK: UICollectionView Delegate
extension SlideTableviewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cityDetail?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! SliderColletionViewCell
        guard let city = cityDetail?[indexPath.row] else { return UICollectionViewCell() }
        // guard let detailModel = detailModel else { return UICollectionViewCell() }
        cell.refreshWith(cityDetail: city)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            if let row = collectionView.indexPath(for: cell)?.item {
                pageControl.currentPage = row
            }
        }
    }
}
