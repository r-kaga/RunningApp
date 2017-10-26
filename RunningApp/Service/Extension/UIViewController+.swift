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
    

    
    func longPressed(_ sender: UILongPressGestureRecognizer) {
        sender.view?.touchStartAnimation()
        let view = sender.view as! resultView
        view.deleteButton.isHidden = false
        view.indexPath = sender.view?.tag
        
//        switch sender.state {
//            case .began:
//                sender.view?.touchStartAnimation()
//            case .ended, .cancelled:
//                sender.view?.touchEndAnimation()
//            case .changed, .failed, .possible:
//                break
//        }        
    }
    
    func tapGesture(_ sender: UITapGestureRecognizer) {
        sender.view?.touchEndAnimation()
        
        let view = sender.view as! resultView
        view.deleteButton.isHidden = true
        view.deleteButton.alpha = 1
    }
    
    
    
}
