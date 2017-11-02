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
        
//        let gradient = Gradiate(frame: self.view.frame)
//        self.view.layer.addSublayer(gradient.setUpGradiate())
//        gradient.animateGradient()
        
        let scrollView = UIScrollView(frame: CGRect(x: 0,
                                                  y: AppSize.statusBarAndNavigationBarHeight,
                                                  width: AppSize.width,
                                                  height: AppSize.height))
        scrollView.backgroundColor = .clear
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        let realm = try! Realm()
        let data = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: false)
        
        var count: CGFloat = 0
        data.forEach { (value) in
            let view = resultView(frame: CGRect(x: 15,
                                              y: 30 + (170 * count),
                                                width: AppSize.width - 30,
                                                height: 150))
            
            view.setValueToResultView(dateTime: value.date,
                                      timeValue: value.time,
                                      distance: value.distance,
                                      speed: value.speed,
                                      calorie: value.calorie)
            view.typeImageView.image = UIImage(named: value.workType)!
            view.tag = Int(value.id)
            

            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MyPage.longPressed(_:)))
            view.addGestureRecognizer(longPress)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MyPage.tapGesture(_:)))
            view.addGestureRecognizer(tapGesture)
            
            scrollView.addSubview(view)
            
            count += 1
        }
        
        scrollView.contentSize = CGSize(width: AppSize.width, height: (170 * (count + 1) - 50)) // 中身の大きさを設定
        self.view.addSubview(scrollView)

    }


}
