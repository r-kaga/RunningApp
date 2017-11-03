//
//  MyInfoActionDialog.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/11/03.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit

class MyInfoActionDialog: UIView, DialogProtocol {
    
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var detailButton: UIButton!
    
    @IBAction func detailButtonAction(_ sender: Any) {
        self.dialogView.touchStartAnimation()
    }
    
    @IBAction func tapGesture(_ sender: Any) {
        self.close()
    }
    
    
    @IBOutlet weak var deleteButton: UIButton!

    @IBAction func deleteButtonAction(_ sender: Any) {
        dialogView.touchEndAnimation()
    }
    
    
    /** ビュー作成
     * @return Parts
     */
    class func make() -> MyInfoActionDialog? {
        let _ = Dialog.removeAllSuperview()
        
        let view = UINib(nibName: "MyInfoActionDialog", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! MyInfoActionDialog
        view.tag = 99
        return view
    }
    
    
    /** outlet等がインスタンス化された後に呼ばれる */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dialogView.layer.cornerRadius = 15.0
        dialogView.clipsToBounds = true
    }
    
    
    /** 表示
     */
    func open() {
        self.alpha = 0.0
        self.dialogView.alpha = 0.0

        let app = UIApplication.shared.delegate as! AppDelegate
        self.frame = (app.window?.frame)!
        app.window?.addSubview(self)
        
        self.frame.origin.y = AppSize.height
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1.0
            self.frame.origin.y -= AppSize.height
        }, completion: { finished in
            UIView.animate(withDuration: 0.3,  delay: 0.2, animations: {
                self.dialogView.alpha = 1.0
            })
        })
    }

    
}
