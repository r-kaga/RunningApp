//
//  AppSize.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/09/25.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit

struct AppSize {
    
    static let bounds = UIScreen.main.bounds

    static let height = UIScreen.main.bounds.size.height
    
    static let width = UIScreen.main.bounds.size.width
    
    static let center = CGPoint(x: AppSize.width / 2, y: AppSize.height / 2)
    
    static var tabBarHeight: CGFloat { return 49 }
    
    static var toolBarHeight: CGFloat { return 44 }

    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    static var navigationBarHeight: CGFloat { return 44 }

//    static let navigationBarHeight = { (navigationController: UINavigationController) -> CGFloat in
//        return navigationController.navigationBar.frame.size.height
//    }
 
    static var statusBarAndNavigationBarHeight: CGFloat { return statusBarHeight + navigationBarHeight }

    
    
}
