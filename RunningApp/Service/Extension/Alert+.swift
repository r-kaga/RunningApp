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

    /** 削除ボタン付きのアクションシートを表示
     * @param deleteAction - 削除が選択された時のclosure () -> ()
     */
    static func presentActionSheet(deleteAction: @escaping () -> () ) {
        let alert = UIAlertController(title: "削除しますか?", message: "データは残りません", preferredStyle: .actionSheet)
    
        let destory = UIAlertAction(title: "削除", style: .destructive, handler: {
            (action: UIAlertAction!) in
            deleteAction()
        })
        
        let myAction_3 = UIAlertAction(title: "キャンセル", style: .cancel, handler: {
            (action: UIAlertAction!) in
            
        })
        
        // アクションを追加.
        alert.addAction(destory)
        alert.addAction(myAction_3)
        
        AppDelegate.getTopMostViewController().present(alert, animated: true, completion: nil)
    }

    
    
}



