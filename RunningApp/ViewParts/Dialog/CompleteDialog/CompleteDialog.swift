//
//  completeDialog.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/14.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gradient = Gradiate(frame: self.frame)
        self.layer.addSublayer(gradient.setUpGradiate())
        gradient.animateGradient()
        
        self.bringSubview(toFront: completeImageView)
    }
    
    override func didMoveToWindow() {
        self.doStamp()
    }
    
    /** タッチイベント
     * @param touches -
     * @param event -
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.close()
    }

    
}


