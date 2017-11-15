//
//  MyPageViewController.swift
//  sampleUIViewApp
//
//  Created by 加賀谷諒 on 2017/07/16.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import UIKit

class MyPage: UIPageViewController, UIPageViewControllerDataSource, UIScrollViewDelegate {
    
    private var pageViewControllers: [UIViewController] = []
    private var button: PageMenuButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        let myInfoViewController: MyInfoViewController = MyInfoViewController()
        let myInfoCharsViewController: MyInfoCharsViewController = MyInfoCharsViewController()
        pageViewControllers = [myInfoViewController,myInfoCharsViewController]
        
        //UIPageViewControllerに表示対象を設定
        setViewControllers([pageViewControllers[0]], direction: .forward, animated: true, completion: nil)
        
        button = PageMenuButton(frame: CGRect(x: 0, y: AppSize.statusBarAndNavigationBarHeight,
                                                  width: AppSize.width, height: 40))
        button.backgroundColor = .white
//        button.grahButton.addTarget(self, action: #selector(MyPage.senderFromIndex(_:)), for: .touchUpInside)
//        button.recordButton.addTarget(self, action: #selector(MyPage.senderFromIndex(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "MyPage"
    }


    func pageViewController(_ pageViewController:
        UIPageViewController, viewControllerBefore viewController:UIViewController) -> UIViewController? {
        //右にスワイプした場合に表示したいviewControllerを返す
        //ようはページを戻す
        //今表示しているページは何ページ目か取得する
        
        let index = pageViewControllers.index(of: viewController)
        
        button.didSelect(index: index!)

        if index == 0 {
            //1ページ目の場合は何もしない
            return nil
        } else {
            //1ページ目の意外場合は1ページ前に戻す
            return pageViewControllers[index!-1]
        }
    }
    
    func pageViewController(_ pageViewController:
        UIPageViewController, viewControllerAfter viewController: UIViewController) ->
        UIViewController? {
        
            //左にスワイプした場合に表示したいviewControllerを返す
            //ようはページを進める
            //今表示しているページは何ページ目か取得する
            let index = pageViewControllers.index(of: viewController)
            
            button.didSelect(index: index!)
            
            if index == pageViewControllers.count-1 {
                //最終ページの場合は何もしない
                return nil
            } else {
                //最終ページの意外場合は1ページ進める
                return pageViewControllers[index!+1]
            }
    }
    
    
//    func senderFromIndex(_ sender: UIButton) {
//        switch sender {
//            case 1:
//                
//            case 2:
//
//            default: break
//        }
//    }
    

}


