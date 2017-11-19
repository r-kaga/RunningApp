//
//  NoDateView.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/11/02.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit

class NoDateView: UIView {
    
    /** イニシャライザー
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromNib()
    }
    
    /** Nibファイル読み込み
     */
    private func loadFromNib() {
        let view = Bundle.main.loadNibNamed("NoDateView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        
        // カスタムViewのサイズを自分自身と同じサイズにする
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints1 = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[view]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["view" : view]
        )
        self.addConstraints(constraints1)
        
        let constraints2 = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[view]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["view" : view]
        )
        self.addConstraints(constraints2)
    }
    
}




