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
    
    @IBOutlet weak var dateTimeValueLabel: UILabel!
    
    @IBOutlet weak var timeValueLabel: UILabel!
    
    @IBOutlet weak var distanceValueLabel: UILabel!
    
    @IBOutlet weak var speedValueLabel: UILabel!
    
    @IBOutlet weak var calorieValueLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    @IBAction func deleteAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "削除してよろしいですか", message: "データは残りません", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            print("dd")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("cencel")
        }))
        
        AppDelegate.getTopMostViewController().present(alert, animated: true) {
            print("dddd")
        }

    }
    
    
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
        
        self.deleteButton.isHidden = true
        
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
    

    public func setValueToResultView(dateTime: String, timeValue: String, distance: String, speed: String, calorie: String) {
        setSpeedLabel(value: speed)
        setDateTimeLabel(value: dateTime)
        setTimeLabel(value: timeValue)
        setDistanceLabel(value: distance)
        setCalorieLabel(value: calorie)
    }
    
    public func setSpeedLabel(value: String) {
        self.speedValueLabel.text = value
    }
    
    public func setDateTimeLabel(value: String) {
        self.dateTimeValueLabel.text = value
    }
    
    public func setTimeLabel(value: String) {
        self.timeValueLabel.text = value
    }
    
    public func setDistanceLabel(value: String) {
        self.distanceValueLabel.text = value
    }
    
    public func setCalorieLabel(value: String) {
        self.calorieValueLabel.text = value
    }
    
}












