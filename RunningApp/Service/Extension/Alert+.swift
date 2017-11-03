//
//  Alert+.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/11/04.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit


extension UIAlertController {

    static func presentActionSheet() {
        let alert = UIAlertController(title: "タイトル", message: "message", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // アクションを生成.
        let myAction_1 = UIAlertAction(title: "Hello", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("Hello")
        })
        
        let myAction_2 = UIAlertAction(title: "yes", style: UIAlertActionStyle.destructive, handler: {
            (action: UIAlertAction!) in
            print("yes")
        })
        
        let myAction_3 = UIAlertAction(title: "no", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
            print("no")
        })
        
        // アクションを追加.
        alert.addAction(myAction_1)
        alert.addAction(myAction_2)
        alert.addAction(myAction_3)
        
        AppDelegate.getTopMostViewController().present(alert, animated: true, completion: nil)
    }

    
    
    
    
}



