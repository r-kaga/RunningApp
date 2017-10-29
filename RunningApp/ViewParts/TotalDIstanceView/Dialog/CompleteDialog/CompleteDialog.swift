//
//  completeDialog.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/14.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit

//class CompleteDialog: Dialog {
class CompleteDialog: UIView, DialogProtocol {

    @IBOutlet weak var completeImageView: UIImageView!
    
    /** ビュー作成
     * @return Parts
     */
    class func make() -> CompleteDialog? {
        let _ = Dialog.removeAllSuperview()
        
        let view = UINib(nibName: "CompleteDialog", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! CompleteDialog
        view.tag = 99
        
        return view
    }
    
    override func didMoveToWindow() {
        
//        UIView.animate(withDuration: 1.0, animations: {
//            self.completeImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.doStamp()

//        }) { _ in
//            self.completeImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//
//        }
    }
    
    /** タッチイベント
     * @param touches -
     * @param event -
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.close()
    }

    
}


