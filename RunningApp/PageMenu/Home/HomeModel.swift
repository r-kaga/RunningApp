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
    UIViewController

{

    let controller = Home()
    
//    init(_ controller: UIViewController) {
//        self.vc = controller
//    }
    
    func onSender(_ path: Int) {
        if path == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MaterialViewController") as! MaterialViewController
            AppDelegate.getTopMostViewController().present(viewController, animated: true, completion: nil)
        } else {
            controller.onPullModalShow()
        }
    }
    
    

    

    
    
}
