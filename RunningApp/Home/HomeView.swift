//
//  HomeView.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/09/04.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit



class HomeView:
    UIView
    

{
    
    let controller: Home!
    
    var collectionView : UICollectionView!
    
//    var launchView: UIImageView!
    
    static let height = UIScreen.main.bounds.size.height
    static let width = UIScreen.main.bounds.size.width
    static let AppFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(controller: Home) {
        self.controller = controller
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        self.addSubview(self.layout())

        guard let value = UserDefaults.standard.object(forKey: Utility.getNowClockString()) as? [String: String]
        else { return }
        
        let view = resultView(frame: CGRect(x: 15, y: 100, width: AppSize.width - 30, height: AppSize.height / 4))
        view.setValueToResultView(dateTime: value["date"]!, timeValue: value["time"]!, distance: value["distance"]!, speed: value["speed"]!)
        self.addSubview(view)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    public func getResultView(date: String, time: String, speed: String, distance: String) -> UIView {
        
        let view = UIView(frame: CGRect(x: 15, y: 100, width: AppSize.width - 30, height: AppSize.height / 4))
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3))
        dateLabel.sizeToFit()
        dateLabel.center = CGPoint(x: view.frame.width /  2, y: 30)
        dateLabel.textAlignment = .center
        dateLabel.textColor = .black
        dateLabel.backgroundColor = .white
        dateLabel.text = "date"
        view.addSubview(dateLabel)
        
//        let dateValue = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3))
//        dateValue.center = CGPoint(x: view.frame.width /  2, y: dateLabel.frame.height + 10)
//        dateValue.textAlignment = .center
//        dateValue.textColor = .black
//        dateValue.backgroundColor = .white
//        dateValue.text = date
//        view.addSubview(dateValue)
        
        let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width / 3, height: view.frame.height / 4))
        timeLabel.center = CGPoint(x: view.frame.width / 6, y: view.frame.height / 1.5)
        timeLabel.textAlignment = .center
        timeLabel.textColor = .black
        timeLabel.backgroundColor = .white
        timeLabel.text = "時間"
        view.addSubview(timeLabel)

        let timeValue = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width / 3, height: view.frame.height / 4))
        timeValue.center = CGPoint(x: view.frame.width / 6, y: timeLabel.frame.maxY + 10 )
        timeValue.textAlignment = .center
        timeValue.textColor = .black
        timeValue.backgroundColor = .white
        timeValue.text = time
        view.addSubview(timeValue)

        
        let distanceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width / 3, height: view.frame.height / 4))
        distanceLabel.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 1.5)
        distanceLabel.textAlignment = .center
        distanceLabel.textColor = .black
        distanceLabel.backgroundColor = .white
        distanceLabel.text = "距離"
        view.addSubview(distanceLabel)
        
        let distanceValue = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width / 3, height: view.frame.height / 4))
        distanceValue.center = CGPoint(x: view.frame.width / 2, y: distanceLabel.frame.maxY + 10 )
        distanceValue.textAlignment = .center
        distanceValue.textColor = .black
        distanceValue.backgroundColor = .white
        distanceValue.text = distance + "Km"
        view.addSubview(distanceValue)
        
        
        let speedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width / 3, height: view.frame.height / 4))
        speedLabel.center = CGPoint(x: view.frame.width - (view.frame.width / 6), y: view.frame.height / 1.5)
        speedLabel.textAlignment = .center
        speedLabel.textColor = .black
        speedLabel.backgroundColor = .white
        speedLabel.text = "時速"
        view.addSubview(speedLabel)
        
        let speedValue = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width / 3, height: view.frame.height / 4))
        speedValue.center = CGPoint(x: view.frame.width - (view.frame.width / 6), y: speedLabel.frame.maxY + 10 )
        speedValue.textAlignment = .center
        speedValue.textColor = .black
        speedValue.backgroundColor = .white
        speedValue.text = speed
        view.addSubview(speedValue)
        
        return view
    }
    
    
    
    func layout() -> UICollectionView {
        let height = UIScreen.main.bounds.size.height
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (HomeView.width / 2), height: HomeView.height / 4)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .horizontal
        
        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSize(width: 5, height: height / 4)
        
        collectionView = UICollectionView(frame: CGRect(x: CGFloat(0), y: HomeView.height - ( HomeView.height / 4 + AppSize.tabBarHeight ), width: HomeView.width, height: HomeView.height / 4), collectionViewLayout: layout)
        collectionView.register(HomeCustomCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self.controller
        collectionView.dataSource = self.controller
        
        return collectionView
    }
    
    
    
     
    
    
}
