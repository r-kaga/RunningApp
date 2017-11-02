//
//  Dialog.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/14.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit


protocol DialogProtocol {
    func open()
    func close()
}

extension DialogProtocol where Self: UIView {
    
    
    /** addSubview
     */
    func add() {
        let app = UIApplication.shared.delegate as! AppDelegate
        self.frame = (app.window?.frame)!
        app.window?.addSubview(self)
    }
    
    /** 表示
     */
    func open() {
        self.alpha = 0.0
        
        let app = UIApplication.shared.delegate as! AppDelegate
        self.frame = (app.window?.frame)!
        app.window?.addSubview(self)
        
//        self.frame.origin.y = UIScreen.main.bounds.height
        
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1.0
//            self.frame.origin.y -= self.frame.height
       
        }, completion: { finished in
            
        })
    }
    
    /** クローズ
     */
    func close() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { finished in
            let app = UIApplication.shared.delegate as! AppDelegate
            app.window?.removeFromSuperview()
            app.window?.layer.removeAllAnimations()
        })
    }
    
    
    /*
     */
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
    
    
    func doStamp() {
        self.alpha = 0
        self.isHidden = false
        
        let stampSize = self.frame
        
        UIView.animate(withDuration: 0.05,
                       delay:0.0,
                       usingSpringWithDamping:0.2,
                       initialSpringVelocity:10,
                       options:[],animations:{
                        // サイズを大きくする
                        self.frame = CGRect(x:stampSize.origin.x,
                                              y:stampSize.origin.y,
                                              width:stampSize.size.width + 130,
                                              height:stampSize.size.height + 130)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.05,
                       delay: 0.8,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 90,
                       options: [], animations: {
                        // サイズを元に戻す
                        self.frame = CGRect(x:stampSize.origin.x,
                                              y:stampSize.origin.y,
                                              width:stampSize.size.width,
                                              height:stampSize.size.height)
                        // 透過度を元に戻す
                        self.alpha = 1.0
        },
                       completion:{ finished in
                        // 台紙を揺らす
                        self.vibrate(amount: 3.0)
        })
        
    }
    
    
    // amount = 揺れ幅
    func vibrate(amount: Float) {

        if amount > 0 {
            var animation: CABasicAnimation
            animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.duration = 0.1
            animation.fromValue = amount * Float(Double.pi) / 180.0
            animation.toValue = 0 - (animation.fromValue as! Float)
            animation.repeatCount = 1.0
            animation.autoreverses = true
            self.layer.add(animation, forKey: "VibrateAnimationKey")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.close()
            }
        
        } else {
            self.layer.removeAnimation(forKey: "VibrateAnimationKey")
            self.removeFromSuperview()
        }
        

        
    }
    
    
    
    
}



class Dialog:
    UIView
{
    static var parts: Dialog?                        // パーツインスタンス
    var stamp: String?                                // スクリプトで送信された文字列、レスポンス値に詰める
    var timer: Timer?                                // 表示コントロールタイマー
    
    internal var return_value: String?
    

    /** すべてのパーツを削除しパーツ表示
     * @return 最優先度が高いエラーページの存在 true: ある
     */
    static func removeAllSuperview() -> Bool {
        var error = false
        
        let app = UIApplication.shared.delegate as! AppDelegate
        if let window = app.window {
            for view in window.subviews {
                if view.tag == 99 {
                    error = true
                } else if view.tag == 9 {
                    let parts = view as! Dialog
                    if let _time = parts.timer {
                        _time.invalidate()
                    }
                    parts.removeFromSuperview()
                }
            }
        }
        
        return error
    }
    
    /** パーツ表示確認
     * @return true:表示中 false:非表示
     */
    static func isParts() -> Bool {
        var flg = false
        if Dialog.parts != nil {
            flg = true
        }
        return flg
    }
    
    /** 表示
     */
    func open() {
        let app = UIApplication.shared.delegate as! AppDelegate
        self.frame = (app.window?.frame)!
        app.window?.addSubview(self)
        
//        let picker: UIView? = lib_UIUtil.searchTagToUIView(tag: 10, parentView: self)
//        
//        if let view = picker {
//            view.frame.origin.y = UIScreen.main.bounds.height
//            
//            UIView.animate(withDuration: 0.2, animations: {
//                view.frame.origin.y -= view.frame.height
//            }, completion: { finished in
//            })
//            
//        } else {
//            self.alpha = 0
//            
//            UIView.animate(withDuration: 0.2, animations: {
//                self.alpha = 1
//            }, completion: { finished in
//            })
//        }
        
    }
    
    /** クローズ
     */
    func close() {
        if let _time = self.timer {
            _time.invalidate()
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { finished in
            let app = UIApplication.shared.delegate as! AppDelegate
            app.window?.removeFromSuperview()
        })
    }
    
    
}


