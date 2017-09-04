//
//  HomeModel.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/09/04.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit

class HomeModel:
    UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UIViewControllerTransitioningDelegate {
    
    
    let interactor = Interactor()

    let vc = ViewController()
    
    var collectionView : UICollectionView!
    
    
    let height = UIScreen.main.bounds.size.height
    let width = UIScreen.main.bounds.size.width
    let AppFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    
    
//    init(_ controller: UIViewController) {
//        self.vc = controller
//    }
    
    /*
     Cellが選択時
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        onSender(indexPath.row)
    }
    

    func layout() -> UICollectionView {
        let height = UIScreen.main.bounds.size.height
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.width / 2) - 2, height: self.height / 3)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSize(width: 5, height: height / 4)
        
        collectionView = UICollectionView(frame: self.AppFrame, collectionViewLayout: layout)
        collectionView.register(HomeCustomCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }
    
    
    
    /*
     Cellに値を設定
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : HomeCustomCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MyCell",
            for: indexPath) as! HomeCustomCell
        
        
        let path = indexPath[1]
        let info = [
            "Walking",
            "Running",
            "Training",
            "Work Out"
        ]
        
        let cellImage = UIImage(named: String(path) + ".jpg" )!
        cell.imageView?.image = cellImage
        cell.textLabel?.text = info[path]
        
        //        let raisedButton = MDCRaisedButton()
        //        raisedButton.setElevation(4, for: .normal)
        //        raisedButton.setTitle(info[path], for: .normal)
        //        raisedButton.sizeToFit()
        //        raisedButton.center = cell.center
        //        self.view.addSubview(raisedButton)
        
        return cell
        
    }
    

    
    /*
     Cellの総数
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    
    func onSender(_ path: Int) {
        if path == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MaterialViewController") as! MaterialViewController
            self.vc.present(viewController, animated: true, completion: nil)
        } else {
            self.onPullModalShow()
        }
        
    }
    
    
    
    func onPullModalShow() {
        let sb = UIStoryboard(name: "ModalViewController", bundle: nil).instantiateInitialViewController() as! ModalNavigationController
        sb.interactor = interactor
        sb.transitioningDelegate = self
        self.vc.present(sb, animated: true, completion: nil)
    }
    
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    

    
}
