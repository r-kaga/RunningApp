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
    
    static let height = UIScreen.main.bounds.size.height
    static let width = UIScreen.main.bounds.size.width
    static let AppFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

//    func layout() -> UICollectionView {
//        let height = UIScreen.main.bounds.size.height
//        
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: (self.width / 2) - 2, height: self.height / 3)
//        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        layout.minimumLineSpacing = 1.0
//        layout.minimumInteritemSpacing = 1.0
//        
//        // セクション毎のヘッダーサイズ.
//        layout.headerReferenceSize = CGSize(width: 5, height: height / 4)
//        
//        collectionView = UICollectionView(frame: self.AppFrame, collectionViewLayout: layout)
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
//        collectionView.delegate = self
//        collectionView.dataSource = HomeModel()
//        
//        return collectionView
//    }

    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    required init(controller: Home) {
        self.controller = controller
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        self.addSubview(self.layout())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    func layout() -> UICollectionView {
        let height = UIScreen.main.bounds.size.height
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (HomeView.width / 2), height: HomeView.height / 3)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .horizontal
        
        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSize(width: 5, height: height / 4)
        
        collectionView = UICollectionView(frame: CGRect(x: CGFloat(0), y: HomeView.height - ( HomeView.height / 3 + AppSize.tabBarHeight ), width: HomeView.width, height: HomeView.height / 3), collectionViewLayout: layout)
        collectionView.register(HomeCustomCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self.controller
        collectionView.dataSource = self.controller
        
        return collectionView
    }
    
    
    
     
    
    
}
