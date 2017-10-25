//
//  HomeView.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/09/04.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class HomeView:
    UIView,
    UIScrollViewDelegate
    

{
    
    let controller: Home!
    
    var collectionView : UICollectionView!
    
    static let AppFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(controller: Home) {
        self.controller = controller
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        self.addSubview(self.layout())
        self.setUpResultView()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    private func setUpResultView() {
        

        let scrollView = UIScrollView(frame: CGRect(x: 0,
                                                    y: AppSize.height - ( AppSize.height / 5 + AppSize.tabBarHeight) - 220 ,
                                                    width: AppSize.width,
                                                    height: 175 + 50))
        
        scrollView.backgroundColor = UIColor.black
        scrollView.contentSize = CGSize(width: AppSize.width, height: 175 + 50) // 中身の大きさを設定
        
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        //        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.delegate = self
        
        defer {
            self.addSubview(scrollView)
        }


        let realm = try! Realm()
        let latestData = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: false)
        
        guard !latestData.isEmpty else { return }

        let Latestlabel = UILabel(frame: CGRect(x: AppSize.width / 2 - 100,
                                          y: 0,
                                          width: 200,
                                          height: 30))
        Latestlabel.text = "Latest Date"
        Latestlabel.textColor = .white
        Latestlabel.textAlignment = .center
        scrollView.addSubview(Latestlabel)
        
        
        let view = resultView(frame: CGRect(x: 15, y: Latestlabel.frame.maxY, width: AppSize.width - 30, height: 175))
        view.setValueToResultView(dateTime: latestData[0].date,
                                  timeValue: latestData[0].time,
                                  distance: latestData[0].distance,
                                  speed: latestData[0].speed,
                                  calorie: latestData[0].calorie
        )
        scrollView.addSubview(view)

        guard latestData.count >= 2 else { return }

        let secondlabel = UILabel(frame: CGRect(x: (AppSize.width + AppSize.width / 2) - 50,
                                                y: 0,
                                                width: 200,
                                                height: 50))
        scrollView.addSubview(secondlabel)

        
        let second = resultView(frame: CGRect(x: AppSize.width + 15 , y: secondlabel.frame.maxY, width: AppSize.width - 30, height: 175))
        second.setValueToResultView(dateTime: latestData[1].date,
                                    timeValue: latestData[1].time,
                                    distance: latestData[1].distance,
                                    speed: latestData[1].speed,
                                    calorie: latestData[1].calorie
        )
        scrollView.addSubview(second)
        
//        secondlabel.center = CGPoint(x: (second.frame.maxX - second.frame.width / 2), y: 0)
        secondlabel.text = "Seconde Date"
        secondlabel.textColor = .white
        secondlabel.textAlignment = .center
        
        scrollView.contentSize.width += AppSize.width
        

        guard latestData.count >= 3 else { return }
        
        let thirdlabel = UILabel(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 200,
                                               height: 50))
        scrollView.addSubview(thirdlabel)

        
        let third = resultView(frame: CGRect(x: (AppSize.width * 2) + 15, y: thirdlabel.frame.maxY, width: AppSize.width - 30, height: 175))
        third.setValueToResultView(dateTime: latestData[2].date,
                                   timeValue: latestData[2].time,
                                   distance: latestData[2].distance,
                                   speed: latestData[2].speed,
                                   calorie: latestData[2].calorie
        )
        
        scrollView.contentSize.width += AppSize.width
        scrollView.addSubview(third)
        
        
//        thirdlabel.center = CGPoint(x: (third.frame.maxX - third.frame.width / 2), y: 0)
        thirdlabel.text = "third Date"
        thirdlabel.textColor = .white
        thirdlabel.textAlignment = .center

    }
    

    
    private func layout() -> UICollectionView {
        let height = UIScreen.main.bounds.size.height
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (AppSize.width / 2), height: AppSize.height / 5)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .horizontal
        
        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSize(width: 5, height: height / 5)
        
        collectionView = UICollectionView(frame: CGRect(x: CGFloat(0), y: AppSize.height - ( AppSize.height / 5 + AppSize.tabBarHeight ), width: AppSize.width, height: AppSize.height / 4), collectionViewLayout: layout)
        collectionView.register(HomeCustomCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self.controller
        collectionView.dataSource = self.controller
        
        return collectionView
    }
    
    
    
     
    
    
}
