//
//  MyPageViewController.swift
//  sampleUIViewApp
//
//  Created by 加賀谷諒 on 2017/07/16.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import UIKit
import RealmSwift

class MyPage: UIViewController, UIScrollViewDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Page"
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: AppSize.navigationBarHeight + 30,
                                                  width: AppSize.width, height: AppSize.height))
        scrollView.backgroundColor = .black
//        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
  
        
        let realm = try! Realm()
        let data = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: false)
        
        var count: CGFloat = 0
        data.forEach { (value) in
            let view = resultView(frame: CGRect(x: 15,
                                              y: (AppSize.height / 2.3) * count,
                                                width: AppSize.width - 30,
                                                height: AppSize.height / 2.5))
            
            view.setValueToResultView(dateTime: value.date,
                                      timeValue: value.time,
                                      distance: value.distance,
                                      speed: value.speed,
                                      calorie: value.calorie)
            scrollView.addSubview(view)
            
            count += 1
        }
        
        scrollView.contentSize = CGSize(width: AppSize.width, height: (AppSize.height / 2.3 + 5) * count) // 中身の大きさを設定
        self.view.addSubview(scrollView)
        
    }



}
