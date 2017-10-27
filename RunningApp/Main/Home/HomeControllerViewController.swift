//
//  HomeControllerViewController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/26.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import UIKit
import RealmSwift

class HomeControllerViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var ressultOutlet: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpResultView()
    }

    
    
    private func setUpResultView() {
        
        scrollView.center = AppSize.center
        
        scrollView.backgroundColor = UIColor.black
        scrollView.contentSize = CGSize(width: ressultOutlet.frame.width, height: ressultOutlet.frame.height) // 中身の大きさを設定
        
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        //        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.delegate = self

        
        let realm = try! Realm()
        let latestData = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: false)
        
        guard !latestData.isEmpty else { return }
        
//        let Latestlabel = UILabel(frame: CGRect(x: AppSize.width / 2 - 100,
//                                                y: 0,
//                                                width: 200,
//                                                height: 30))
//        Latestlabel.text = "Latest Date"
//        Latestlabel.textColor = .white
//        Latestlabel.textAlignment = .center
//        scrollView.addSubview(Latestlabel)
//
        
        let view = resultView(frame: CGRect(x: 0, y: 0, width: AppSize.width - 30, height: ressultOutlet.frame.height))
        view.setValueToResultView(dateTime: latestData[0].date,
                                  timeValue: latestData[0].time,
                                  distance: latestData[0].distance,
                                  speed: latestData[0].speed,
                                  calorie: latestData[0].calorie
        )
        view.typeImageView.image = UIImage(named: latestData[0].workType)!
        scrollView.addSubview(view)
        
        guard latestData.count >= 2 else { return }
        
//        let secondlabel = UILabel(frame: CGRect(x: (AppSize.width + AppSize.width / 2) - 100,
//                                                y: 0,
//                                                width: 200,
//                                                height: 30))
        
        
        let second = resultView(frame: CGRect(x: AppSize.width + 15 , y: 0, width: AppSize.width - 30, height: ressultOutlet.frame.height))
        second.setValueToResultView(dateTime: latestData[1].date,
                                    timeValue: latestData[1].time,
                                    distance: latestData[1].distance,
                                    speed: latestData[1].speed,
                                    calorie: latestData[1].calorie
        )
        second.typeImageView.image = UIImage(named: latestData[1].workType)!
        scrollView.addSubview(second)
        
//        secondlabel.text = "Seconde Date"
//        secondlabel.textColor = .white
//        secondlabel.textAlignment = .center
//
        scrollView.contentSize.width += ressultOutlet.frame.width
//        scrollView.addSubview(secondlabel)
        
        
        guard latestData.count >= 3 else { return }
        
//        let thirdlabel = UILabel(frame: CGRect(x: (AppSize.width * 2 + AppSize.width / 2) - 100,
//                                               y: 0,
//                                               width: 200,
//                                               height: 30))
        
        
        let third = resultView(frame: CGRect(x: (AppSize.width * 2) + 15, y: 0, width: AppSize.width - 30, height: ressultOutlet.frame.height))
        third.setValueToResultView(dateTime: latestData[2].date,
                                   timeValue: latestData[2].time,
                                   distance: latestData[2].distance,
                                   speed: latestData[2].speed,
                                   calorie: latestData[2].calorie
        )
        third.typeImageView.image = UIImage(named: latestData[2].workType)!
        
        scrollView.contentSize.width += ressultOutlet.frame.width
        scrollView.addSubview(third)
        
        //        thirdlabel.center = CGPoint(x: (third.frame.maxX - third.frame.width / 2), y: 0)
//        thirdlabel.text = "third Date"
//        thirdlabel.textColor = .white
//        thirdlabel.textAlignment = .center
//        scrollView.addSubview(thirdlabel)
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
