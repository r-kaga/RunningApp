//
//  HomeViewController.swift
//  sampleUIViewApp
//
//  Created by 加賀谷諒 on 2017/07/16.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//


import UIKit
import MaterialComponents

class Home:
    UIViewController
    
{
    let homeModel =  HomeModel()
    let homeView =  HomeView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.homeView.layout())
        
    }
    
    
    
    
    // model -> view　modalShowの伝達
    func onPullModalShow() {
        homeView.onPullModalShow()
    }
    
    // view -> model　onSenderの伝達
    func onSender(_ path: Int) {
        homeModel.onSender(path)
    }
    
    
    
    
    
}

