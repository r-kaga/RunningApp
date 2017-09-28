//
//  HomeViewController.swift
//  sampleUIViewApp
//
//  Created by 加賀谷諒 on 2017/07/16.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//


import UIKit

class Home:
    UIViewController
    
{
    
//    let homeModel =  HomeModel()
    var homeView: HomeView!

    let interactor = Interactor()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        
        homeView = HomeView(controller: self)
        self.view = self.homeView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let view = self.view as! HomeView
        //少し縮小するアニメーション
        UIView.animate(withDuration: 0.3, delay: 1.0, options: .curveEaseOut, animations: { _ in
            view.launchView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            
        })
        
        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.2, delay: 1.3, options: .curveEaseOut, animations: { _ in
            view.launchView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            view.launchView.alpha = 0
        }, completion: { _ in
            view.launchView.removeFromSuperview()
        })

    }
    

    func onSender(_ path: Int) {
        
//        let vc = WorkController(type: .run)
//        self.present(vc, animated: true, completion: nil)
        
        let viewController = UIStoryboard(name: "WorkController", bundle: nil).instantiateInitialViewController() as! WorkController
        self.present(viewController, animated: true, completion: nil)
        
//        if path == 1 {
////            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MaterialViewController") as! MaterialViewController
////            AppDelegate.getTopMostViewController().present(viewController, animated: true, completion: nil)
//
//        } else {
//            self.onPullModalShow()
//        }
        
    }
    

}


extension Home: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /*
     Cellが選択時
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        self.onSender(indexPath.row)
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
        
        return cell
    }
    
    
    /*
     Cellの総数
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    

}




extension Home: UIViewControllerTransitioningDelegate {
    
    func onPullModalShow() {
        let sb = UIStoryboard(name: "ModalViewController", bundle: nil).instantiateInitialViewController() as! ModalNavigationController
        sb.interactor = interactor
        sb.transitioningDelegate = self
        AppDelegate.getTopMostViewController().present(sb, animated: true, completion: nil)
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }

    
}













