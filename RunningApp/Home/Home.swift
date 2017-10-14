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

    var launchView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        
        homeView = HomeView(controller: self)
        
        self.launchView = UIImageView(frame: self.view.frame)
        self.launchView.image = UIImage(named: "nick-west.jpg")!
        
        self.view.addSubview(self.launchView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        let view = self.view as! HomeView
        //少し縮小するアニメーション
        UIView.animate(withDuration: 0.3, delay: 1.0, options: .curveEaseOut, animations: {
            self.launchView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            
        })
        
        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.2, delay: 1.3, options: .curveEaseOut, animations: {
            self.launchView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.launchView.alpha = 0
        }, completion: { _ in
            self.launchView.removeFromSuperview()
            self.view = self.homeView
        })
        
        
        if let _ = UserDefaults.standard.object(forKey: "isInitialLogin") {
  
            let alert = UIAlertController(title: "初めまして", message: "初回設定を行って下さい", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
                print("OK")
                
//                UserDefaults.standard.set(true, forKey: "isInitialLogin")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                print("cancel")
            }))
            
            present(alert, animated: true, completion: nil)
        }
        
    }
    

    func onSender(_ path: Int) {

        let sb = UIStoryboard(name: "WorkController", bundle: nil).instantiateInitialViewController() as! ModalNavigationController
        sb.interactor = interactor
        sb.transitioningDelegate = self
        self.present(sb, animated: true, completion: nil)
 
    }
    
    public func reloadPastWorksView() {

        guard let value = UserDefaults.standard.object(forKey: Utility.getNowClockString()) as? [String: String]
        else { return }
        
        let view = self.homeView.getResultView(date: value["date"]!, time:  value["time"]!, speed: value["speed"]!, distance: value["distance"]!)
        self.view.addSubview(view)

        
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
        ]
        
        let cellImage = UIImage(named: info[path])!
        cell.imageView?.image = cellImage
        cell.textLabel?.text = info[path]
        
        return cell
    }
    
    
    /*
     Cellの総数
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
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













