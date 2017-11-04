//
//  UIViewController+.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/24.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {

    
    @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
        let view = sender.view as! resultView
        view.touchStartAnimation()
        view.deleteButton.isHidden = false
        view.indexPath = sender.view?.tag
 
        view.Vibrate()
        
//        switch sender.state {
//            case .began:
//                sender.view?.touchStartAnimation()
//                view.Vibrate()
//
//            case .ended, .cancelled:
//                sender.view?.touchEndAnimation()
//                self.view.layer.removeAllAnimations()
//            
//            case .changed, .failed, .possible:
//                break
//        }
    }
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        sender.view?.touchEndAnimation()
        
        let view = sender.view as! resultView
        view.deleteButton.isHidden = true
        view.deleteButton.alpha = 1
        
        view.layer.removeAllAnimations()
    }
    
    
    func refresh() {
        self.loadView()
        self.viewDidLoad()
    }
    
    
}
