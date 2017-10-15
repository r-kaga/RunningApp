//
//  resultView.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/15.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class resultView: UIView {
    
    @IBOutlet weak var dateTimeValue: UILabel!
    
    @IBOutlet weak var timeValue: UILabel!
    
    @IBOutlet weak var distanceValue: UILabel!
    
    @IBOutlet weak var speedValue: UILabel!
    
    
    /** イニシャライザー
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        
        
        
        self.loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromNib()
    }
    
    
    /** Nibファイル読み込み
     */
    private func loadFromNib() {
        
        let view = Bundle.main.loadNibNamed("resultView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
    
        self.addSubview(view)
        
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
    

    public func setValueToResultView(dateTime: String, timeValue: String, distance: String, speed: String) {
        setSpeedLabel(value: speed)
        setDateTimeLabel(value: dateTime)
        setTimeLabel(value: timeValue)
        setDistanceLabel(value: distance)
    }
    
    public func setSpeedLabel(value: String) {
        self.speedValue.text = value
    }
    
    public func setDateTimeLabel(value: String) {
        self.dateTimeValue.text = value
    }
    
    public func setTimeLabel(value: String) {
        self.timeValue.text = value
    }
    
    public func setDistanceLabel(value: String) {
        self.distanceValue.text = value
    }
    
}
